import 'dart:async';

import 'package:flutter/services.dart';

class FlutterFacebookSdk {
  static const MethodChannel _channel =
      const MethodChannel('com.sarpongkb/flutter_facebook_sdk');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<bool> isLoggedIn() async {
    bool loggedIn = await _channel.invokeMethod("isLoggedIn");
    return loggedIn;
  }
}
