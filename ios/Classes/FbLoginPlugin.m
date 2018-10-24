#import "FbLoginPlugin.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

#import "FbAccessToken.h"

@implementation FbLoginPlugin

NSString* DONE = @"DONE";

FBSDKLoginManager* loginManager;

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
                                   methodChannelWithName:@"com.sarpongkb/flutter_facebook_sdk/fb_login"
                                   binaryMessenger:[registrar messenger]];
  FbLoginPlugin* instance = [[FbLoginPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}


- (instancetype)init {
  loginManager = [[FBSDKLoginManager alloc] init];
  return self;
}


- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"isLoggedIn" isEqualToString:call.method]) {
      [self isLoggedIn:call result:result];
  } else if ([@"getCurrentAccessToken" isEqualToString:call.method]) {
      [self getCurrentAccessToken:call result:result];
  } else if ([@"logInWithReadPermissions" isEqualToString:call.method]) {
      [self logInWithReadPermissions:call result:result];
  } else if ([@"logInWithPublishPermissions" isEqualToString:call.method]) {
      [self logInWithPublishPermissions:call result:result];
  } else {
      result(FlutterMethodNotImplemented);
  }
}


- (void)isLoggedIn:(FlutterMethodCall*)call result:(FlutterResult)result {
  BOOL loggedIn = [FBSDKAccessToken currentAccessTokenIsActive];
  result([NSNumber numberWithBool:loggedIn]);
}

- (void)getCurrentAccessToken:(FlutterMethodCall*)call result:(FlutterResult)result {
  FBSDKAccessToken* token = [FBSDKAccessToken currentAccessToken];
  result(token == nil ? nil : [FbAccessToken parsedToken:token]);
}


- (void)logInWithReadPermissions:(FlutterMethodCall*)call result:(FlutterResult)result {
  NSArray* readPermissions = call.arguments[@"readPermissions"];
  [loginManager logInWithReadPermissions:readPermissions fromViewController:nil handler:^(FBSDKLoginManagerLoginResult* loginResult, NSError* loginError) {
      if (loginError != nil) {
        result(@{@"status": @"ERROR", @"errorMessage": [loginError localizedDescription]});
      } else if ([loginResult isCancelled]) {
        [loginManager logOut];
        result(@{@"status": @"CANCELED"});
      } else {
        result(@{ @"status": @"LOGGED_IN",
                  @"accessToken": [FbAccessToken parsedToken: [loginResult token]]
                  });
      }
  }];
}


- (void)logInWithPublishPermissions:(FlutterMethodCall*)call result:(FlutterResult)result {
  result(DONE);
}

@end

