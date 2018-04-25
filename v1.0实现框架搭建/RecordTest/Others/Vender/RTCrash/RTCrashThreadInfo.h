
#import <Foundation/Foundation.h>

@interface RTCrashThreadInfo : NSObject

@property (nonatomic, strong) NSMutableString *stackTrace;
@property (nonatomic, assign) uint64_t threadId;
@property (nonatomic, copy) NSString *threadName;
@property (nonatomic, assign) BOOL isCrashThread;
@property (nonatomic, assign) BOOL needInsertKeyStackLine;
@property (nonatomic, assign) int errorCode;
@property (nonatomic, copy) NSString *causeBy;

@end
