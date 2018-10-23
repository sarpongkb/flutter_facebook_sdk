package com.sarpongkb.flutterfacebooksdk;

import com.facebook.AccessToken;
import com.facebook.CallbackManager;
import com.facebook.login.LoginManager;

import java.util.List;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** FlutterFacebookSdkPlugin */
public class FlutterFacebookSdkPlugin implements MethodCallHandler {
  // private LoginBehavior loginBehavior;
  private final Registrar registrar;
  private final CallbackManager callbackManager = CallbackManager.Factory.create();
  private final LoginResultDelegate loginResultDelegate = new LoginResultDelegate(callbackManager);

  public FlutterFacebookSdkPlugin(Registrar registrar) {
    this.registrar = registrar;
    this.registrar.addActivityResultListener(loginResultDelegate);
    LoginManager.getInstance().registerCallback(callbackManager, loginResultDelegate);
  }

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(),
        "com.sarpongkb/flutter_facebook_sdk/facebook_login");
    channel.setMethodCallHandler(new FlutterFacebookSdkPlugin(registrar));
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else if (call.method.equals("isLoggedIn")) {
      isLoggedIn(call, result);
    } else if (call.method.equals("logInWithReadPermissions")) {
      onLogInWithReadPermissions(call, result);
    } else {
      result.notImplemented();
    }
  }

  private void isLoggedIn(MethodCall call, Result result) {
    AccessToken accessToken = AccessToken.getCurrentAccessToken();
    boolean isLoggedIn = accessToken != null && !accessToken.isExpired();

    // // LoginManager
    // loginManager.getDefaultAudience();
    // loginManager.getAuthType();
    // loginManager.getLoginBehavior();
    // loginManager.logInWithPublishPermissions();
    // loginManager.logInWithReadPermissions();
    // loginManager.logOut();
    // loginManager.registerCallback();
    // loginManager.setAuthType();
    // loginManager.setDefaultAudience();
    // loginManager.setLoginBehavior();
    // loginManager.unregisterCallback();

    result.success(isLoggedIn);
  }

  private void onLogInWithReadPermissions(MethodCall call, final Result result) {
    loginResultDelegate.setResult(result);
    List<String> readPermissions = call.argument("readPermissions");
    LoginManager.getInstance().logInWithReadPermissions(registrar.activity(), readPermissions);
  }

}
