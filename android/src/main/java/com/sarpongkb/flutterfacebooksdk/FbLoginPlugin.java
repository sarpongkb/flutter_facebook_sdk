package com.sarpongkb.flutterfacebooksdk;

import android.content.Intent;

import com.facebook.AccessToken;
import com.facebook.CallbackManager;
import com.facebook.FacebookCallback;
import com.facebook.FacebookException;
import com.facebook.login.LoginManager;
import com.facebook.login.LoginResult;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

public class FbLoginPlugin  implements MethodCallHandler {
  private static final String channelName = "com.sarpongkb/flutter_facebook_sdk/fb_login";

  // private LoginBehavior loginBehavior;
  private final Registrar registrar;
  private final CallbackManager callbackManager = CallbackManager.Factory.create();
  private final ResultDelegate loginResultDelegate = new ResultDelegate(callbackManager);

  public FbLoginPlugin(Registrar registrar) {
    this.registrar = registrar;
    this.registrar.addActivityResultListener(loginResultDelegate);
    LoginManager.getInstance().registerCallback(callbackManager, loginResultDelegate);
  }

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), channelName);
    channel.setMethodCallHandler(new FbLoginPlugin(registrar));
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
      if (call.method.equals("isLoggedIn")) {
          isLoggedIn(call, result);
      } else if (call.method.equals("logInWithReadPermissions")) {
          logInWithReadPermissions(call, result);
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

  private void logInWithReadPermissions(MethodCall call, final Result result) {
    loginResultDelegate.setResult(result);
    List<String> readPermissions = call.argument("readPermissions");
    LoginManager.getInstance().logInWithReadPermissions(registrar.activity(), readPermissions);
  }


  private static class ResultDelegate implements FacebookCallback<LoginResult>, PluginRegistry.ActivityResultListener {
    private Result result;
    final private CallbackManager callbackManager;

    public ResultDelegate(CallbackManager callbackManager) {
      this.callbackManager = callbackManager;
    }

    public void setResult(Result result) {
        this.result = result;
    }

    @Override
    public void onSuccess(LoginResult loginResult) {
      Map<String, Object> res = new HashMap<>();
      res.put("status", "LOGGED_IN");
      res.put("accessToken", FbAccessToken.parsedToken(loginResult.getAccessToken()));
      result.success(res);
    }

    @Override
    public void onCancel() {
      HashMap<String, Object> res = new HashMap<>();
      res.put("status", "CANCELED");
      result.success(res);
    }

    @Override
    public void onError(FacebookException error) {
      HashMap<String, Object> res = new HashMap<>();
      res.put("status", "ERROR");
      res.put("errorMessage", error.getLocalizedMessage());
      result.success(res);
    }

    @Override
    public boolean onActivityResult(int i, int i1, Intent intent) {
      return callbackManager.onActivityResult(i, i1, intent);
    }
  }
}
