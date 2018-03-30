
#import "RTAutoRun.h"
#import "RecordTestHeader.h"

@interface RTAutoRun ()

@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,assign)NSInteger index;

@end

@implementation RTAutoRun

+ (RTAutoRun *)shareInstance{
    static dispatch_once_t pred = 0;
    __strong static RTAutoRun *_sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[RTAutoRun alloc] init];
        _sharedObject.autoRunQueue = [NSMutableArray array];
        _sharedObject.index = 0;
    });
    return _sharedObject;
}

- (void)repeatAction{
    if (![RTCommandList shareInstance].isRunOperationQueue) {
        if (self.autoRunQueue.count > self.index) {
            RTIdentify *identify = self.autoRunQueue[self.index++];
            [[RTCommandList shareInstance] setOperationQueue:identify];
            [[RTCommandList shareInstance] runStep:YES];
        }else{
            [self stop];
        }
    }
}

- (void)start{
    self.index = 0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(repeatAction) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        [self.timer setFireDate:[NSDate distantPast]];
    });
}

- (void)stop{
    [self.autoRunQueue removeAllObjects];
    self.autoRunQueue = [NSMutableArray array];
    self.index = 0;
    [self.timer setFireDate:[NSDate distantFuture]];
    [self.timer invalidate];
}

@end
