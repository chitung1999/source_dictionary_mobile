import Flutter
import UIKit
import WidgetKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    let channel = FlutterMethodChannel(
      name: "englishapp/vocabulary_widget",
      binaryMessenger: engineBridge.applicationRegistrar.messenger()
    )
    channel.setMethodCallHandler { call, result in
      guard call.method == "saveVocabulary" else {
        result(FlutterMethodNotImplemented)
        return
      }
      guard let json = call.arguments as? String,
            let container = FileManager.default.containerURL(
              forSecurityApplicationGroupIdentifier: "group.com.example.englishapp"
            ) else {
        result(FlutterError(
          code: "widget_storage_unavailable",
          message: "Could not access the vocabulary App Group.",
          details: nil
        ))
        return
      }
      let file = container.appendingPathComponent("vocabulary_words.json")
      let data = Data(json.utf8)
      do {
        if (try? Data(contentsOf: file)) != data {
          try data.write(to: file, options: [.atomic, .completeFileProtectionUntilFirstUserAuthentication])
          WidgetCenter.shared.reloadTimelines(ofKind: "VocabularyWidget")
        }
        result(nil)
      } catch {
        result(FlutterError(
          code: "widget_write_failed",
          message: error.localizedDescription,
          details: nil
        ))
      }
    }
  }
}
