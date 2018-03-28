
#import "AutoRecordTest.h"
#import "RecordTestHeader.h"

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
        }
    });
    return _sharedObject;
}

- (void)run{
    if (!Run) {
        return;
    }
    
    if ([RTOperationQueue shareInstance].isRecord || [RTCommandList shareInstance].isRunOperationQueue) {
        [[KVOAllView new] kvoAllView];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self run];
    });
}

@end
