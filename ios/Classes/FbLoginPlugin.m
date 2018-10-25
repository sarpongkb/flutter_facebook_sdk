#import "FbLoginPlugin.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

#import "FbAccessTokenPlugin.h"

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
    [self isLoggedIn:result];
  } else if ([@"logInWithPublishPermissions" isEqualToString:call.method]) {
    [self logInWithPublishPermissions:call result:result];
  } else if ([@"logInWithReadPermissions" isEqualToString:call.method]) {
    [self logInWithReadPermissions:call result:result];
  } else if ([@"logOut" isEqualToString:call.method]) {
    [self logOut:result];
  } else {
    result(FlutterMethodNotImplemented);
  }
}


- (void)isLoggedIn:(FlutterResult)result {
  BOOL loggedIn = [FBSDKAccessToken currentAccessTokenIsActive];
  result([NSNumber numberWithBool:loggedIn]);
}


- (void)logInWithPublishPermissions:(FlutterMethodCall*)call result:(FlutterResult)result {
  NSArray* permissions = call.arguments[@"permissions"];
  NSString* behavior = call.arguments[@"behavior"];
  [loginManager setLoginBehavior:[self loginBehaviorFromString:behavior]];
  [loginManager logInWithPublishPermissions:permissions
                         fromViewController:nil
                                    handler:^(FBSDKLoginManagerLoginResult* fbResult, NSError* fbError) {
                                      [self handleLoginResults:fbResult fbError:fbError fltResult:result];
                                    }];
}


- (void)logInWithReadPermissions:(FlutterMethodCall*)call result:(FlutterResult)result {
  NSArray* permissions = call.arguments[@"permissions"];
  NSString* behavior = call.arguments[@"behavior"];
  [loginManager setLoginBehavior:[self loginBehaviorFromString:behavior]];
  [loginManager logInWithReadPermissions:permissions
                      fromViewController:nil
                                 handler:^(FBSDKLoginManagerLoginResult* fbResult, NSError* fbError) {
                                   [self handleLoginResults:fbResult fbError:fbError fltResult:result];
                                 }];
}


- (void)logOut:(FlutterResult)result {
  [loginManager logOut];
  result(DONE);
}


- (void)handleLoginResults:(FBSDKLoginManagerLoginResult*)fbResult
                    fbError:(NSError*)fbError
                  fltResult:(FlutterResult)fltResult
{
  if (fbError != nil) {
    fltResult(@{@"status": @"ERROR", @"errorMessage": [fbError localizedDescription]});
  } else if ([fbResult isCancelled]) {
    [loginManager logOut];
    fltResult(@{@"status": @"CANCELED"});
  } else {
    fltResult(@{ @"status": @"LOGGED_IN",
                 @"accessToken": [FbAccessTokenPlugin parsedToken: [fbResult token]]
                 });
  }
}

- (FBSDKLoginBehavior)loginBehaviorFromString:(NSString*) behavior {
  FBSDKLoginBehavior fbLoginBehavior = [loginManager loginBehavior];
  
  if ([@"NATIVE_ONLY" isEqualToString:behavior]) {
    fbLoginBehavior = FBSDKLoginBehaviorNative;
  } else if ([@"NATIVE_WITH_FALLBACK" isEqualToString:behavior]) {
    fbLoginBehavior = FBSDKLoginBehaviorSystemAccount;
  } else if ([@"WEB_ONLY" isEqualToString:behavior]) {
    fbLoginBehavior = FBSDKLoginBehaviorWeb;
  } else if ([@"WEB_VIEW_ONLY" isEqualToString:behavior]) {
    fbLoginBehavior = FBSDKLoginBehaviorBrowser;
  }
  
  return fbLoginBehavior;
}

@end
