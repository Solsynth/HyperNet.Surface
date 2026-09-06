
//
//  NotificationView.swift
//  WatchRunner Watch App
//
//  Created by LittleSheep on 2025/10/29.
//

import SwiftUI
import Combine
import WatchKit
import WatchConnectivity

@MainActor
class NotificationViewModel: ObservableObject {
    @Published var notifications = [SnNotification]()
    @Published var isLoading = false
    @Published var isLoadingMore = false
    @Published var errorMessage: String?
    @Published var hasMore = false

    private let networkService = NetworkService()
    private var hasFetched = false
    private var offset = 0
    private let pageSize = 20

    func fetchNotifications(token: String, serverUrl: String) async {
        if hasFetched { return }
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        hasFetched = true
        offset = 0

        do {
            let response = try await networkService.fetchNotifications(offset: offset, take: pageSize, token: token, serverUrl: serverUrl)
            self.notifications = response.notifications
            self.hasMore = response.hasMore
            offset += response.notifications.count
        } catch {
            self.errorMessage = error.localizedDescription
            print("[watchOS] fetchNotifications failed with error: \(error)")
            hasFetched = false
        }

        isLoading = false
    }

    func loadMoreNotifications(token: String, serverUrl: String) async {
        guard !isLoadingMore && hasMore else { return }
        isLoadingMore = true

        do {
            let response = try await networkService.fetchNotifications(offset: offset, take: pageSize, token: token, serverUrl: serverUrl)
            self.notifications.append(contentsOf: response.notifications)
            self.hasMore = response.hasMore
            offset += response.notifications.count
        } catch {
            self.errorMessage = error.localizedDescription
            print("[watchOS] loadMoreNotifications failed with error: \(error)")
        }

        isLoadingMore = false
    }
}

struct NotificationView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel = NotificationViewModel()

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
            } else if let errorMessage = viewModel.errorMessage {
                VStack {
                    Text(L10n.notificationsError)
                        .font(.headline)
                    Text(errorMessage)
                        .font(.caption)
                    Button(L10n.notificationsRetry) {
                        Task {
                            if let token = appState.token, let serverUrl = appState.serverUrl {
                                await viewModel.fetchNotifications(token: token, serverUrl: serverUrl)
                            }
                        }
                    }
                }
                .padding()
            } else if viewModel.notifications.isEmpty {
                Text(L10n.notificationsEmpty)
            } else {
                List {
                    ForEach(viewModel.notifications) { notification in
                        NavigationLink(destination: NotificationDetailView(notification: notification)) {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(notification.title)
                                        .font(.headline)
                                    Spacer()
                                    if notification.viewedAt == nil {
                                        Circle()
                                            .fill(Color.blue)
                                            .frame(width: 8, height: 8)
                                    }
                                }
                                if !notification.subtitle.isEmpty {
                                    Text(notification.subtitle)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                if notification.content.count > 100 {
                                    Text(notification.content.prefix(100) + "...")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                        .lineLimit(2)
                                } else {
                                    Text(notification.content)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                        .lineLimit(2)
                                }
                                Text(notification.createdAt, style: .relative)
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 8)
                        }
                    }
                    if viewModel.hasMore {
                        if viewModel.isLoadingMore {
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                        } else {
                            Button(L10n.notificationsLoadMore) {
                                Task {
                                    if let token = appState.token, let serverUrl = appState.serverUrl {
                                        await viewModel.loadMoreNotifications(token: token, serverUrl: serverUrl)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                }
            }
        }
        .onAppear {
            if appState.isReady, let token = appState.token, let serverUrl = appState.serverUrl {
                Task.detached {
                    await viewModel.fetchNotifications(token: token, serverUrl: serverUrl)
                }
            }
        }
        .navigationTitle(L10n.notificationsTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct NotificationDetailView: View {
    let notification: SnNotification

    /// The deep-link target the notification carries (e.g. `/posts/123` or a
    /// `solian://` / `https://solian.app/...` URL). The watch has no deep-link
    /// router or browser, so it's handed to the phone app, which routes it.
    private var actionUri: String? {
        notification.meta["action_uri"]?.value as? String
    }

    @State private var sendState: LinkSendState = .idle

    private enum LinkSendState: Equatable {
        case idle
        case sending
        case sent
        case unreachable
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(notification.title)
                    .font(.headline)
                
                if !notification.subtitle.isEmpty {
                    Text(notification.subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Text(notification.content)
                    .font(.body)
                
                HStack {
                    Text(notification.createdAt, style: .date)
                    Text("·")
                    Text(notification.createdAt, style: .time)
                }
                .font(.caption)
                .foregroundColor(.gray)
                
                if notification.viewedAt == nil {
                    Text(L10n.notificationsUnread)
                        .font(.caption)
                        .foregroundColor(.blue)
                }

                if let actionUri {
                    openOnPhoneRow(actionUri)
                }
            }
            .padding()
        }
        .navigationTitle(L10n.notificationsDetailTitle)
        .navigationBarTitleDisplayMode(.inline)
    }

    /// A tappable row that hands the notification's deep link to the paired
    /// iPhone app, which routes it in-app or opens it in Safari.
    private func openOnPhoneRow(_ uri: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Button {
                sendToPhone(uri)
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "iphone")
                        .font(.caption)
                        .foregroundStyle(Color.accentColor)
                    Text(L10n.linkOpenOnPhone)
                        .font(.caption)
                    Spacer(minLength: 0)
                    if sendState == .sending {
                        ProgressView()
                            .controlSize(.mini)
                    } else {
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .disabled(sendState == .sending)
            .accessibilityLabel("\(L10n.linkOpenOnPhone): \(uri)")

            switch sendState {
            case .idle:
                EmptyView()
            case .sending:
                Text(L10n.linkSendingToPhone)
                    .font(.system(size: 10))
                    .foregroundStyle(.secondary)
            case .sent:
                Text(L10n.linkOpenedOnPhone)
                    .font(.system(size: 10))
                    .foregroundStyle(.green)
            case .unreachable:
                Text(L10n.linkPhoneUnreachable)
                    .font(.system(size: 10))
                    .foregroundStyle(.orange)
            }
        }
        .padding(.top, 4)
    }

    /// Hands the deep link to the paired iPhone via Watch Connectivity. The
    /// phone's `openUrl` handler normalizes a bare `/path` into a solian web
    /// URL and routes it through the app's deep-link channel.
    private func sendToPhone(_ uri: String) {
        let wc = WCSession.default
        guard wc.isReachable else {
            sendState = .unreachable
            WKInterfaceDevice.current().play(.failure)
            return
        }
        sendState = .sending
        wc.sendMessage(["request": "openUrl", "url": uri]) { _ in
            DispatchQueue.main.async {
                sendState = .sent
                WKInterfaceDevice.current().play(.success)
            }
        } errorHandler: { _ in
            DispatchQueue.main.async {
                sendState = .unreachable
                WKInterfaceDevice.current().play(.failure)
            }
        }
    }
}
