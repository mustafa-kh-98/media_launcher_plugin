# media_launcher_plugin

A Flutter plugin to launch and share text messages directly to WhatsApp, Telegram, X (Twitter), or via the system share sheet.

## ✨ Features

- 📤 Share text messages to:
    - WhatsApp
    - Telegram
    - X (Twitter) as Posts
    - iOS system share sheet

---

## 🔧 iOS Setup

To enable this plugin to check for installed apps on iOS, you must add the required URL schemes to your `Info.plist` file.

Open your iOS project at `ios/Runner/Info.plist` and add the following:

```xml
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>whatsapp</string>
    <string>tg</string>
    <string>twitter</string>
</array>
```

This allows the plugin to detect if WhatsApp, Telegram, or Twitter (X) is installed on the device before attempting to launch.

---

## 🚀 Usage

### 1. Add to ```pubspec.yaml```

```yaml
  media_launcher_plugin:
    git: https://github.com/mustafa-kh-98/media_launcher_plugin.git
```

### 2. Import the plugin

```dart
import 'package:media_launcher_plugin/media_launcher_plugin.dart';
```

### 3. Call one of the available methods

```dart
MediaLauncherPlugin.toWhatsapp("Hello from my app!");
MediaLauncherPlugin.toTelegram("Join my channel on Telegram!");
MediaLauncherPlugin.toX("Just posted from my Flutter app!");
MediaLauncherPlugin.toSystem("This is a system share!");
```

---

## 📱 Platform Support

| Platform | Support    |
|----------|------------|
| iOS      | ✅ Tested   |
| Android  | ✅ Tested  |

---

## ⚠️ Notes

- This plugin uses `URL schemes` to open external apps, which means it must be tested on a **real device** (not a simulator).
- Ensure WhatsApp, Telegram, or X (Twitter) is installed on the device.
- X may redirect to the App Store if the app isn't available or is not installed.
- Always encode the message properly before sending (this is handled internally by the plugin).

---

## 🧑‍💻 Contributing

Contributions are welcome! Feel free to open issues or pull requests for:
- New features
- Bug fixes
- Improvements to documentation

---



