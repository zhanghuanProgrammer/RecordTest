//
//  RTGetTargetView.m
//  CJOL
//
//  Created by mac on 2018/3/23.
//  Copyright © 2018年 SuDream. All rights reserved.
//

#import "RTGetTargetView.h"
#import "RecordTestHeader.h"

@implementation RTGetTargetView

- (UIView *)getTargetView:(NSString *)viewId{
    for (int i = 0; i < [UIApplication sharedApplication].windows.count; i++) {
        UIWindow *window = [UIApplication sharedApplication].windows[i];
        if (window.subviews.count > 0) {
            return [self dumpView:window viewId:viewId];
        }
    }
    return nil;
}

- (UIView *)dumpView:(UIView *)aView viewId:(NSString *)viewId{
    if (aView.layerDirector.length == viewId.length) {
        if ([aView.layerDirector isEqualToString:viewId]) {
            return aView;
        }
    }
    //继续递归遍历
    for (UIView *view in [aView subviews]){
        return [self dumpView:view viewId:viewId];
    }
    return nil;
}

@end
