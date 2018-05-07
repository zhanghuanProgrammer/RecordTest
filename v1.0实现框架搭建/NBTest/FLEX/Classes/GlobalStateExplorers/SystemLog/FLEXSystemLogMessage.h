
#import <Foundation/Foundation.h>
#import <asl.h>

@interface FLEXSystemLogMessage : NSObject

+ (instancetype)logMessageFromASLMessage:(aslmsg)aslMessage;

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, copy) NSString *sender;
@property (nonatomic, copy) NSString *messageText;
@property (nonatomic, assign) long long messageID;

@end
