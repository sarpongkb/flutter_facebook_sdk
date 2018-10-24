package com.sarpongkb.flutterfacebooksdk;

import io.flutter.plugin.common.PluginRegistry.Registrar;

/** FlutterFacebookSdkPlugin */
public class FlutterFacebookSdkPlugin {

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    FbLoginPlugin.registerWith(registrar);
  }
}
