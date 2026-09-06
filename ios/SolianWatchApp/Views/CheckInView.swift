//
//  CheckInView.swift
//  Solian Watch App
//
//  Created by LittleSheep on 2026/09/06.
//

import SwiftUI
import Combine

/// Today's check-in on the watch. Mirrors the main app's `CheckInScreen` but
/// watch-scaled: a prompt to check in, and on success a fortune card showing
/// the level color, the poem/summary, and a compact "today's fortunes"
/// breakdown. The full 16-field report is deliberately reduced to what a watch
/// can glance at.
@MainActor
final class CheckInViewModel: ObservableObject {
    @Published private(set) var result: SnCheckInResult?
    @Published private(set) var fortune: SnFortuneSaying?
    @Published private(set) var isLoading = false
    @Published private(set) var isCheckingIn = false
    @Published var errorMessage: String?

    private let networkService = NetworkService()
    private var hasLoaded = false

    /// Loads today's check-in state (and the daily fortune) once on appear.
    func load(token: String, serverUrl: String) async {
        guard !hasLoaded, !isLoading else { return }
        hasLoaded = true
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            result = try await networkService.fetchCheckInResult(token: token, serverUrl: serverUrl)
        } catch {
            errorMessage = error.localizedDescription
        }

        // Daily fortune is advisory; failure is non-fatal.
        if let saying = try? await networkService.fetchDailyFortune(token: token, serverUrl: serverUrl) {
            fortune = saying
        }
    }

    /// Performs the daily check-in.
    func checkIn(token: String, serverUrl: String) async {
        guard !isCheckingIn else { return }
        isCheckingIn = true
        errorMessage = nil
        defer { isCheckingIn = false }

        do {
            result = try await networkService.checkIn(token: token, serverUrl: serverUrl)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    /// A user-visible retry re-fetches state (in case a prior 404 was cached).
    func reload(token: String, serverUrl: String) async {
        hasLoaded = false
        await load(token: token, serverUrl: serverUrl)
    }
}

struct CheckInView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel = CheckInViewModel()

    var body: some View {
        ScrollView {
            if viewModel.isLoading {
                ProgressView()
                    .padding(.top, 40)
            } else if let error = viewModel.errorMessage, viewModel.result == nil {
                VStack(spacing: 8) {
                    Text(L10n.checkInCouldntLoad)
                        .font(.headline)
                    Text(error)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                    Button(L10n.checkInRetry) {
                        guard let token = appState.token, let serverUrl = appState.serverUrl else { return }
                        Task { await viewModel.reload(token: token, serverUrl: serverUrl) }
                    }
                    .font(.caption)
                }
                .padding()
            } else if let result = viewModel.result {
                CheckInResultCard(
                    result: result,
                    fortune: viewModel.fortune
                )
                .padding(.horizontal)
            } else {
                CheckInPromptCard(viewModel: viewModel)
                    .padding(.horizontal)
            }
        }
        .navigationTitle(L10n.checkInTitle)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            guard let token = appState.token, let serverUrl = appState.serverUrl else { return }
            Task { await viewModel.load(token: token, serverUrl: serverUrl) }
        }
    }
}

/// The "not checked in yet" prompt: a single glanceable action.
private struct CheckInPromptCard: View {
    @ObservedObject var viewModel: CheckInViewModel
    @EnvironmentObject var appState: AppState
    @Environment(\.sizeCategory) private var sizeCategory

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 34))
                .foregroundColor(Color.accentColor)
            Text(L10n.checkInCheckInToday)
                .font(sizeCategory < .extraExtraLarge ? .headline : .title3)
                .multilineTextAlignment(.center)
            Text(descriptionText)
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Button {
                guard let token = appState.token, let serverUrl = appState.serverUrl else { return }
                Task { await viewModel.checkIn(token: token, serverUrl: serverUrl) }
            } label: {
                if viewModel.isCheckingIn {
                    ProgressView()
                } else {
                    Text(L10n.checkInCheckIn)
                        .fontWeight(.semibold)
                }
            }
            .disabled(viewModel.isCheckingIn)
            .buttonStyle(.borderedProminent)
            if let error = viewModel.errorMessage {
                Text(error)
                    .font(.caption2)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity)
    }

    private var descriptionText: String {
        L10n.checkInDescription
    }
}

