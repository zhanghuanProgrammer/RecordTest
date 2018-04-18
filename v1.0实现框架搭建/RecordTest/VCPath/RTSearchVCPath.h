
#import <Foundation/Foundation.h>

@interface RTSearchVCPath : NSObject

+ (RTSearchVCPath *)shareInstance;
@property (nonatomic,weak)UIViewController *curVC;

@property (nonatomic,assign)BOOL isLearnVCPath;

- (BOOL)canGoToVC:(NSString *)vc;
- (void)goToVC:(NSString *)vc;

@end
