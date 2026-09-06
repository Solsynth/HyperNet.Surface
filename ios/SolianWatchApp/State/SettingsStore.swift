//
//  SettingsStore.swift
//  Solian Watch App
//
//  Persists client-side settings for the watch app.
//

import SwiftUI
import Combine

@MainActor
final class SettingsStore: ObservableObject {
    static let shared = SettingsStore()

    // MARK: - Keys

    private enum Key {
        static let hapticFeedback = "settings.hapticFeedback"
        static let showTimestamps = "settings.showTimestamps"
        static let autoRefresh = "settings.autoRefresh"
        static let languageCode = "settings.languageCode"
        static let accentColorName = "settings.accentColor"
        static let backgroundImage = "settings.backgroundImage"
    }

    /// Available accent color options: display label and SwiftUI Color name.
    struct AccentColorOption: Identifiable {
        let id: String
        let label: String
        let color: Color

        var uiColor: UIColor { UIColor(color) }
    }

    static let accentColorOptions: [AccentColorOption] = [
        AccentColorOption(id: "system",  label: "System",  color: .blue),
        AccentColorOption(id: "red",     label: "Red",     color: .red),
        AccentColorOption(id: "orange",  label: "Orange",  color: .orange),
        AccentColorOption(id: "yellow",  label: "Yellow",  color: .yellow),
        AccentColorOption(id: "green",   label: "Green",   color: .green),
        AccentColorOption(id: "teal",    label: "Teal",    color: .teal),
        AccentColorOption(id: "blue",    label: "Blue",    color: .blue),
        AccentColorOption(id: "indigo",  label: "Indigo",  color: .indigo),
        AccentColorOption(id: "purple",  label: "Purple",  color: .purple),
        AccentColorOption(id: "pink",    label: "Pink",    color: .pink),
    ]

    private let defaults = UserDefaults.standard

    // MARK: - Published settings

    @Published var hapticFeedback: Bool {
        didSet { defaults.set(hapticFeedback, forKey: Key.hapticFeedback) }
    }

    @Published var showTimestamps: Bool {
        didSet { defaults.set(showTimestamps, forKey: Key.showTimestamps) }
    }

    @Published var autoRefresh: Bool {
        didSet { defaults.set(autoRefresh, forKey: Key.autoRefresh) }
    }

    @Published var languageCode: String {
        didSet {
            defaults.set(languageCode, forKey: Key.languageCode)
            let resolved = languageCode == "system" ? nil : languageCode
            OverrideBundle.setLanguage(resolved)
        }
    }

    @Published var accentColorName: String {
        didSet { defaults.set(accentColorName, forKey: Key.accentColorName) }
    }

    /// Raw JPEG data for the background image, or nil for none.
    @Published var backgroundImageData: Data? {
        didSet { defaults.set(backgroundImageData, forKey: Key.backgroundImage) }
    }

    // MARK: - Derived helpers

    var resolvedAccentColor: Color? {
        Self.accentColorOptions.first(where: { $0.id == accentColorName })?.color
    }

    /// The accent color at the given opacity, or neutral gray for system default.
    func tintColor(opacity: Double) -> Color {
        if accentColorName == "system" {
            return Color.gray.opacity(opacity)
        }
        return resolvedAccentColor!.opacity(opacity)
    }

    /// Returns a UIImage from the stored background data, or nil.
    var backgroundImage: UIImage? {
        guard let data = backgroundImageData else { return nil }
        return UIImage(data: data)
    }

    // MARK: - Background image

    /// Store a photo selected by the user, compressing to JPEG to keep
    /// UserDefaults usage reasonable (~200 KB max on watch).
    func setBackgroundImage(_ image: UIImage) {
        // Scale down to fit the watch screen (roughly 200pt wide @2x = 400px).
        let maxDimension: CGFloat = 400
        let scaled = image.predefinedScaling(maxWidth: maxDimension)
        // Compress to JPEG at 0.7 quality — good balance of size vs quality.
        backgroundImageData = scaled.jpegData(compressionQuality: 0.7)
    }

    func clearBackgroundImage() {
        backgroundImageData = nil
    }

    // MARK: - Init

    private init() {
        self.hapticFeedback = defaults.object(forKey: Key.hapticFeedback) as? Bool ?? true
        self.showTimestamps = defaults.object(forKey: Key.showTimestamps) as? Bool ?? true
        self.autoRefresh = defaults.object(forKey: Key.autoRefresh) as? Bool ?? true
        self.languageCode = defaults.string(forKey: Key.languageCode) ?? "system"
        self.accentColorName = defaults.string(forKey: Key.accentColorName) ?? "system"
        self.backgroundImageData = defaults.data(forKey: Key.backgroundImage)
    }

    // MARK: - About helpers

    var appVersion: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "?"
    }

    var buildNumber: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "?"
    }

    var bundleId: String {
        Bundle.main.bundleIdentifier ?? "unknown"
    }
}

// MARK: - UIImage helpers

private extension UIImage {
    func predefinedScaling(maxWidth: CGFloat) -> UIImage {
        let aspect = size.width / size.height
        let targetWidth = min(size.width, maxWidth)
        let targetHeight = targetWidth / aspect
        let size = CGSize(width: targetWidth, height: targetHeight)
        guard let cgImage = self.cgImage else { return self }
        let ctx = CGContext(
            data: nil,
            width: Int(targetWidth),
            height: Int(targetHeight),
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue
        )
        ctx?.draw(cgImage, in: CGRect(origin: .zero, size: size))
        guard let output = ctx?.makeImage() else { return self }
        return UIImage(cgImage: output)
    }
}
