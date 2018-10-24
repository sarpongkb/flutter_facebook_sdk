package com.sarpongkb.flutterfacebooksdk;

import android.content.Intent;

import com.facebook.AccessToken;
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
        AccessToken resToken = loginResult.getAccessToken();

        HashMap<String, Object> accessToken = new HashMap<>();
        accessToken.put("appId", resToken.getApplicationId());
        accessToken.put("declinedPermissions", new ArrayList<>(resToken.getDeclinedPermissions()));
        accessToken.put("expirationTime", resToken.getExpires().getTime());
        accessToken.put("isExpired", loginResult.getAccessToken().isExpired());
        accessToken.put("permissions", new ArrayList<>(resToken.getPermissions()));
        accessToken.put("refreshTime", resToken.getLastRefresh().getTime());
        accessToken.put("tokenString", resToken.getToken());
        accessToken.put("userId", resToken.getUserId());

        HashMap<String, Object> res = new HashMap<>();
        res.put("status", "LOGGED_IN");
        res.put("accessToken", accessToken);
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
