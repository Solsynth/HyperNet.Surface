//
//  InAppWebView.swift
//  WatchRunner Watch App
//
//  Presents a web page on watchOS using `ASWebAuthenticationSession` — the one
//  sanctioned in-app web presenter on watch (the watchOS SDK ships
//  `AuthenticationServices` but not `WKWebView` / `SafariServices`). It drives
//  the same signed web session with an opaque callback; the user can browse and
//  dismiss via the sheet's cancel control.
//

import SwiftUI
import Combine
import AuthenticationServices

/// A thin observable wrapper around `ASWebAuthenticationSession` so SwiftUI
/// views can launch it and observe whether the sheet is active. A single
/// session is presented at a time; presenting again replaces it.
@MainActor
final class InAppWebPresenter: NSObject, ObservableObject {
    @Published private(set) var isPresenting = false

    @discardableResult
    func present(url: URL) -> Bool {
        let http = url.scheme == "http" || url.scheme == "https"
        guard http else {
            print("[watchOS] ASWebAuthenticationSession only supports http(s) URLs")
            return false
        }
        // A callback scheme is required by the API. For a plain web page there
        // is no auth redirect, so completion fires when the user dismisses.
        let session = ASWebAuthenticationSession(
            url: url,
            callbackURLScheme: "solian",
            completionHandler: { [weak self] _, error in
                Task { @MainActor in
                    self?.isPresenting = false
                    if let error {
                        print("[watchOS] Web session ended: \(error.localizedDescription)")
                    }
                }
            }
        )
        // Avoid the "this app wants to use your Apple ID" privacy re-auth
        // prompt when merely viewing a page.
        session.prefersEphemeralWebBrowserSession = true
        self.session = session
        let ok = session.start()
        isPresenting = ok
        return ok
    }

    private var session: ASWebAuthenticationSession?
}
