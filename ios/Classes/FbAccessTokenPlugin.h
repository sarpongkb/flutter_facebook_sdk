#ifndef FbAccessToken_h
#define FbAccessToken_h

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <Flutter/Flutter.h>

@interface FbAccessTokenPlugin : NSObject<FlutterPlugin>
  +(NSDictionary*) parsedToken:(FBSDKAccessToken*)token;
@end

#endif
