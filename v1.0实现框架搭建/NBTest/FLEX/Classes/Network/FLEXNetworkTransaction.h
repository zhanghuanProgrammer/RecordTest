
#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"

typedef NS_ENUM(NSInteger, FLEXNetworkTransactionState) {
    FLEXNetworkTransactionStateUnstarted,
    FLEXNetworkTransactionStateAwaitingResponse,
    FLEXNetworkTransactionStateReceivingData,
    FLEXNetworkTransactionStateFinished,
    FLEXNetworkTransactionStateFailed
};

@interface FLEXNetworkTransaction : NSObject

@property (nonatomic, copy) NSString *requestID;

@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong) NSURLResponse *response;
@property (nonatomic, copy) NSString *requestMechanism;
@property (nonatomic, assign) FLEXNetworkTransactionState transactionState;
@property (nonatomic, strong) NSError *error;

@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, assign) NSTimeInterval latency;
@property (nonatomic, assign) NSTimeInterval duration;

@property (nonatomic, assign) int64_t receivedDataLength;

@property (nonatomic, strong) UIImage *responseThumbnail;

@property (nonatomic, strong, readonly) NSData *cachedRequestBody;

+ (NSString *)readableStringFromTransactionState:(FLEXNetworkTransactionState)state;

@end
