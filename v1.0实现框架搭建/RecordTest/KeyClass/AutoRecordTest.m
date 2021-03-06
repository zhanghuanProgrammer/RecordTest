
#import "AutoRecordTest.h"
#import "RecordTestHeader.h"
#import "RTCrash.h"
#import "RTThreadDeadlockMonitor.h"
#import "RTNetResult.h"

@implementation AutoRecordTest

+ (AutoRecordTest *)shareInstance{
    static dispatch_once_t pred = 0;
    __strong static AutoRecordTest *_sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[AutoRecordTest alloc] init];
        if (Run) {
            [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
            [[RTInteraction shareInstance] startInteraction];
            [[RTTopVC shareInstance] hookTopVC];
            [RTSearchVCPath shareInstance].isLearnVCPath = YES;
        }
    });
    return _sharedObject;
}

- (void)run{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        rt_installExceptionHandler();
        [[RTThreadDeadlockMonitor shareObj] startThreadMonitor];
        [[RTNetResult shareInstance] startHttpHook];
    });
    if (!Run) return;
    [[KVOAllView new] kvoAllView];
    [[RTTopVC shareInstance] updateTopVC:NO];
    [[RTDeviceInfo shareInstance] showDeviceInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self run];
    });
}

@end
