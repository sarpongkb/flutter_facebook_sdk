#ifndef FbAccessToken_h
#define FbAccessToken_h

#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface FbAccessToken : NSObject
  +(NSDictionary*) parsedToken:(FBSDKAccessToken*)token;
@end

#endif
