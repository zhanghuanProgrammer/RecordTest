
#import <Foundation/Foundation.h>

@interface RTVCLearn : NSObject

+ (RTVCLearn *)shareInstance;

- (void)setUnionVC:(NSArray *)vcs;
- (void)setTopologyVCMore:(NSArray *)vcStack;

@end
