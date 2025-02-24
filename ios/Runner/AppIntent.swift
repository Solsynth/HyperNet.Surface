//
//  AppIntent.swift
//  Runner
//
//  Created by LittleSheep on 2024/12/21.
//

import AppIntents
import Flutter
import Foundation
import home_widget

@available(iOS 17, *)
public struct AppBackgroundIntent: AppIntent {
   static public var title: LocalizedStringResource = "Solar Network Background Intent"

   @Parameter(title: "Widget URI")
   var url: URL?

   @Parameter(title: "AppGroup")
   var appGroup: String?

   public init() {}

   public init(url: URL?, appGroup: String?) {
      self.url = url
      self.appGroup = appGroup
   }

   public func perform() async throws -> some IntentResult {
      await HomeWidgetBackgroundWorker.run(url: url, appGroup: appGroup!)

      return .result()
   }
}

@available(iOS 17, *)
@available(iOSApplicationExtension, unavailable)
extension AppBackgroundIntent: ForegroundContinuableIntent {}
