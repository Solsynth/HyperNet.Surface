//
//  ReactionSheetView.swift
//  WatchRunner Watch App
//
//  Created by LittleSheep on 2025/10/29.
//

import SwiftUI
#if os(watchOS)
import WatchKit
#endif

/// Shared reaction picker: preset sticker tiles plus a from-scratch custom
/// reaction. Renders identical UI for the post and chat reaction sheets; the
/// caller supplies counts, which reactions the current user has made, and the
/// network `onReact` implementation.
struct ReactionPickerView: View {
    let reactionsCount: [String: Int]
    let reactionsMade: [String: Bool]
    /// Performs the network react; returns true on success (the picker dismisses).
    let onReact: (String, Int) async -> Bool

    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    @State private var isReacting = false
    /// Whether the sticker pack picker (for a from-scratch reaction) is up.
    @State private var showStickerPicker = false
    /// The `prefix+slug` symbol for a newly-created reaction, or nil until the
    /// user picks a sticker.
    @State private var customSymbol: String?
    /// Attitude for the from-scratch reaction. Defaults to neutral, matching
    /// the main app's `CustomReactionForm` (`attitude = useState<int>(1)`).
    @State private var customAttitude = ReactionAttitude.neutral.rawValue
    @ObservedObject private var stickerStore = StickerStore.shared

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                customReactionSection
                reactionSection(title: L10n.reactionPositive, symbols: kPositiveReactions)
                reactionSection(title: L10n.reactionNeutral, symbols: kNeutralReactions)
                reactionSection(title: L10n.reactionNegative, symbols: kNegativeReactions)
            }
            .padding(8)
        }
        .navigationTitle(L10n.reactionReact)
        .sheet(isPresented: $showStickerPicker) {
            StickerPickerView(store: stickerStore) { pack, sticker in
                // Building the symbol on the pack's prefix + sticker's slug is
                // authoritative (nested sticker JSON carries no pack object).
                // Mirrors Flutter's `CustomReactionForm`.
                customSymbol = "\(pack.prefix)+\(sticker.slug)"
            }
            .environmentObject(appState)
        }
        .overlay {
            if isReacting {
                ProgressView()
                    .scaleEffect(0.8)
            }
        }
    }

    /// Create a brand-new reaction from scratch: pick a sticker, choose an
    /// attitude, and add it. Mirrors the main app's `CustomReactionForm` tab.
    @ViewBuilder
    private var customReactionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(L10n.reactionCustom)
                .font(.caption2)
                .foregroundStyle(.secondary)

            if let symbol = customSymbol {
                HStack(spacing: 6) {
                    StickerRenderView(identifier: symbol, dimension: 26)
                        .environmentObject(appState)
                    Text(symbol)
                        .font(.caption2)
                        .lineLimit(1)
                    Spacer(minLength: 0)
                    Button {
                        WKInterfaceDevice.current().play(.click)
                        customSymbol = nil
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(L10n.reactionClear)
                }

                Text(L10n.reactionAttitude)
                    .font(.caption2)
                    .foregroundStyle(.secondary)

                HStack(spacing: 4) {
                    attitudeButton(
                        value: ReactionAttitude.positive.rawValue,
                        label: L10n.reactionPositive,
                        icon: "hand.thumbsup"
                    )
                    attitudeButton(
                        value: ReactionAttitude.neutral.rawValue,
                        label: L10n.reactionNeutral,
                        icon: "face.smiling"
                    )
                    attitudeButton(
                        value: ReactionAttitude.negative.rawValue,
                        label: L10n.reactionNegative,
                        icon: "hand.thumbsdown"
                    )
                }

                Button {
                    Task { await submitCustomReaction() }
                } label: {
                    Text(L10n.reactionAdd)
                        .font(.caption)
                        .bold()
                }
                .disabled(isReacting)
            } else {
                Button {
                    openStickerPicker()
                } label: {
                    Label(L10n.reactionPickSticker, systemImage: "face.smiling")
                        .font(.caption)
                }
                .accessibilityHint(L10n.reactionCustomHint)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 4)
    }

    /// A single attitude option in the from-scratch flow, styled as a small
    /// tappable tile (the watch equivalent of the main app's segmented control).
    @ViewBuilder
    private func attitudeButton(value: Int, label: String, icon: String) -> some View {
        Button {
            WKInterfaceDevice.current().play(.click)
            customAttitude = value
        } label: {
            VStack(spacing: 2) {
                Image(systemName: icon)
                    .font(.system(size: 14))
                Text(label)
                    .font(.system(size: 9))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 4)
            .background(
                customAttitude == value
                    ? Color.accentColor.opacity(0.3)
                    : Color.gray.opacity(0.15)
            )
            .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityLabel(label)
        .accessibilityAddTraits(customAttitude == value ? [.isSelected] : [])
    }

    @ViewBuilder
    private func reactionSection(title: String, symbols: [String]) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption2)
                .foregroundStyle(.secondary)

            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: 56), spacing: 8)],
                spacing: 8
            ) {
                ForEach(symbols, id: \.self) { symbol in
                    reactionTile(symbol: symbol)
                }
            }
        }
    }

    /// A large sticker tile for a preset reaction: the real bundled sticker
    /// image where available, else the emoji glyph. Tapping reacts. A count
    /// badge overlays the corner; tiles the current user has reacted to get a
    /// distinct accent background and ring.
    @ViewBuilder
    private func reactionTile(symbol: String) -> some View {
        let count = reactionsCount[symbol] ?? 0
        let made = reactionsMade[symbol] ?? false
        Button {
            Task {
                await react(symbol: symbol, attitude: getReactionAttitude(symbol))
            }
        } label: {
            ReactionGlyphView(symbol: symbol, size: 52)
                .frame(width: 56, height: 56)
                .background(
                    made
                        ? Color.accentColor.opacity(0.45)
                        : Color.gray.opacity(0.12)
                )
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                // Ring the tile the current user has reacted to, so the
                // distinct background reads as "you reacted".
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .strokeBorder(
                            made ? Color.accentColor : Color.clear,
                            lineWidth: 1.5
                        )
                )
                .overlay(alignment: .topTrailing) {
                    if count > 0 {
                        Text("\(count)")
                            .font(.system(size: 9, weight: .semibold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 1)
                            .background(Capsule().fill(Color.accentColor))
                            .padding(2)
                    }
                }
        }
        .buttonStyle(.plain)
        .disabled(isReacting)
        .accessibilityLabel(getReactionIcon(symbol))
    }

    /// Loads the user's owned sticker packs, then presents the picker so it has
    /// content (or a readable empty/error state) on appearance.
    private func openStickerPicker() {
        WKInterfaceDevice.current().play(.click)
        guard let token = appState.token, let serverUrl = appState.serverUrl else { return }
        Task {
            await stickerStore.loadOwnedPacks(token: token, serverUrl: serverUrl)
            showStickerPicker = true
        }
    }

    private func submitCustomReaction() async {
        guard let symbol = customSymbol else { return }
        await react(symbol: symbol, attitude: customAttitude)
    }

    private func react(symbol: String, attitude: Int) async {
        isReacting = true
        defer { isReacting = false }
        let ok = await onReact(symbol, attitude)
        if ok { dismiss() }
    }
}

