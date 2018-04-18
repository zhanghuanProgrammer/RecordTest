
#import "RTSearchVCPath.h"
#import "RecordTestHeader.h"

@interface RTSearchVCPath ()

@property (nonatomic,strong)NSMutableArray *operationQueue;
@property (nonatomic,assign)BOOL shouldSave;
@property (nonatomic,copy)NSString *searchVCPath;

@end

@implementation RTSearchVCPath

+ (RTSearchVCPath *)shareInstance{
    static dispatch_once_t pred = 0;
    __strong static RTSearchVCPath *_sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[RTSearchVCPath alloc] init];
        _sharedObject.operationQueue = [NSMutableArray array];
        _sharedObject.searchVCPath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/SearchVCPath"];
        [_sharedObject autoSave];
    });
    return _sharedObject;
}

- (void)autoSave{
    if (self.shouldSave) {
        [self.operationQueue writeToFile:self.searchVCPath atomically:YES];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self autoSave];
    });
}

+ (void)addOperation:(UIView *)view type:(RTOperationQueueType)type parameters:(NSArray *)parameters repeat:(BOOL)repeat{
    if (![RTSearchVCPath shareInstance].isLearnVCPath) {
        return;
    }
    [RTSearchVCPath shareInstance].shouldSave = YES;
    if(view.layerDirector.length <= 0) return;
    if (repeat == NO) {
        NSArray *operationQueue = [RTSearchVCPath shareInstance].operationQueue;
        for (NSInteger i = operationQueue.count - 1; i >= 0; i--) {
            RTOperationQueueModel *model = operationQueue[i];
            if (model.type != type) {
                break;
            }
            if ([model.viewId isEqualToString:view.layerDirector] && model.type == type) {
                model.parameters = parameters;
                NSLog(@"%@",[RTSearchVCPath shareInstance].operationQueue);
                return;
            }
        }
    }
    RTOperationQueueModel *model = [RTOperationQueueModel new];
    model.type = type;
    model.viewId = view.layerDirector;
    model.parameters = parameters;
    model.view = NSStringFromClass(view.class);
    model.vc = [RTTopVC shareInstance].topVC;
    [[RTSearchVCPath shareInstance].operationQueue addObject:model];
    while ([RTSearchVCPath shareInstance].operationQueue.count>1000) {
        [[RTSearchVCPath shareInstance].operationQueue removeObjectAtIndex:0];
    }
    NSLog(@"%@",[RTSearchVCPath shareInstance].operationQueue);
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
