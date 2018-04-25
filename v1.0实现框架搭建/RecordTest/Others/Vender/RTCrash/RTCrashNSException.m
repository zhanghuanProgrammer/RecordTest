
#import "RTCrashNSException.h"
#import "RTCrash.h"
#include <execinfo.h>
#import "RTReporter.h"
#import <mach/mach_init.h>

static NSUncaughtExceptionHandler * s_previousUncaughtExceptionHandle = NULL;//其他SDK注册过NSSetUncaughtExceptionHandler的回调函数

static void rt_NSExceptionhandler(NSException *exception) {
    rt_uninstallExceptionHandler();
    [RTCrashReporter shareObject].isCrash = YES;
    NSString *origStack=nil;
    
    [RTCrashReporter shareObject].callStackAddressArr = [exception callStackReturnAddresses];
    [RTCrashReporter shareObject].crashThread = mach_thread_self();
    NSString *stack= NULL;
    
    [RTCrashReporter rt_backtraceOfAllThread];
    stack = [NSString stringWithFormat:@"callStackSymbols: {\n%@}\n",[[RTCrashReporter shareObject].crashThreadInfo stackTrace]];
    
    NSArray *stackArray = [stack componentsSeparatedByString:@"\n"];
    
    //无用异常则不收集崩溃数据
//        [[RTDataManager sharedObj] crash:rt_cpu_time_us()
//                                callStack:stack
//                               callStack2:origStack
//                                     type:[exception name]
//                                   reason:[exception reason]];

    //调回其他SDK注册的崩溃回调函数
    if (s_previousUncaughtExceptionHandle) {
        s_previousUncaughtExceptionHandle(exception);
        s_previousUncaughtExceptionHandle = NULL;
    }
}
             
void rt_installNSExceptionHandler() {
    NSUncaughtExceptionHandler * uncaughtExceptionHandle = NSGetUncaughtExceptionHandler();
    if (uncaughtExceptionHandle == &rt_NSExceptionhandler) {
        return;
    }
    
    s_previousUncaughtExceptionHandle = uncaughtExceptionHandle;

    NSSetUncaughtExceptionHandler(&rt_NSExceptionhandler);
}

void rt_uninstallNSExceptionHandler() {
    if (s_previousUncaughtExceptionHandle) {
        NSSetUncaughtExceptionHandler(s_previousUncaughtExceptionHandle);
        return;
    }

    NSSetUncaughtExceptionHandler(NULL);
}
