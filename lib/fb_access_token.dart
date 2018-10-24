import 'dart:core';

class FbAccessToken {
  final String appId;
  final List<String> declinedPermissions;
  final int expirationTime;
  final bool isExpired;
  final List<String> permissions;
  final int refreshTime;
  final String tokenString;
  final String userId;

//  const FbAccessToken({
//    @required this.appId,
//    @required this.declinedPermissions,
//    @required this.expirationTime,
//    @required this.isExpired,
//    @required this.permissions,
//    @required this.refreshTime,
//    @required this.tokenString,
//    @required this.userId,
//  })  : assert(appId != null),
//        assert(declinedPermissions != null),
//        assert(expirationTime != null),
//        assert(isExpired != null),
//        assert(permissions != null),
//        assert(refreshTime != null),
//        assert(tokenString != null),
//        assert(userId != null);

  FbAccessToken.fromMap(Map<String, dynamic> tokenMap)
      : appId = tokenMap["appId"] as String,
        declinedPermissions =
            List<String>.from(tokenMap["declinedPermissions"] as List<dynamic>),
        expirationTime = tokenMap["expirationTime"] as int,
        isExpired = tokenMap["isExpired"] as bool,
        permissions =
            List<String>.from(tokenMap["permissions"] as List<dynamic>),
        refreshTime = tokenMap["refreshTime"] as int,
        tokenString = tokenMap["tokenString"] as String,
        userId = tokenMap['userId'] as String {
    assert(appId != null);
    assert(declinedPermissions != null);
    assert(expirationTime != null);
    assert(isExpired != null);
    assert(permissions != null);
    assert(refreshTime != null);
    assert(tokenString != null);
    assert(userId != null);
  }

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
