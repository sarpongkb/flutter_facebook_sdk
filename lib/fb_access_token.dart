import 'dart:core';

import 'package:flutter/services.dart';

class FbAccessToken {
  final String appId;
  final List<String> declinedPermissions;
  final int expirationTime;
  final bool isExpired;
  final List<String> permissions;
  final int refreshTime;
  final String tokenString;
  final String userId;

  static const Map<String, dynamic> emptyTokenMap = <String, dynamic>{
    "declinedPermissions": <String>[],
    "permissions": <String>[],
  };

  static const MethodChannel _channel =
      MethodChannel('com.sarpongkb/flutter_facebook_sdk/fb_access_token');

  static Future<FbAccessToken> get currentAccessToken async {
    Map<dynamic, dynamic> token =
        await _channel.invokeMethod("getCurrentAccessToken");
    return FbAccessToken.fromMap(
      Map<String, dynamic>.from(token ?? <dynamic, dynamic>{
        "declinedPermissions": <String>[],
        "permissions": <String>[],
      }),
    );
  }

  FbAccessToken.fromMap(Map<String, dynamic> tokenMap)
      : appId = tokenMap["appId"] as String,
        declinedPermissions = tokenMap == null ? <String>[] :
            List<String>.from(tokenMap["declinedPermissions"] as List<dynamic>),
        expirationTime = tokenMap["expirationTime"] as int,
        isExpired = tokenMap["isExpired"] as bool,
        permissions = tokenMap == null ? <String>[] :
            List<String>.from(tokenMap["permissions"] as List<dynamic>),
        refreshTime = tokenMap["refreshTime"] as int,
        tokenString = tokenMap["tokenString"] as String,
        userId = tokenMap['userId'] as String;

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
