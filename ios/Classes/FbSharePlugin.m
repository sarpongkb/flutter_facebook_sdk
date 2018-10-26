#import <Foundation/Foundation.h>

#import <FBSDKShareKit/FBSDKShareLinkContent.h>
#import <FBSDKShareKit/FBSDKShareDialog.h>
#import <FBSDKShareKit/FBSDKHashtag.h>

#import "FbSharePlugin.h"

@implementation FbSharePlugin {
  NSString* DONE;
  UIViewController* viewController;
  FlutterResult fltResult;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"com.sarpongkb/flutter_facebook_sdk/fb_share"
                                     binaryMessenger:[registrar messenger]];
  FbSharePlugin* instance = [[FbSharePlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}


- (instancetype)init {
  viewController = [UIApplication sharedApplication].delegate.window.rootViewController;
  return self;
}


- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"shareLink" isEqualToString:call.method]) {
    [self shareLink:call result:result];
  } else {
    result(FlutterMethodNotImplemented);
  }
}


- (void)shareLink:(FlutterMethodCall*)call result:(FlutterResult)result {
  fltResult = result;
  NSString* linkUrl = call.arguments[@"linkUrl"];
  NSString* quote = call.arguments[@"quote"];
  NSString* hashTag = call.arguments[@"hashTag"];
  FBSDKShareLinkContent* content = [[FBSDKShareLinkContent alloc] init];
  content.contentURL = [NSURL URLWithString:linkUrl];
  content.quote = quote;
  content.hashtag = [FBSDKHashtag hashtagWithString:hashTag];
  [FBSDKShareDialog showFromViewController:viewController withContent:content delegate:self];
}


- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error {
  fltResult(@{@"status": @"ERROR",
              @"errorMessage": [error localizedDescription]
              });
}


- (void)sharerDidCancel:(id<FBSDKSharing>)sharer {
  fltResult(@{@"status": @"CANCELED"});
}


- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)shareResults {
  fltResult(@{@"status": @"SUCCESS", @"postId": shareResults[@"shareUUID"]});
}

@end
