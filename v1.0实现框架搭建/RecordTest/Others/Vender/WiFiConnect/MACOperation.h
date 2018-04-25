
#import "SimplePing.h"

@class Device;

@interface MACOperation: NSOperation {
    BOOL _isFinished;
    BOOL _isExecuting;
}

-(nullable instancetype)initWithIPToRetrieveMAC:(nonnull NSString*)ip andBrandDictionary:(nullable NSDictionary*)brandDictionary andCompletionHandler:(nullable void (^)(NSError  * _Nullable error, NSString  * _Nonnull ip,Device * _Nonnull device))result;

@end
