package com.sarpongkb.flutterfacebooksdk;

import android.content.Intent;
import android.net.Uri;

import com.facebook.CallbackManager;
import com.facebook.FacebookCallback;
import com.facebook.FacebookException;
import com.facebook.share.Sharer;
import com.facebook.share.model.ShareHashtag;
import com.facebook.share.model.ShareLinkContent;
import com.facebook.share.widget.ShareDialog;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

public class FbSharePlugin   implements MethodCallHandler {
  private static final String CHANNEL_NAME = "com.sarpongkb/flutter_facebook_sdk/fb_share";
//  private static final String DONE = "DONE";

  private final Registrar registrar;
  private final CallbackManager callbackManager = CallbackManager.Factory.create();
  private final FbSharePlugin.ResultDelegate resultDelegate = new FbSharePlugin.ResultDelegate(callbackManager);


  private FbSharePlugin(Registrar registrar) {
    this.registrar = registrar;
    this.registrar.addActivityResultListener(resultDelegate);
  }

  /**
   * Plugin registration.
   */
  static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), CHANNEL_NAME);
    channel.setMethodCallHandler(new FbSharePlugin(registrar));
  }


  @Override
  public void onMethodCall(MethodCall call, Result result) {
    switch (call.method) {
      case "shareLink":
        shareLink(call, result);
        break;
      default:
        result.notImplemented();
        break;
    }
  }


  private void shareLink(MethodCall call, MethodChannel.Result result) {
    String linkUrl = call.argument("linkUrl");
    String quote = call.argument("quote");
    String hashTag = call.argument("hashTag");
    if (ShareDialog.canShow(ShareLinkContent.class)) {

      ShareDialog shareDialog = new ShareDialog(this.registrar.activity());
      shareDialog.registerCallback(callbackManager, resultDelegate);


      resultDelegate.setResult(result);
      ShareLinkContent linkContent = new ShareLinkContent.Builder()
          .setContentUrl(Uri.parse(linkUrl))
          .setQuote(quote)
          .setShareHashtag(new ShareHashtag.Builder().setHashtag(hashTag).build())
          .build();
      shareDialog.show(linkContent);
    } else {
      result.error("ShareFailed", "Cannot show dialog", null);
    }
  }


  private static class ResultDelegate
      implements FacebookCallback<Sharer.Result>, PluginRegistry.ActivityResultListener {

    private MethodChannel.Result result;
    final private CallbackManager callbackManager;

    ResultDelegate(CallbackManager callbackManager) {
      this.callbackManager = callbackManager;
    }

    void setResult(MethodChannel.Result result) {
      this.result = result;
    }

    @Override
    public void onSuccess(Sharer.Result shareResult) {
      Map<String, Object> res = new HashMap<>();
      res.put("status", "SUCCESS");
      res.put("postId", shareResult.getPostId());
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
