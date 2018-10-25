import 'dart:async';

import 'package:flutter/services.dart';

import "fb_access_token.dart";

class FbLogin {
  static const MethodChannel _channel =
      MethodChannel('com.sarpongkb/flutter_facebook_sdk/fb_login');

  static Future<FbAccessToken> getCurrentAccessToken() async {
    Map<dynamic, dynamic> token =
        await _channel.invokeMethod("getCurrentAccessToken");
    return FbAccessToken.fromMap(Map<String, dynamic>.from(token));
  }

  static Future<bool> isLoggedIn() async {
    bool loggedIn = await _channel.invokeMethod("isLoggedIn");
    return loggedIn;
  }

  static Future<FbLoginResult> logInWithPublishPermissions(
      List<String> permissions,
      {FbLoginBehavior behavior}) async {
    Map<dynamic, dynamic> result = await _channel.invokeMethod(
      "logInWithPublishPermissions",
      {
        "permissions": permissions,
        "behavior": behavior,
      },
    );
    return _handleLoginResult(result);
  }

  static Future<FbLoginResult> logInWithReadPermissions(
      List<String> permissions,
      {FbLoginBehavior behavior}) async {
    Map<dynamic, dynamic> result = await _channel.invokeMethod(
      "logInWithReadPermissions",
      {
        "permissions": permissions,
        "behavior": behavior,
      },
    );
    return _handleLoginResult(result);
  }

  static Future<void> logOut() => _channel.invokeMethod("logOut");

  static FbLoginResult _handleLoginResult(Map<dynamic, dynamic> loginResult) {
    String status = loginResult["status"];

    if (status == "ERROR") {
      String errorMessage = loginResult["errorMessage"];
      return FbLoginResult.error(errorMessage);
    } else if (status == "CANCELED") {
      return FbLoginResult.canceled();
    } else {
      Map<String, dynamic> tokenMap = Map<String, dynamic>.from(
        loginResult["accessToken"] as Map<dynamic, dynamic>,
      );
      return FbLoginResult.loggedIn(FbAccessToken.fromMap(tokenMap));
    }
  }
}

class FbLoginResult {
  final FbLoginStatus status;
  final FbAccessToken accessToken;
  final String errorMessage;

  FbLoginResult.canceled()
      : status = FbLoginStatus.CANCELED,
        errorMessage = "Canceled by user",
        accessToken = null;

  FbLoginResult.loggedIn(this.accessToken)
      : status = FbLoginStatus.LOGGED_IN,
        errorMessage = null;

  FbLoginResult.error(this.errorMessage)
      : status = FbLoginStatus.ERROR,
        accessToken = null;

  @override
  String toString() {
    return "{"
        "status: ${status.toString()}, "
        "accessToken: ${accessToken.toString()}, "
        "errorMessage: $errorMessage"
        "}";
  }
}

class FbLoginBehavior {
  FbLoginBehavior._();

  static final String nativeOnly = "NATIVE_ONLY";
  static final String nativeWithFallBack = "NATIVE_WITH_FALLBACK";
  static final String webOnly = "WEB_ONLY";
  static final String webViewOnly = "WEB_VIEW_ONLY";
//  static final String deviceAuth = "DEVICE_AUTH";
//  static final String dialogOnly = "DIALOG_ONLY";
//  static final String katanaOnly = "KATANA_ONLY";
}

enum FbLoginStatus {
  CANCELED,
  LOGGED_IN,
  ERROR,
}
