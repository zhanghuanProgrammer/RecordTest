
#import "RTCrashDeadlock.h"
#import "RTReporter.h"
#import <mach/mach_time.h>

typedef NS_ENUM(NSUInteger, RTThreadState) {
    NOT_STUCK,
    STUCK
};

typedef NS_ENUM(NSUInteger, RTAppState) {
    RTAppState_willEnterForeground,
    RTAppState_enterBackground,
    RTAppState_crash,
};

static dispatch_semaphore_t mainThreadMonitorSemaphore;
static CFRunLoopActivity runLoopActivity;
static RTThreadState previousState;
static uint64_t lastTrick = 0;

static void runLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void* info){
    runLoopActivity = activity;
    lastTrick = mach_absolute_time();
    dispatch_semaphore_signal(mainThreadMonitorSemaphore);
}

@interface RTThreadDeadlockMonitor ()

@property (nonatomic, assign) enum RTAppState appState;

@end

@implementation RTThreadDeadlockMonitor

+ (instancetype)shareObj{
    static RTThreadDeadlockMonitor* threadMonitor = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!threadMonitor) {
            threadMonitor = [[RTThreadDeadlockMonitor alloc] init];
        }
    });
    return threadMonitor;
}

- (void)startThreadMonitor{

    //卡顿阀值，默认为5s
    float __block lagInterval = 5.0;
    //前一次卡顿检测状态
    previousState = NOT_STUCK;
    //非交互性卡顿
    __block BOOL isNotEventStuck = NO;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mainThreadMonitorSemaphore = dispatch_semaphore_create(0);
        CFRunLoopObserverContext context = { 0, NULL, NULL, NULL };
        CFRunLoopObserverRef runLoopObserver = CFRunLoopObserverCreate(kCFAllocatorDefault,
            kCFRunLoopAllActivities,
            YES,
            0,
            &runLoopObserverCallBack,
            &context);
        CFRunLoopAddObserver(CFRunLoopGetMain(), runLoopObserver, kCFRunLoopDefaultMode);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

            while (YES) {

                //将卡顿判断阀值缩小0.01s，防止卡顿结束了才获取堆栈信息，此时堆栈信息不能准确的反映卡顿的方法调用情况
                long hadStuck = dispatch_semaphore_wait(mainThreadMonitorSemaphore, dispatch_time(DISPATCH_TIME_NOW, (lagInterval - 0.01) * NSEC_PER_SEC));
                uint64_t localLastTrick = lastTrick;

                //卡顿时长达到阀值并且agent处于运行状态、app未处于crash状态，则收集卡顿信息，否则不收集
                if (hadStuck) {

                    //判断卡顿状态是否已经解除，如果已经解除，此时获取的堆栈将不能准确定位卡顿位置，所以此时不计入该卡顿数据；如未解除，获取当前线程状态，用于后面的堆栈获取;
                    if (localLastTrick && localLastTrick == lastTrick) {
                        [RTCrashReporter rt_storeLagMachineContext];
                    } else {
                        continue;
                    }

                    //判断是否为非人机交互导致的卡顿
                    if (!CFRunLoopIsWaiting(CFRunLoopGetMain())) {
                        isNotEventStuck = YES;
                    }

                    //上一个状态处于未卡顿状态则收集数据，否则不收集，防止同一个卡顿收集并回传多次
                    if ((runLoopActivity == kCFRunLoopBeforeSources || runLoopActivity == kCFRunLoopAfterWaiting || isNotEventStuck == YES) && previousState == NOT_STUCK) {

                        //设置卡顿状态
                        previousState = STUCK;

                        //重置非交互性卡顿标志
                        isNotEventStuck = NO;

                        NSString* stackTrace = [RTCrashReporter generateLiveReport:YES];
                        NSArray* callStacks = [stackTrace componentsSeparatedByString:@"\n"];
                        NSString* causeBy = ([callStacks firstObject] == NULL) ? @"unKnown reason" : [callStacks firstObject];
                        NSString* callStackStr = [NSString stringWithFormat:@"callStackSymbols: {\n%@}\n", stackTrace];

                        //                        [[RTDataManager sharedObj] lag:rt_cpu_time_us()
                        //                                                callStack:callStackStr
                        //                                                     type:nil
                        //                                                   reason:causeBy];
                    }
                } else {
                    //卡顿结束
                    if (previousState == STUCK) {
                        //do nothing
                    }
                    //重置卡顿状态
                    previousState = NOT_STUCK;
                }
            }
        });
    });
}

- (void)stopThreadMonitor{
    self.appState = RTAppState_crash;
}

@end
