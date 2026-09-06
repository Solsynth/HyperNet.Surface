//
//  ExternalLinkView.swift
//  WatchRunner Watch App
//
//  A tappable external-link row. Two actions:
//   1. "Open here" — presents the URL in an in-app web sheet on the watch via
//      `ASWebAuthenticationSession` (the one sanctioned web presenter on
//      watchOS; the SDK ships `AuthenticationServices` but not `WKWebView` or
//      `SafariServices`). The sheet's cancel control dismisses it.
//   2. "Open on phone" — hands the URL to the paired iPhone app over Watch
//      Connectivity, which routes it in-app or opens Safari there.
//
//  A bare `Link`/`openURL` to an HTTPS URL is avoided: on watchOS that routes
//  to the system's failed "view on your iPhone" Handoff when the domain isn't
//  registered.
//

import SwiftUI
import WatchKit
import WatchConnectivity

/// A compact external-link row: a link icon, the URL text, and both an in-app
/// "open here" and a "send to phone" affordance. Confirms with a haptic and a
/// status line; if the watch can't present it and no phone is reachable it
/// shows a clear message rather than failing silently.
struct ExternalLinkView: View {
    let urlString: String

    @StateObject private var webPresenter = InAppWebPresenter()
    @State private var state: SendState = .idle

    private enum SendState: Equatable {
        case idle
        case sending
        case sent
        case unreachable
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Button {
                openHere()
            } label: {
                HStack(alignment: .center, spacing: 6) {
                    Image(systemName: "globe")
                        .font(.caption)
                        .foregroundStyle(Color.accentColor)
                    Text(urlString)
                        .font(.caption)
                        .foregroundStyle(.primary)
                        .lineLimit(2)
                    Spacer(minLength: 0)
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .disabled(webPresenter.isPresenting)
            .accessibilityLabel("\(L10n.linkOpenHere): \(urlString)")

            HStack(spacing: 10) {
                Button {
                    sendToPhone()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "iphone")
                            .font(.caption)
                        Text(L10n.linkOpenOnPhone)
                            .font(.caption)
                    }
                    .foregroundStyle(state == .unreachable ? Color.orange : .secondary)
                }
                .buttonStyle(.plain)
                .disabled(state == .sending)

                statusLine
            }
        }
    }

    @ViewBuilder
    private var statusLine: some View {
        switch state {
        case .idle:
            Spacer(minLength: 0)
        case .sending:
            HStack(spacing: 4) {
                ProgressView()
                    .controlSize(.mini)
                Text(L10n.linkSendingToPhone)
                    .font(.system(size: 10))
                    .foregroundStyle(.secondary)
            }
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

    /// Presents the URL in the watch's in-app web sheet. Falls back to the
    /// phone handoff when the session can't start.
    private func openHere() {
        guard let url = URL(string: urlString) else {
            state = .unreachable
            WKInterfaceDevice.current().play(.failure)
            return
        }
        if webPresenter.present(url: url) {
            WKInterfaceDevice.current().play(.click)
        } else {
            sendToPhone()
        }
    }

    /// Hands the URL to the paired iPhone app so it can open it in Safari (or
    /// route an in-app deep link). Returns immediately; UI state reflects the
    /// outcome.
    private func sendToPhone() {
        let wc = WCSession.default
        guard wc.isReachable else {
            state = .unreachable
            WKInterfaceDevice.current().play(.failure)
            return
        }
        state = .sending
        wc.sendMessage(["request": "openUrl", "url": urlString]) { _ in
            DispatchQueue.main.async {
                state = .sent
                WKInterfaceDevice.current().play(.success)
                resetAfterDelay()
            }
        } errorHandler: { _ in
            DispatchQueue.main.async {
                state = .unreachable
                WKInterfaceDevice.current().play(.failure)
            }
        }
    }

    private func resetAfterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation { state = .idle }
        }
    }
}
