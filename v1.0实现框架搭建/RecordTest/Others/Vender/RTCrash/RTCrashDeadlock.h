
#import <Foundation/Foundation.h>

@interface RTThreadDeadlockMonitor : NSObject

- (void)startThreadMonitor;
- (void)stopThreadMonitor;
+ (instancetype)shareObj;

@end
