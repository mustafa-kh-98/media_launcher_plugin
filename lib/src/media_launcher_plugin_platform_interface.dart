import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'media_launcher_plugin_method_channel.dart';

enum SocialShareMethods {
  whatsapp,
  telegram,
  x,
  system,
  non;
}

abstract class MediaLauncherPluginPlatform extends PlatformInterface {
  MediaLauncherPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static MediaLauncherPluginPlatform _instance =
      MethodChannelMediaLauncherPlugin();

  static MediaLauncherPluginPlatform get instance => _instance;

  static set instance(MediaLauncherPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool> toWhatsapp(final String message);

  Future<bool> toSystem(final String message);

  Future<bool> toTelegram(final String message);

  Future<bool> toX(
    final String message, {
    List<String>? hashtags,
    String? url,
    String? trailingText,
  });
}
