#import "FlutterFacebookSdkPlugin.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@implementation FlutterFacebookSdkPlugin
  
NSString* DONE = @"DONE";
    
FBSDKLoginManager* loginManager;
  
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"com.sarpongkb/flutter_facebook_sdk"
            binaryMessenger:[registrar messenger]];
  FlutterFacebookSdkPlugin* instance = [[FlutterFacebookSdkPlugin alloc] init];
  [registrar addApplicationDelegate:instance];
  [registrar addMethodCallDelegate:instance channel:channel];
}


- (instancetype)init {
  loginManager = [[FBSDKLoginManager alloc] init];
  return self;
}
  
  
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
  // Add any custom logic here.
  return YES;
}
  
  
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
  BOOL handled = [[FBSDKApplicationDelegate sharedInstance]
                        application:application
                            openURL:url
                  sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                         annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
  // Add any custom logic here.
  return handled;
}
  
  
- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if ([@"isLoggedIn" isEqualToString:call.method]) {
    [self isLoggedIn:call result:result];
  } else if ([@"getCurrentAccessToken" isEqualToString:call.method]) {
      [self onGetCurrentAccessToken:call result:result];
  } else if ([@"logInWithReadPermissions" isEqualToString:call.method]) {
      [self onLogInWithReadPermissions:call result:result];
  } else if ([@"logInWithPublishPermissions" isEqualToString:call.method]) {
      [self onLogInWithPublishPermissions:call result:result];
  } else {
    result(FlutterMethodNotImplemented);
  }
}

    
- (void)isLoggedIn:(FlutterMethodCall*)call result:(FlutterResult)result {
  BOOL loggedIn = [FBSDKAccessToken currentAccessTokenIsActive];
  result([NSNumber numberWithBool:loggedIn]);
}
  
- (void)onGetCurrentAccessToken:(FlutterMethodCall*)call result:(FlutterResult)result {
    FBSDKAccessToken* accessToken = [FBSDKAccessToken currentAccessToken];
    result(accessToken);
}


- (void)onLogInWithReadPermissions:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSArray* readPermissions = call.arguments[@"readPermissions"];
    [loginManager logInWithReadPermissions:readPermissions fromViewController:nil handler:^(FBSDKLoginManagerLoginResult* loginResult, NSError* loginError) {
        if (loginError != nil) {
            [FlutterError errorWithCode:@"LOGIN_ERROR" message:[loginError localizedDescription] details:nil];
        } else if ([loginResult isCancelled]) {
            [loginManager logOut];
            result(@{@"status": @"CANCELLED"});
        } else {
            result(@{ @"status": @"LOGGED_IN",
                      @"accessToken": [self parseAccessToken:[loginResult token]]
                      });
        }
    }];
}


- (NSDictionary*) parseAccessToken:(FBSDKAccessToken*)token {
    return token == nil ? @{} : @{ @"expirationDate": [[token expirationDate] description],
                                   @"isExpired": [NSNumber numberWithBool:[token isExpired]],
                                   @"tokenString": [token tokenString],
                                   @"userId": [token userID],
                                   @"permissions": [[token permissions] allObjects],
                                   @"declinedPermissions": [[token declinedPermissions] allObjects]
                                   };
}


- (void)onLogInWithPublishPermissions:(FlutterMethodCall*)call result:(FlutterResult)result {
    result(DONE);
}

@end
