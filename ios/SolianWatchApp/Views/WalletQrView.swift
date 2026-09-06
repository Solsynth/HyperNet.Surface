//
//  WalletQrView.swift
//  Solian Watch App
//
//  Displays the wallet's public transfer ID as a QR code. The QR encodes a
//  Solian deep link (`solian://wallet/transfer/<publicId>`) so the phone app
//  can parse it directly.
//

import SwiftUI

struct WalletQrView: View {
    let wallet: SnWatchWallet

    @State private var qrImage: UIImage?

    private let qrSize: CGFloat = 150

    /// The QR payload: the wallet's public transfer link (matches the phone
    /// app's `buildWalletTransferQrData`).
    private var qrPayload: String {
        guard let publicId = wallet.publicId else { return "" }
        var components = URLComponents()
        components.scheme = "solian"
        components.host = "wallet"
        components.path = "/transfer"
        components.queryItems = [
            URLQueryItem(name: "publicId", value: publicId),
        ]
        return components.url?.absoluteString ?? ""
    }

    private var displayId: String {
        wallet.publicId ?? "N/A"
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // QR code
                if let qrImage {
                    Image(uiImage: qrImage)
                        .resizable()
                        .interpolation(.none)
                        .scaledToFit()
                        .frame(width: qrSize, height: qrSize)
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(Color.white)
                        )
                } else if wallet.publicId == nil {
                    VStack(spacing: 8) {
                        Image(systemName: "lock.slash")
                            .font(.title2)
                            .foregroundColor(.secondary)
                        Text(L10n.walletQrPublicIdNotEnabled)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(L10n.walletQrPublicIdNotEnabledHint)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                } else {
                    ProgressView()
                        .frame(width: qrSize, height: qrSize)
                }

                // Public ID display
                VStack(spacing: 4) {
                    Text(L10n.walletQrPublicIdLabel)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Text(displayId)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                        .truncationMode(.middle)
                }

                // Wallet name
                HStack(spacing: 6) {
                    Image(systemName: "wallet.pass.fill")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Text(wallet.name)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                // Share button
                if wallet.publicId != nil {
                    ShareLink(item: URL(string: qrPayload) ?? URL(string: "https://solian.app")!) {
                        Label(L10n.walletQrCopyLink, systemImage: "square.and.arrow.up")
                            .font(.caption)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .tint(.accentColor)
                }
            }
            .padding()
        }
        .navigationTitle(L10n.walletQrTitle)
        .task {
            generateQr()
        }
    }

    private func generateQr() {
        guard !qrPayload.isEmpty,
              let qr = try? QRCode.encode(text: qrPayload, ecl: .high) else { return }
        qrImage = renderQRImage(from: qr, dimension: qrSize)
    }
}

// MARK: - QR Renderer (same as AccountQrView)

/// Renders a vendored `QRCode` matrix to a `UIImage` at the given point size.
private func renderQRImage(from qr: QRCode, dimension: CGFloat) -> UIImage? {
    let modules = qr.size
    guard modules > 0 else { return nil }
    let modulePx = dimension / CGFloat(modules)
    let size = CGSize(width: dimension, height: dimension)
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
    guard let ctx = CGContext(
        data: nil,
        width: Int(dimension),
        height: Int(dimension),
        bitsPerComponent: 8,
        bytesPerRow: 0,
        space: colorSpace,
        bitmapInfo: bitmapInfo.rawValue
    ) else { return nil }

    ctx.setFillColor(UIColor.white.cgColor)
    ctx.fill(CGRect(origin: .zero, size: size))

    for y in 0..<modules {
        for x in 0..<modules {
            if qr.getModule(x: x, y: y) {
                ctx.setFillColor(UIColor.black.cgColor)
                ctx.fill(CGRect(
                    x: CGFloat(x) * modulePx,
                    y: CGFloat(y) * modulePx,
                    width: modulePx,
                    height: modulePx
                ))
            }
        }
    }

    guard let cgImage = ctx.makeImage() else { return nil }
    return UIImage(cgImage: cgImage)
}
