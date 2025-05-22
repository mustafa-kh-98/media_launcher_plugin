import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'media_launcher_plugin_platform_interface.dart';

class MethodChannelMediaLauncherPlugin extends MediaLauncherPluginPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('media_launcher_plugin');

  @override
  Future<bool> toSystem(String message) async {
    final Map<String, dynamic> args = <String, dynamic>{"message": message};
    final String? version =
        await methodChannel.invokeMethod(SocialShareMethods.system.name, args);
    return version == "success";
  }

  @override
  Future<bool> toTelegram(String message) async {
    final Map<String, dynamic> args = <String, dynamic>{"message": message};
    final String? version = await methodChannel.invokeMethod(
        SocialShareMethods.telegram.name, args);
    return version == "success";
  }

  @override
  Future<bool> toWhatsapp(String message) async {
    final Map<String, dynamic> args = <String, dynamic>{"message": message};
    final String? version = await methodChannel.invokeMethod(
      SocialShareMethods.whatsapp.name,
      args,
    );
    return version == "success";
  }

  @override
  Future<bool> toX(
    String message, {
    List<String>? hashtags,
    String? url,
    String? trailingText,
  }) async {
    var captionText0 = message;
    if (hashtags != null && hashtags.isNotEmpty) {
      final tags = hashtags.map((t) => '#$t ').join(' ');
      captionText0 = "$captionText0\n$tags";
    }

    String url0;
    if (url != null) {
      if (Platform.isAndroid) {
        url0 = Uri.parse(url).toString().replaceAll('#', "%23");
      } else {
        url0 = Uri.parse(url).toString();
      }
      captionText0 = "$captionText0\n$url0";
    }

    if (trailingText != null) {
      captionText0 = "$captionText0\n$trailingText";
    }

    Map<String, dynamic> args = <String, dynamic>{
      "message": "$captionText0 ",
    };
    final String? version =
        await methodChannel.invokeMethod(SocialShareMethods.x.name, args);
    return version == "success";
  }
}
