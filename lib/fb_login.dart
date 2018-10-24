import 'dart:async';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

class FbLogin {
  static const MethodChannel _channel =
      MethodChannel('com.sarpongkb/flutter_facebook_sdk/fb_login');

  static Future<bool> isLoggedIn() async {
    bool loggedIn = await _channel.invokeMethod("isLoggedIn");
    return loggedIn;
  }

  static Future<FbLoginResult> logInWithReadPermissions(
    List<String> permissions,
  ) async {
    Map<dynamic, dynamic> res = await _channel.invokeMethod(
      "logInWithReadPermissions",
      {"readPermissions": permissions},
    );

    String status = res["status"];

    if (status == "ERROR") {
      String errorMessage = res["errorMessage"];
      return FbLoginResult.error(errorMessage);
    } else if (status == "CANCELED") {
      return FbLoginResult.canceled();
    } else {
      Map<dynamic, dynamic> token = res["accessToken"];
      final FbAccessToken accessToken = FbAccessToken(
        appId: token["appId"] as String,
        declinedPermissions: List<String>.from(token["declinedPermissions"] as List<dynamic>),
        expirationTime: token["expirationTime"] as int,
        isExpired: token["isExpired"] as bool,
        permissions: List<String>.from(token["permissions"] as List<dynamic>),
        refreshTime: token["refreshTime"] as int,
        tokenString: token["tokenString"] as String,
        userId: token['userId'] as String,
      );
      return FbLoginResult.loggedIn(accessToken);
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

enum FbLoginStatus {
  CANCELED,
  LOGGED_IN,
  ERROR,
}

class FbAccessToken {
  final String appId;
  final List<String> declinedPermissions;
  final int expirationTime;
  final bool isExpired;
  final List<String> permissions;
  final int refreshTime;
  final String tokenString;
  final String userId;

  const FbAccessToken({
    @required this.appId,
    @required this.declinedPermissions,
    @required this.expirationTime,
    @required this.isExpired,
    @required this.permissions,
    @required this.refreshTime,
    @required this.tokenString,
    @required this.userId,
  })  : assert(appId != null),
        assert(declinedPermissions != null),
        assert(expirationTime != null),
        assert(isExpired != null),
        assert(permissions != null),
        assert(refreshTime != null),
        assert(tokenString != null),
        assert(userId != null);

  @override
  String toString() {
    return "{"
        "appId: $appId, "
        "declinedPermissions: ${declinedPermissions.toString()}, "
        "expirationTime: $expirationTime, "
        "isExpired: $isExpired, "
        "permissions: ${permissions.toString()}, "
        "refreshTime: $refreshTime, "
        "tokenString: $tokenString, "
        "userId: $userId"
        "}";
  }
}
