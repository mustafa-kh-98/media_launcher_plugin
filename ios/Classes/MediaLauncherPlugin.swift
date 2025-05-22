import Flutter
import Foundation
import UIKit

enum SocialShareMethods: String {
    case whatsapp
    case telegram
    case x
    case system
    case non

    static func getSocialShareMethod(from name: String) -> SocialShareMethods {
        return SocialShareMethods(rawValue: name) ?? .non
    }
}

public class MediaLauncherPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "media_launcher_plugin", binaryMessenger: registrar.messenger())
        let instance = MediaLauncherPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let method = call.method as? String else {
            result(
                FlutterError(code: "INVALID_METHOD", message: "Method not recognized", details: nil)
            )
            return
        }

        let content = call.arguments as? [String: Any]
        let text = content?["message"] as? String
        let meth: SocialShareMethods = SocialShareMethods.getSocialShareMethod(from: method)

        switch meth {
        case .whatsapp:
            return whenWhtsapp(result: result, text: text)
        case .telegram:
            return whenTelegram(result: result, text: text)
        case .x:
            return whenX(result: result, text: text)
        case .system:
            return whenSystem(result: result, text: text)

        default:
            result(FlutterMethodNotImplemented)
        }

    }

    private func whenWhtsapp(result: @escaping FlutterResult, text: String?) {
        if let content = text {
            let urlWhats = "whatsapp://send?text=\(content)"
            if let whatsappURL = URL(
                string: urlWhats.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                    ?? "")
            {
                if UIApplication.shared.canOpenURL(whatsappURL) {
                    UIApplication.shared.open(whatsappURL)
                    result("success")
                } else {
                    result("error: WhatsApp not installed")
                }
            }
        } else {
            result("No content to share")
        }
    }

    private func whenTelegram(result: @escaping FlutterResult, text: String?) {
        if let content = text {
            let urlScheme = "tg://msg?text=\(content)"
            if let telegramURL = URL(
                string: urlScheme.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                    ?? "")
            {
                if UIApplication.shared.canOpenURL(telegramURL) {
                    UIApplication.shared.open(telegramURL)
                    result("success")
                } else {
                    result("error: Telegram not installed")
                }
            }
        } else {
            result("No content to share")
        }
    }

   private func whenSystem(result: @escaping FlutterResult, text: String?) {
       if let content = text {
           let activityViewController = UIActivityViewController(
               activityItems: [content], applicationActivities: nil)

           var rootViewController = UIApplication.shared.keyWindow?.rootViewController

           if #available(iOS 13.0, *), rootViewController == nil {
               if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first {
                   rootViewController = window.rootViewController
               }
           }

           if let rootVC = rootViewController {
               rootVC.present(activityViewController, animated: true) {
                   result("success")
               }
           } else {
               result("error: Could not present share sheet")
           }
       } else {
           result("No content to share")
       }
   }

   private func whenX(result: @escaping FlutterResult, text: String?) {
           if let content = text {
               let twitterAppURLScheme = "twitter://post?message=\(content)"
               let appStoreLink = "itms-apps://itunes.apple.com/us/app/apple-store/id333903271"

               if let twitterURL = URL(string: "twitter://"),
                  UIApplication.shared.canOpenURL(twitterURL)
               {
                   if let encodedURLScheme = URL(
                       string: twitterAppURLScheme.addingPercentEncoding(
                           withAllowedCharacters: .urlQueryAllowed) ?? "")
                   {
                       UIApplication.shared.open(encodedURLScheme, options: [:]) { success in
                           result(success ? "success" : "error: Failed to open Twitter/X")
                       }
                   } else {
                       result("error: Invalid URL encoding")
                   }
               } else {
                   if let appStoreURL = URL(string: appStoreLink) {
                       UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
                       result("error: Twitter/X app not installed, opened App Store")
                   } else {
                       result("error: Invalid App Store URL")
                   }
               }
           } else {
               result("No content to share")
           }
       }
}
