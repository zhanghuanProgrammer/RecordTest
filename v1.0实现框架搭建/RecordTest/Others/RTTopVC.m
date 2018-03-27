//
//  RTTopVC.m
//  CJOL
//
//  Created by mac on 2018/3/25.
//  Copyright © 2018年 SuDream. All rights reserved.
//

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
            [[RTCommandList shareInstance]initData];
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
    for (int i = 0; i < [UIApplication sharedApplication].windows.count; i++) {
        UIWindow *window = [UIApplication sharedApplication].windows[i];
        if (window.subviews.count > 0) {
            return [self dumpView:window isExsitVC:vc];
        }
    }
    return NO;
}

- (BOOL)dumpView:(UIView *)aView isExsitVC:(NSString *)vc{
    if (aView.curViewController.length == vc.length) {
        if ([aView.curViewController isEqualToString:vc]) {
            return YES;
        }
    }
    //继续递归遍历
    for (UIView *view in [aView subviews]){
        return [self dumpView:view isExsitVC:vc];
    }
    return NO;
}


@end

