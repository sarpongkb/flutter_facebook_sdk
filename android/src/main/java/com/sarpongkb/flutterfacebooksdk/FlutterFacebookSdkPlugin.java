package com.sarpongkb.flutterfacebooksdk;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import com.facebook.AccessToken;
import com.facebook.CallbackManager;
import com.facebook.login.LoginBehavior;
import com.facebook.login.LoginManager;

/** FlutterFacebookSdkPlugin */
public class FlutterFacebookSdkPlugin implements MethodCallHandler {
  private LoginBehavior loginBehavior;

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "com.sarpongkb/flutter_facebook_sdk");
    channel.setMethodCallHandler(new FlutterFacebookSdkPlugin());
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else if (call.method.equals("isLoggedIn")) {
      isLoggedIn(call, result);
    } else {
      result.notImplemented();
    }
  }

  private void isLoggedIn(MethodCall call, Result result) {
    AccessToken accessToken = AccessToken.getCurrentAccessToken();
    boolean isLoggedIn = accessToken != null && !accessToken.isExpired();
    result.success(isLoggedIn);
  }

}
