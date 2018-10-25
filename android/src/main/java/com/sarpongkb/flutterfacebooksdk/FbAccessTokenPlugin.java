package com.sarpongkb.flutterfacebooksdk;

import com.facebook.AccessToken;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.PluginRegistry;

public class FbAccessTokenPlugin  implements MethodCallHandler {
  private static final String CHANNEL_NAME = "com.sarpongkb/flutter_facebook_sdk/fb_access_token";

  /** Plugin registration. */
  static void registerWith(PluginRegistry.Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), CHANNEL_NAME);
    channel.setMethodCallHandler(new FbAccessTokenPlugin());
  }

  static Map<String, Object> parsedToken(AccessToken token) {
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

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("getCurrentAccessToken")) {
      AccessToken token = AccessToken.getCurrentAccessToken();
      result.success(token == null ? null : FbAccessTokenPlugin.parsedToken(token));
    } else {
      result.notImplemented();
    }
  }
}
