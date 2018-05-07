
#import "AppDelegate+ThirdService.h"

@implementation AppDelegate (ThirdService)

-(void)initThirdService
{
    [self initShakeWindow];
}

-(void)initShakeWindow
{
    Class class = NSClassFromString(@"BugKitShakeWindow");
    self.window = [[class alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
}

@end
