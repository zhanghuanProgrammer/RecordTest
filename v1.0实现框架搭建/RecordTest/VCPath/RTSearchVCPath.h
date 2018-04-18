
#import <Foundation/Foundation.h>
#import "RTOperationQueue.h"

@interface RTSearchVCPath : NSObject

+ (RTSearchVCPath *)shareInstance;
@property (nonatomic,weak)UIViewController *curVC;

@property (nonatomic,assign)BOOL isLearnVCPath;

+ (void)addOperation:(UIView *)view type:(RTOperationQueueType)type parameters:(NSArray *)parameters repeat:(BOOL)repeat;

- (BOOL)canGoToVC:(NSString *)vc;
- (void)goToVC:(NSString *)vc;

@end
