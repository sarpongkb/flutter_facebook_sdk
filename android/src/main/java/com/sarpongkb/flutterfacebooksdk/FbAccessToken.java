package com.sarpongkb.flutterfacebooksdk;

import com.facebook.AccessToken;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

public class FbAccessToken {

  public static Map<String, Object> parsedToken(AccessToken token) {
    Map<String, Object> accessToken = new HashMap<>();

    if (token != null) {
      accessToken.put("appId", token.getApplicationId());
      accessToken.put("declinedPermissions", new ArrayList<>(token.getDeclinedPermissions()));
      accessToken.put("expirationTime", token.getExpires().getTime());
      accessToken.put("isExpired", token.isExpired());
      accessToken.put("permissions", new ArrayList<>(token.getPermissions()));
      accessToken.put("refreshTime", token.getLastRefresh().getTime());
      accessToken.put("tokenString", token.getToken());
      accessToken.put("userId", token.getUserId());
    }

    return accessToken;
  }
}
