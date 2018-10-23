package com.sarpongkb.flutterfacebooksdk;

import android.content.Intent;

import com.facebook.CallbackManager;
import com.facebook.FacebookCallback;
import com.facebook.FacebookException;
import com.facebook.login.LoginResult;

import java.util.ArrayList;
import java.util.HashMap;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class LoginResultDelegate implements FacebookCallback<LoginResult>, PluginRegistry.ActivityResultListener {
    private MethodChannel.Result result;
    final private CallbackManager callbackManager;

    public LoginResultDelegate(CallbackManager callbackManager) {
        this.callbackManager = callbackManager;
    }

    public void setResult(MethodChannel.Result result) {
        this.result = result;
    }

    @Override
    public void onSuccess(LoginResult loginResult) {
        HashMap<String, Object> accessToken = new HashMap<>();
        accessToken.put("userId", loginResult.getAccessToken().getUserId());
        accessToken.put("isExpired", loginResult.getAccessToken().isExpired());
        accessToken.put("tokenString", loginResult.getAccessToken().getToken());
        accessToken.put("expirationDate", loginResult.getAccessToken().getExpires().toString());
        accessToken.put("grantedPermissions", new ArrayList<>(loginResult.getAccessToken().getPermissions()));
        accessToken.put("declinedPermissions", new ArrayList<>(loginResult.getAccessToken().getDeclinedPermissions()));

        HashMap<String, Object> res = new HashMap<>();
        res.put("status", "loggedIn");
        res.put("accessToken", accessToken);
        result.success(res);

    }

    @Override
    public void onCancel() {
        HashMap<String, Object> res = new HashMap<>();
        res.put("status", "cancelledByUser");
        result.success(res);
    }

    @Override
    public void onError(FacebookException error) {
        result.error("Login Error", error.getLocalizedMessage(), null);
    }

    @Override
    public boolean onActivityResult(int i, int i1, Intent intent) {
        return callbackManager.onActivityResult(i, i1, intent);
    }
}
