
#import <Foundation/Foundation.h>

extern NSString *const kFLEXNetworkObserverEnabledStateChangedNotification;

@interface FLEXNetworkObserver : NSObject

+ (void)setEnabled:(BOOL)enabled;
+ (BOOL)isEnabled;

@end
