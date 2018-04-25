
#import <Foundation/Foundation.h>

@class Device;

@interface LANProperties : NSObject

+ (Device*)localIPAddress;

+ (NSString*)getHostFromIPAddress:(NSString*)ipAddress;

+ (NSArray*)getAllHostsForIP:(NSString*)ipAddress andSubnet:(NSString*)subnetMask;

+ (NSString*)fetchSSIDInfo;

@end
