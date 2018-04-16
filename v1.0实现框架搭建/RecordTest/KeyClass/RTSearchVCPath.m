
#import "RTSearchVCPath.h"
#import "RecordTestHeader.h"

@implementation RTSearchVCPath

/**判断某类（cls）是否为指定类（acls）的子类*/
- (BOOL)rt_isKindOfClass:(Class)cls acls:(Class)acls{
    Class scls = class_getSuperclass(cls);
    if (scls==acls) return true;
    else if (scls==nil) return false;
    return [self rt_isKindOfClass:scls acls:acls];
}

+ (RTSearchVCPath *)shareInstance{
    static dispatch_once_t pred = 0;
    __strong static RTSearchVCPath *_sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[RTSearchVCPath alloc] init];
        _sharedObject.topology = [NSMutableDictionary dictionary];
    });
    return _sharedObject;
}

- (void)adjustTopology:(NSArray *)vcStack{
    static NSString *lastVC = nil;
    if (vcStack.count > 0) {
        NSString *curVC = [vcStack lastObject];
        if (lastVC && lastVC.length > 0) {
            self.topology[[NSString stringWithFormat:@"%@->%@",lastVC,curVC]] = @"";
        }
        lastVC = curVC;
    }
    NSMutableArray *vcStacks = [NSMutableArray arrayWithArray:vcStack];
//    [[RTTopVC shareInstance]removeNotShowInWindow:vcStacks];
    NSMutableArray *unionVC = [NSMutableArray array];
    for (NSString *vc in vcStacks) {
        Class vcCls = NSClassFromString(vc);
        if ([self rt_isKindOfClass:vcCls acls:[UITabBarController class]]||
            [self rt_isKindOfClass:vcCls acls:[UINavigationController class]]) {
            continue;
        }
        [unionVC addObject:vc];
    }
    NSLog(@"当前最顶部的控制器%@",[RTTopVC shareInstance].topVC);
    NSLog(@"当前所有存在的控制器%@",unionVC);
//    NSLog(@"%@",self.topology);
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
