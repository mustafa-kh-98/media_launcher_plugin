import 'media_launcher_plugin_platform_interface.dart';

abstract class MediaLauncherPlugin {
  static Future<bool> toWhatsapp(final String message) =>
      MediaLauncherPluginPlatform.instance.toWhatsapp(message);

  static Future<bool> toSystem(final String message) =>
      MediaLauncherPluginPlatform.instance.toSystem(message);

  static Future<bool> toTelegram(final String message) =>
      MediaLauncherPluginPlatform.instance.toTelegram(message);

  static Future<bool> toX(
    final String message, {
    List<String>? hashtags,
    String? url,
    String? trailingText,
  }) =>
      MediaLauncherPluginPlatform.instance.toX(
        message,
        hashtags: hashtags,
        url: url,
        trailingText: trailingText,
      );
}
