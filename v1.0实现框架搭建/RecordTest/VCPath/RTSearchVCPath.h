
#import <Foundation/Foundation.h>

@interface RTSearchVCPath : NSObject

+ (RTSearchVCPath *)shareInstance;
@property (nonatomic,weak)UIViewController *curVC;
@property (nonatomic,strong)NSMutableDictionary *topology;
@property (nonatomic,assign)BOOL isLearnVCPath;

- (void)adjustTopology:(NSArray *)vcStack;

- (BOOL)canGoToVC:(NSString *)vc;
- (void)goToVC:(NSString *)vc;

@end
