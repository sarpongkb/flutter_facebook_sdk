import 'package:flutter/services.dart';
import "package:meta/meta.dart";

class FbShare {
  FbShare._();

  static const MethodChannel _channel =
      MethodChannel('com.sarpongkb/flutter_facebook_sdk/fb_share');

  static Future<void> shareLink({
    @required String linkUrl,
    String quote,
    String hashTag,
  }) async {
    assert(linkUrl != null && linkUrl.trim().isNotEmpty);
    dynamic shareResult = await _channel.invokeMethod("shareLink", {
      "linkUrl": linkUrl,
      "quote": quote,
      "hashTag": hashTag,
    });

    print("share result: $shareResult");
  }
}

//abstract class FbShareContent {
////  final String contentType;
////  FbShareContent({@required this.contentType});
//}


//class FbSharePhotoContent extends FbShareContent {
//  final String contentType;
//  final String photoUrl;
//
//  FbSharePhotoContent({
//    @required this.contentType,
//    @required this.photoUrl,
//  });
//}

//class FbShareVideoContent extends FbShareContent {
//  final String contentType;
//  final String videoUrl;
//
//  FbShareVideoContent({
//    @required this.contentType,
//    @required this.videoUrl,
//  });
//}

//class ShareDialog {
//  static bool canShow(FbShareContent shareContent) {
//    return true;
//  }
//
//  static void show(FbShareContent shareContent) {}
//}