/// The post-check-in fortune card. The level color carries the day's "rank".
private struct CheckInResultCard: View {
    let result: SnCheckInResult
    let fortune: SnFortuneSaying?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Level + date — the localised rank name; the numeric "Level %d"
            // prefix is intentionally dropped so the watch reads the rank only.
            VStack(alignment: .leading, spacing: 4) {
                Text(L10n.checkInLevelName(result.level))
                    .font(.headline)
                    .foregroundColor(levelColor)
                Text(String(format: L10n.checkInCheckedIn, result.createdAt.formatted(.dateTime.month(.abbreviated).day())))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Divider()

            if let report = result.fortuneReport {
                // Poem (the signature moment).
                if !report.poem.isEmpty {
                    Text(report.poem)
                        .font(.body)
                        .italic()
                        .foregroundStyle(.primary)
                        .lineSpacing(3)

                    if !report.summary.isEmpty {
                        Text(report.summary)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Divider()
                }

                // Today's fortunes — the glanceable essentials. Cells are
                // tappable to read the full value in a sheet.
                FortuneGrid(report: report)

                // Daily fortune saying (advisory).
                if let fortune = fortune, !fortune.content.isEmpty {
                    Divider()
                    Text(fortune.content)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                }

                // Tips
                if !result.tips.isEmpty {
                    Divider()
                    ForEach(result.tips) { tip in
                        TipRow(tip: tip)
                    }
                }
            } else {
                // The AI hasn't finished generating the fortune report yet.
                // Show a pending note rather than mocking a poem/tips (mirrors
                // the main app's `FallbackMessage`).
                CheckInReportPendingCard()
            }
        }
        .padding(.vertical, 8)
    }

    private var levelColor: Color {
        switch result.level {
        case 4: return Color(red: 0.784, green: 0.231, blue: 0.216) // #C83B37
        case 3: return Color(red: 0.722, green: 0.529, blue: 0.102) // #B8871A
        case 2: return Color(red: 0.267, green: 0.482, blue: 0.784) // #447BC8
        case 1: return Color(red: 0.373, green: 0.345, blue: 0.565) // #5F5890
        case 0: return Color(red: 0.412, green: 0.286, blue: 0.424) // #69496C
        case 5: return Color(red: 0.784, green: 0.369, blue: 0.455) // #C85E74
        default: return .accentColor
        }
    }
}

/// Shown when the check-in succeeded but the AI hasn't generated the fortune
/// report yet. Mirrors the main app's `FallbackMessage`: a quiet note instead
/// of a fabricated poem/tips breakdown.
private struct CheckInReportPendingCard: View {
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "hourglass")
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
            Text(L10n.checkInReportPending)
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 8)
    }
}

/// Compact two-column grid of the day's key fortunes. Each cell truncates to
/// two lines; tapping opens a sheet with the full value.
private struct FortuneGrid: View {
    let report: SnCheckInFortuneReport

    @State private var selectedItem: Item?

    struct Item: Identifiable {
        let icon: String
        let label: String
        let value: String

        var id: String { label }
    }

    private var items: [Item] {
        [
            Item(icon: "heart.fill", label: L10n.fortuneLove, value: report.love),
            Item(icon: "book.fill", label: L10n.fortuneStudy, value: report.study),
            Item(icon: "briefcase.fill", label: L10n.fortuneWork, value: report.career),
            Item(icon: "heart.circle.fill", label: L10n.fortuneHealth, value: report.health),
        ].filter { !$0.value.isEmpty }
    }

    var body: some View {
        if !items.isEmpty {
            LazyVGrid(
                columns: [GridItem(.flexible()), GridItem(.flexible())],
                spacing: 8
            ) {
                ForEach(items, id: \.label) { item in
                    Button {
                        selectedItem = item
                    } label: {
                        VStack(alignment: .leading, spacing: 2) {
                            Label(item.label, systemImage: item.icon)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(item.value)
                                .font(.caption)
                                .lineLimit(2)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(8)
                        .background(Color.gray.opacity(0.10), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                    }
                    .buttonStyle(.plain)
                }
            }
            .sheet(item: $selectedItem) { item in
                FortuneDetailSheet(item: item)
            }
        }
    }
}

/// Full-content reader for a fortune item, presented from `FortuneGrid`.
private struct FortuneDetailSheet: View {
    let item: FortuneGrid.Item

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Label(item.label, systemImage: item.icon)
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    Text(item.value)
                        .font(.body)
                        .foregroundStyle(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
            }
            .navigationTitle(item.label)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Text(L10n.checkInDone)
                    }
                }
            }
        }
    }
}

private struct TipRow: View {
    let tip: SnFortuneTip

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(spacing: 6) {
                Image(systemName: tip.isPositive ? "hand.thumbsup.fill" : "hand.thumbsdown.fill")
                    .font(.system(size: 11))
                    .foregroundColor(tip.isPositive ? Color.accentColor : Color.red)
                Text(tip.title)
                    .font(.caption)
                    .fontWeight(.semibold)
            }
            if !tip.content.isEmpty {
                Text(tip.content)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 2)
    }
}

#Preview {
    NavigationStack {
        CheckInView()
            .environmentObject(AppState())
    }
}