/// Post reaction sheet. Wires the shared picker to `reactToPost` and the post's
/// reaction state.
struct ReactionSheetView: View {
    let post: SnPost
    @EnvironmentObject var appState: AppState
    private let networkService = NetworkService()

    var body: some View {
        ReactionPickerView(
            reactionsCount: post.reactionsCount ?? [:],
            reactionsMade: post.reactionsMade ?? [:],
            onReact: { symbol, attitude in
                guard let token = appState.token, let serverUrl = appState.serverUrl else {
                    print("[ReactionSheetView] Missing token or serverUrl")
                    return false
                }
                do {
                    _ = try await networkService.reactToPost(
                        postId: post.id,
                        symbol: symbol,
                        attitude: attitude,
                        token: token,
                        serverUrl: serverUrl
                    )
                    return true
                } catch {
                    print("Reaction error: \(error)")
                    return false
                }
            }
        )
        .environmentObject(appState)
    }
}

/// Renders a reaction's sticker image where the watch bundles one, else the
/// emoji glyph. Shared by the reaction-sheet tiles and the compact post-card
/// pills so reactions always use the real sticker when available.
struct ReactionGlyphView: View {
    let symbol: String
    var size: CGFloat = 24
    var emojiScale: CGFloat = 0.9

    var body: some View {
        if let imageName = getReactionImageName(symbol) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
        } else {
            Text(fallbackGlyph)
                .font(.system(size: size * emojiScale))
                .frame(width: size, height: size)
        }
    }

    /// Emoji fallback for symbols without a bundled sticker. Custom sticker
    /// reactions (`prefix+slug`) can't be rendered inline here, so they use a
    /// star placeholder (matching the chat reaction chips' prior behavior).
    private var fallbackGlyph: String {
        if symbol.contains("+") { return "⭐" }
        return getReactionIcon(symbol)
    }
}
