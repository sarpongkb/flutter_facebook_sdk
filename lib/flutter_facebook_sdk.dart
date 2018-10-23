import 'dart:async';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

class FacebookSdk {
  static const MethodChannel _channel =
      MethodChannel('com.sarpongkb/flutter_facebook_sdk');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<bool> isLoggedIn() async {
    bool loggedIn = await _channel.invokeMethod("isLoggedIn");
    return loggedIn;
  }

  static Future<FacebookLoginResult> logInWithReadPermissions(
    List<String> permissions,
  ) async {
    Map<dynamic, dynamic> res = await _channel.invokeMethod(
      "logInWithReadPermissions",
      {"readPermissions": permissions},
    );

    String status = res["status"];

    if (status == "ERROR") {
      String errorMessage = res["errorMessage"];
      return FacebookLoginResult.error(errorMessage);
    } else if (status == "CANCELED") {
      return FacebookLoginResult.canceled();
    } else {
      Map<dynamic, dynamic> token = res["accessToken"];
      final FacebookAccessToken accessToken = FacebookAccessToken(
        declinedPermissions: token["declinedPermissions"] as List<dynamic>,
        expirationDate: token["expirationDate"].toString(),
        isExpired: token["isExpired"] as bool,
        permissions: token["permissions"] as List<dynamic>,
        tokenString: token["tokenString"].toString(),
        userId: token['userId'].toString(),
      );
      return FacebookLoginResult.loggedIn(accessToken);
    }
  }
}

class FacebookLoginResult {
  final FacebookLoginStatus status;
  final FacebookAccessToken accessToken;
  final String errorMessage;

  FacebookLoginResult.canceled()
      : status = FacebookLoginStatus.CANCELED,
        errorMessage = "Canceled by user",
        accessToken = null;

  FacebookLoginResult.loggedIn(this.accessToken)
      : status = FacebookLoginStatus.LOGGED_IN,
        errorMessage = null;

  FacebookLoginResult.error(this.errorMessage)
      : status = FacebookLoginStatus.ERROR,
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

enum FacebookLoginStatus {
  CANCELED,
  LOGGED_IN,
  ERROR,
}

class FacebookAccessToken {
  final String tokenString;
  final String expirationDate;
  final bool isExpired;
  final String userId;
  final List<dynamic> permissions;
  final List<dynamic> declinedPermissions;

  const FacebookAccessToken({
    @required this.tokenString,
    @required this.expirationDate,
    @required this.isExpired,
    @required this.userId,
    @required this.permissions,
    @required this.declinedPermissions,
  });

  @override
  String toString() {
    return "{"
        "tokenString: $tokenString, "
        "expirationDate: $expirationDate, "
        "isExpired: $isExpired, "
        "userId: $userId, "
        "permissions: ${permissions.toString()}, "
        "declinedPermissions: ${declinedPermissions.toString()}"
        "}";
  }
}
