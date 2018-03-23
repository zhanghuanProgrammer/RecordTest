
#import <Foundation/Foundation.h>

@interface AutoRecordTest : NSObject

@property (nonatomic,assign)BOOL isRuning;

+ (AutoRecordTest *)shareInstance;

- (void)autoRecord;

@end
