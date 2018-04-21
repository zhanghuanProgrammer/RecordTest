
#import <Foundation/Foundation.h>
#import "RTOperationQueue.h"

@interface RTSearchVCPath : NSObject

+ (RTSearchVCPath *)shareInstance;
@property (nonatomic,strong)NSMutableArray *operationQueue;

@property (nonatomic,assign)BOOL isLearnVCPath;

+ (void)addOperation:(UIView *)view type:(RTOperationQueueType)type parameters:(NSArray *)parameters repeat:(BOOL)repeat;

- (NSArray *)stepGoToVc:(NSString *)vc;
- (NSArray *)allCanGotoVcs;

@end
