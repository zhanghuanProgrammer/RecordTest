
#import <Foundation/Foundation.h>

@interface RTSearchVCPath : NSObject

+ (RTSearchVCPath *)shareInstance;
@property (nonatomic,weak)UIViewController *curVC;
@property (nonatomic,strong)NSMutableDictionary *topology;

- (void)adjustTopology:(NSArray *)vcStack;

- (BOOL)canGoToVC:(NSString *)vc;
- (void)goToVC:(NSString *)vc;

@end
