#import "FlutterFacebookSdkPlugin.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>

#import "FbLoginPlugin.h"

@implementation FlutterFacebookSdkPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterFacebookSdkPlugin* instance = [[FlutterFacebookSdkPlugin alloc] init];
  [registrar addApplicationDelegate:instance];
    
  [FbLoginPlugin registerWithRegistrar:registrar];
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

@end
