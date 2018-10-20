#import "FlutterFacebookSdkPlugin.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@implementation FlutterFacebookSdkPlugin
  
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
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)isLoggedIn:(FlutterMethodCall*)call result:(FlutterResult)result {
  BOOL loggedIn = [FBSDKAccessToken currentAccessTokenIsActive];
  result([NSNumber numberWithBool:loggedIn]);
}
  
@end
