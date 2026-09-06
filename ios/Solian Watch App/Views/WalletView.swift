//
//  WalletView.swift
//  Solian Watch App
//
//  Watch wallet overview: balance cards (pockets) and recent transactions.
//

import SwiftUI

// MARK: - Wallet View

struct WalletView: View {
    @EnvironmentObject var appState: AppState
    @State private var wallet: SnWatchWallet?
    @State private var transactions: [SnWatchTransaction] = []
    @State private var isLoading = false
    @State private var error: Error?
    @State private var showingQr = false

    private let networkService = NetworkService()

    var body: some View {
        ScrollView {
            if isLoading {
                ProgressView()
                    .padding()
            } else if let error = error {
                VStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle")
                        .foregroundColor(.red)
                    Text(error.localizedDescription)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    Button("Retry") { loadData() }
                        .font(.caption)
                }
                .padding()
            } else if let wallet = wallet {
                VStack(alignment: .leading, spacing: 12) {
                    headerSection(wallet: wallet)
                    pocketCards(pockets: wallet.pockets ?? [])
                    if !transactions.isEmpty {
                        transactionSection
                    }
                }
                .padding(.vertical, 8)
            } else {
                VStack(spacing: 8) {
                    Image(systemName: "wallet.pass")
                        .font(.title2)
                        .foregroundColor(.secondary)
                    Text(L10n.walletEmpty)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
            }
        }
        .navigationTitle(L10n.walletTitle)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showingQr = true
                } label: {
                    Image(systemName: "qrcode")
                }
                .disabled(wallet?.publicId == nil)
            }
        }
        .sheet(isPresented: $showingQr) {
            if let wallet = wallet {
                NavigationStack {
                    WalletQrView(wallet: wallet)
                }
            }
        }
        .task { loadData() }
    }

    // MARK: - Data Loading

    private func loadData() {
        guard let token = appState.token, let serverUrl = appState.serverUrl, !token.isEmpty else { return }
        isLoading = true
        error = nil
        Task {
            do {
                let w = try await networkService.fetchWallet(token: token, serverUrl: serverUrl)
                let txns = try await networkService.fetchTransactions(take: 15, token: token, serverUrl: serverUrl)
                await MainActor.run {
                    self.wallet = w
                    self.transactions = txns
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.error = error
                    self.isLoading = false
                }
            }
        }
    }

    // MARK: - Header

    private func headerSection(wallet: SnWatchWallet) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(wallet.name)
                    .font(.headline)
                if wallet.isPrimary {
                    Text(L10n.walletPrimary)
                        .font(.caption2)
                        .foregroundColor(.green)
                }
            }
            Spacer()
            if wallet.publicId != nil {
                Image(systemName: "qrcode")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal)
    }

    // MARK: - Pocket Cards

    private func pocketCards(pockets: [SnWatchWalletPocket]) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(pockets) { pocket in
                    PocketCard(pocket: pocket)
                }
            }
            .padding(.horizontal)
        }
    }

    // MARK: - Transaction Section

    private var transactionSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(L10n.walletRecentTransactions)
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.horizontal)

            ForEach(transactions) { txn in
                TransactionRow(transaction: txn, walletId: wallet?.id)
            }
        }
    }
}

// MARK: - Pocket Card

private struct PocketCard: View {
    let pocket: SnWatchWalletPocket

    private var currencyLabel: String {
        switch pocket.currency.lowercased() {
        case "golds": return L10n.walletCurrencyGolds
        case "bits": return L10n.walletCurrencyBits
        case "crystals": return L10n.walletCurrencyCrystals
        case "flames": return L10n.walletCurrencyFlames
        default: return pocket.currency.capitalized
        }
    }

    private var currencyIcon: String {
        switch pocket.currency.lowercased() {
        case "golds": return "bitcoinsign.circle.fill"
        case "bits": return "cpu.fill"
        case "crystals": return "diamond.fill"
        case "flames": return "flame.fill"
        default: return "circle.fill"
        }
    }

    private var accentColor: Color {
        switch pocket.currency.lowercased() {
        case "golds": return .yellow
        case "bits": return .blue
        case "crystals": return .purple
        case "flames": return .orange
        default: return .gray
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 4) {
                Image(systemName: currencyIcon)
                    .font(.caption2)
                    .foregroundColor(accentColor)
                Text(currencyLabel)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            Text(formatAmount(pocket.amount))
                .font(.title3)
                .fontWeight(.bold)
            if pocket.heldAmount > 0 {
                Text(String(format: L10n.walletAvailable, formatAmount(pocket.availableAmount)))
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .frame(minWidth: 90)
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.gray.opacity(0.12))
        )
    }

    private func formatAmount(_ amount: Double) -> String {
        if amount == amount.rounded() {
            return "\(Int(amount))"
        }
        return String(format: "%.2f", amount)
    }
}

// MARK: - Transaction Row

private struct TransactionRow: View {
    let transaction: SnWatchTransaction
    let walletId: String?

    private var isIncome: Bool {
        transaction.payeeWalletId == walletId
    }

    private var counterparty: String {
        let wallet = isIncome ? transaction.payerWallet : transaction.payeeWallet
        if let account = wallet?.account, !account.nick.isEmpty {
            return account.nick
        }
        return wallet?.name ?? L10n.walletUnknown
    }

    private var statusLabel: String? {
        switch transaction.status {
        case 0: return L10n.walletStatusPending
        case 1: return L10n.walletStatusFrozen
        case 3: return L10n.walletStatusRefunded
        case 4: return L10n.walletStatusCancelled
        default: return nil
        }
    }

    private var statusColor: Color {
        switch transaction.status {
        case 0: return .yellow
        case 1: return .blue
        case 2: return .green
        case 3: return .orange
        case 4: return .gray
        default: return .gray
        }
    }

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: isIncome ? "arrow.down.left" : "arrow.up.right")
                .font(.caption)
                .foregroundColor(isIncome ? .green : .red)
                .frame(width: 20)

            VStack(alignment: .leading, spacing: 1) {
                Text(counterparty)
                    .font(.caption)
                    .lineLimit(1)
                Text(transaction.createdAt, style: .relative)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 1) {
                Text("\(isIncome ? "+" : "-")\(formatAmount(transaction.amount))")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(isIncome ? .green : .red)
                if let label = statusLabel {
                    Text(label)
                        .font(.system(size: 8))
                        .foregroundColor(statusColor)
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
    }

    private func formatAmount(_ amount: Double) -> String {
        if amount == amount.rounded() {
            return "\(Int(amount))"
        }
        return String(format: "%.2f", amount)
    }
}
