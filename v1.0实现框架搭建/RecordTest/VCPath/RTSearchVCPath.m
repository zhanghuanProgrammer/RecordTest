
#import "RTSearchVCPath.h"

@implementation RTSearchVCPath

+ (RTSearchVCPath *)shareInstance{
    static dispatch_once_t pred = 0;
    __strong static RTSearchVCPath *_sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[RTSearchVCPath alloc] init];
    });
    return _sharedObject;
}

- (void)goToRootVC{
    if (self.curVC.navigationController && [self.curVC.navigationController isKindOfClass:[UINavigationController class]]) {
        [self.curVC.navigationController popToRootViewControllerAnimated:NO];
    }else{
        [self.curVC dismissViewControllerAnimated:NO completion:nil];
    }
}

- (BOOL)canPopToVC:(NSString *)vc{
    UIViewController *controllerTarget = nil;
    for (UIViewController * controller in self.curVC.navigationController.viewControllers) { //遍历
        if ([controller isKindOfClass:NSClassFromString(vc)]) { //这里判断是否为你想要跳转的页面
            controllerTarget = controller;
        }
    }
    if (controllerTarget) {
        return YES;
    }
    return NO;
}

- (BOOL)canGoToVC:(NSString *)vc{
    return NO;
}

- (void)goToVC:(NSString *)vc{
    
}

@end
