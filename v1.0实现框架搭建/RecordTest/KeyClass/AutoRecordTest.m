
#import "AutoRecordTest.h"
#import "RecordTestHeader.h"

@implementation AutoRecordTest

+ (AutoRecordTest *)shareInstance{
    static dispatch_once_t pred = 0;
    __strong static AutoRecordTest *_sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[AutoRecordTest alloc] init];
        _sharedObject.isRuning=NO;
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    });
    return _sharedObject;
}

- (void)autoRecord{
    self.isRuning=YES;
    [[KVOAllView new] kvoAllView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self autoRecord];
        [RTOperationQueue runOperationQueue];
    });
}

@end
