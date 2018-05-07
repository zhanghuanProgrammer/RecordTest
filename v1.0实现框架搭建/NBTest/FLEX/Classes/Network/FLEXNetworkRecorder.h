
#import <Foundation/Foundation.h>

extern NSString *const kFLEXNetworkRecorderNewTransactionNotification;
extern NSString *const kFLEXNetworkRecorderTransactionUpdatedNotification;
extern NSString *const kFLEXNetworkRecorderUserInfoTransactionKey;
extern NSString *const kFLEXNetworkRecorderTransactionsClearedNotification;

@class FLEXNetworkTransaction;

@interface FLEXNetworkRecorder : NSObject

+ (instancetype)defaultRecorder;

@property (nonatomic, assign) NSUInteger responseCacheByteLimit;
@property (nonatomic, assign) BOOL shouldCacheMediaResponses;

- (NSArray *)networkTransactions;
- (NSData *)cachedResponseBodyForTransaction:(FLEXNetworkTransaction *)transaction;
- (void)clearRecordedActivity;
- (void)recordRequestWillBeSentWithRequestID:(NSString *)requestID request:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse;
- (void)recordResponseReceivedWithRequestID:(NSString *)requestID response:(NSURLResponse *)response;
- (void)recordDataReceivedWithRequestID:(NSString *)requestID dataLength:(int64_t)dataLength;
- (void)recordLoadingFinishedWithRequestID:(NSString *)requestID responseBody:(NSData *)responseBody;
- (void)recordLoadingFailedWithRequestID:(NSString *)requestID error:(NSError *)error;
- (void)recordMechanism:(NSString *)mechanism forRequestID:(NSString *)requestID;

@end
