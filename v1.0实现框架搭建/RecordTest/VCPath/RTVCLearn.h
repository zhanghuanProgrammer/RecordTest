
#import <Foundation/Foundation.h>

@interface RTVCLearn : NSObject

+ (RTVCLearn *)shareInstance;

- (void)setUnionVC:(NSArray *)vcs;
- (void)setTopologyVCMore:(NSArray *)vcStack;
- (NSString *)getVcIdentity:(NSString *)vc;
- (NSString *)getVcWithIdentity:(NSString *)identity;

@end
