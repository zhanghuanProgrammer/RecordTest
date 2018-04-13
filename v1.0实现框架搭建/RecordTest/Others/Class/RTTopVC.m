
#import "RTTopVC.h"
#import "RecordTestHeader.h"

@interface RTTopVC ()

@property (nonatomic,strong)NSMutableArray *vcStack;

@end

@implementation RTTopVC

+ (RTTopVC*)shareInstance{
    static dispatch_once_t pred = 0;
    __strong static RTTopVC* _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[RTTopVC alloc] init];
        _sharedObject.vcStack = [NSMutableArray array];
    });
    return _sharedObject;
}

- (void)hookTopVC{
    if (Run) {
        [UIViewController aspect_hookSelector:@selector(viewDidAppear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info) {
            NSString* className = NSStringFromClass([[info instance] class]);
            self.topVC = className;
            [self.vcStack addObject:className];
            [[RTSearchVCPath shareInstance] adjustTopology:self.vcStack];
            [[RTCommandList shareInstance] initData];
            [[KVOAllView new] kvoAllView];
        } error:NULL];
        
        [UIViewController aspect_hookSelector:@selector(viewDidDisappear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info) {
            NSString* className = NSStringFromClass([[info instance] class]);
            [self popVC:className];
            [self popNoExsitVC];
            [[RTCommandList shareInstance]initData];
        } error:NULL];
    }
}

- (void)popVC:(NSString *)vc{
    for (NSInteger i=self.vcStack.count-1; i>=0; i--) {
        NSString *className = self.vcStack[i];
        if ([className isEqualToString:vc]) {
            [self.vcStack removeObjectAtIndex:i];
            break;
        }
    }
}

- (void)popNoExsitVC{
    NSString *topVC = [self.vcStack lastObject];
    while (topVC && [self isExsitVC:topVC] == NO) {
        [self.vcStack popLastObject];
        topVC = [self.vcStack lastObject];
    }
    self.topVC = topVC;
}

- (BOOL)isExsitVC:(NSString *)vc{
    BOOL result = NO;
    for (int i = 0; i < [UIApplication sharedApplication].windows.count; i++) {
        UIWindow *window = [UIApplication sharedApplication].windows[i];
        if (window.subviews.count > 0) {
            if ([self dumpView:window isExsitVC:vc]) {
                result = YES;
                break;
            }
        }
    }
    return result;
}

- (BOOL)dumpView:(UIView *)aView isExsitVC:(NSString *)vc{
    BOOL result = NO;
    if(!aView.curViewController || aView.curViewController.length<=0){
        aView.curViewController=NSStringFromClass([aView getViewController].class);
    }
    if (aView.curViewController.length == vc.length) {
        if ([aView.curViewController isEqualToString:vc]) {
            if ([self viewIsCanShowInWindow:aView]) {
                return YES;
            }
        }
    }
    //继续递归遍历
    for (UIView *view in [aView subviews]){
        if ([self dumpView:view isExsitVC:vc]) {
            result = YES;
            break;
        }
    }
    return result;
}

- (BOOL)viewIsCanShowInWindow:(UIView *)view{
    CGRect rect = [view rectIntersectionInWindow];// 获取 该view与window 交叉的 Rect
    if (!(CGRectIsEmpty(rect) || CGRectIsNull(rect))) {
        CGRect canShowFrame = [view canShowFrameRecursive];
        if (!(CGRectIsEmpty(canShowFrame) || CGRectIsNull(canShowFrame))){
            return YES;
        }
    }
    return NO;
}

@end

