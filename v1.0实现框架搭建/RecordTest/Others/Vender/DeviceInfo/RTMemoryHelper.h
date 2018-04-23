
#import <Foundation/Foundation.h>

@interface RTMemoryHelper : NSObject

/**
 *  内存占用
 */
+ (unsigned long long)bytesOfUsedMemory;

/**
 *  内存占用
 */
- (NSString *)bytesOfUsedMemory;

@end
