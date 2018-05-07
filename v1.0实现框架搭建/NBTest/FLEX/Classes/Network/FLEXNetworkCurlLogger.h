
#import <Foundation/Foundation.h>

@interface FLEXNetworkCurlLogger : NSObject

+ (NSString *)curlCommandString:(NSURLRequest *)request;

@end
