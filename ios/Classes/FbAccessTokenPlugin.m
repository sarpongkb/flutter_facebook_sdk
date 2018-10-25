#import "FbAccessTokenPlugin.h"

@implementation FbAccessTokenPlugin


+ (void)registerWithRegistrar:(nonnull NSObject<FlutterPluginRegistrar> *)registrar {
  FlutterMethodChannel* channel =
    [FlutterMethodChannel
     methodChannelWithName:@"com.sarpongkb/flutter_facebook_sdk/fb_access_token"
     binaryMessenger:[registrar messenger]];
  FbAccessTokenPlugin* instance = [[FbAccessTokenPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}


+ (NSDictionary*)parsedToken:(FBSDKAccessToken*)token {
  return token == nil ?
      @{}
    : @{ @"appId": [token appID],
         @"declinedPermissions": [[token declinedPermissions] allObjects],
         @"expirationTime": [NSNumber numberWithInteger:
                             [[token expirationDate] timeIntervalSince1970]],
         @"isExpired": [NSNumber numberWithBool:[token isExpired]],
         @"permissions": [[token permissions] allObjects],
         @"refreshTime": [NSNumber numberWithInteger:
                          [[token refreshDate] timeIntervalSince1970]],
         @"tokenString": [token tokenString],
         @"userId": [token userID],
         };
}


- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
  if ([@"getCurrentAccessToken" isEqualToString:call.method]) {
    FBSDKAccessToken* token = [FBSDKAccessToken currentAccessToken];
    result(token == nil ? nil : [FbAccessTokenPlugin parsedToken:token]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
