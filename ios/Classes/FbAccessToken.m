#import "FbAccessToken.h"

@implementation FbAccessToken

+(NSDictionary*) parsedToken:(FBSDKAccessToken*)token {
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

@end
