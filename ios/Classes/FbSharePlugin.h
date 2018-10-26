#ifndef FbSharePlugin_h
#define FbSharePlugin_h

#import <FBSDKShareKit/FBSDKSharing.h>
#import <Flutter/Flutter.h>

@interface FbSharePlugin : NSObject<FlutterPlugin, FBSDKSharingDelegate>
@end

#endif
