//
//  RTTopVC.m
//  CJOL
//
//  Created by mac on 2018/3/25.
//  Copyright © 2018年 SuDream. All rights reserved.
//

#import "RTTopVC.h"
#import "RecordTestHeader.h"

@implementation RTTopVC

+ (RTTopVC*)shareInstance{
    static dispatch_once_t pred = 0;
    __strong static RTTopVC* _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[RTTopVC alloc] init];
    });
    return _sharedObject;
}

- (void)hookTopVC{
    if (Run) {
        [UIViewController aspect_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info) {
            NSString* className = NSStringFromClass([[info instance] class]);
            self.topVC = className;
            NSLog(@"🙄🙄🙄🙄🙄🙄🙄:%@",className);
        } error:NULL];
    }
}

@end

