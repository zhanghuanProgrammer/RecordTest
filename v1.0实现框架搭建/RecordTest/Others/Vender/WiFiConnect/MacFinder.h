
#import <Foundation/Foundation.h>

#if TARGET_IPHONE_SIMULATOR
#include <net/route.h>
#else
#include "route.h"
#endif

#include "if_ether.h"
#include <arpa/inet.h>

@interface MacFinder : NSObject;

+(NSString*)ip2mac: (NSString*)strIP;

@end
