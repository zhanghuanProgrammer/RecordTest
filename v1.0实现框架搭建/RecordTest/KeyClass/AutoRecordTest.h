
#import <Foundation/Foundation.h>
#import "SuspendBall.h"

@interface AutoRecordTest : NSObject <SuspendBallDelegte>

@property (nonatomic,assign)BOOL isRuning;

+ (AutoRecordTest *)shareInstance;

- (void)autoRecord;

@end
