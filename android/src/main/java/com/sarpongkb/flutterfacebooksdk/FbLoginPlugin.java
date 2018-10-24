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
  private static final String CHANNEL_NAME = "com.sarpongkb/flutter_facebook_sdk/fb_login";
  private static final String DONE = "DONE";

  private final Registrar registrar;
  private final CallbackManager callbackManager = CallbackManager.Factory.create();
  private final ResultDelegate resultDelegate = new ResultDelegate(callbackManager);

  public FbLoginPlugin(Registrar registrar) {
    this.registrar = registrar;
    this.registrar.addActivityResultListener(resultDelegate);
    LoginManager.getInstance().registerCallback(callbackManager, resultDelegate);
  }

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), CHANNEL_NAME);
    channel.setMethodCallHandler(new FbLoginPlugin(registrar));
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
      if (call.method.equals("getCurrentAccessToken")) {
          getCurrentAccessToken(result);
      } else if (call.method.equals("isLoggedIn")) {
        isLoggedIn(result);
      } else if (call.method.equals("logInWithPublishPermissions")) {
        logInWithPublishPermissions(call, result);
      } else if (call.method.equals("logInWithReadPermissions")) {
          logInWithReadPermissions(call, result);
      } else if (call.method.equals("logOut")) {
        logOut(result);
      } else {
          result.notImplemented();
      }
  }

  private void getCurrentAccessToken(Result result) {
    AccessToken token = AccessToken.getCurrentAccessToken();
    result.success(token == null ? null : FbAccessToken.parsedToken(token));
  }

  private void isLoggedIn(Result result) {
      AccessToken accessToken = AccessToken.getCurrentAccessToken();
      boolean isLoggedIn = accessToken != null && !accessToken.isExpired();
      result.success(isLoggedIn);
  }

  private void logInWithPublishPermissions(MethodCall call, final Result result) {
    resultDelegate.setResult(result);
    List<String> permissions = call.argument("permissions");
    LoginManager.getInstance().logInWithPublishPermissions(registrar.activity(), permissions);
  }

  private void logInWithReadPermissions(MethodCall call, final Result result) {
    resultDelegate.setResult(result);
    List<String> permissions = call.argument("permissions");
    LoginManager.getInstance().logInWithReadPermissions(registrar.activity(), permissions);
  }

  private void logOut(Result result) {
    LoginManager.getInstance().logOut();
    result.success(DONE);
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


//  private static class Behavior {
//    NATIVE_WITH_FALLBACK
//    NATIVE_ONLY
//    KATANA_ONLY
//    WEB_ONLY
//    WEB_VIEW_ONLY
//    DIALOG_ONLY
//    DEVICE_AUTH
//  }
}
