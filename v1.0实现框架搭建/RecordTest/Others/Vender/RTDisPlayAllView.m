//
//  RTDisPlayAllView.m
//  MaiXiang
//
//  Created by mac on 2017/10/24.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "RTDisPlayAllView.h"
#import "UIGestureRecognizer+Ext.h"
#import "AutoTestHeader.h"
#import "UIView+RTLayerIndex.h"


@interface RTDisPlayAllView ()
@property (nonatomic,strong)NSMutableString *outstring;
@end

@implementation RTDisPlayAllView

- (void)addEventView:(ViewHolder *)holder atIndent:(NSInteger)indent {
    //如果需要打印,拼接Log打印
    if(ShouldLogAllView){
        for (int i = 0; i < indent; i++)
            [self.outstring appendString:@"--"];
        
        [self.outstring appendFormat:@"[%2zd] %@ %@ %@\n", indent, [holder.view layerDirector],[holder.view textDescription],NSStringFromClass([holder.view getViewController].class)];
//        [self.outstring appendFormat:@"[%2zd] %@ %@ %@ %@ %@\n", indent, [[holder.view class] description],[holder.view textDescription],NSStringFromCGRect(holder.rect),NSStringFromCGRect([holder.view canShowFrameRecursive]),NSStringFromClass([holder.view getViewController].class)];
    }
}

- (void)allEventView{
    self.outstring = [NSMutableString string];
    for (int i = 0; i < [UIApplication sharedApplication].windows.count; i++) {
        UIWindow *window = [UIApplication sharedApplication].windows[i];
        if (window.subviews.count > 0) {
            [self    dumpView:window
                    superView:0
                   layerIndex:0];
        }
    }
    if (ShouldLogAllView) {
        NSLog(@"Log Window Director:\n%@",self.outstring);
    }
}

- (void) dumpView:(UIView *)aView
        superView:(UIView *)superView
       layerIndex:(NSInteger)layerIndex{
    
    ViewHolder *holder = [[ViewHolder alloc] init];
    holder.view = aView;
    holder.layerIndex = layerIndex;
    holder.superView = (uint64_t)superView;
    holder.rect = [aView rectIntersectionInWindow];// 获取 该view与window 交叉的 Rect
    
    [self addEventView:holder atIndent:layerIndex];
    
    for (int i = 0; i < aView.subviews.count; i++) {
        UIView *v = aView.subviews[i];
        [self dumpView:v superView:aView layerIndex:layerIndex+1];
    }
}

@end
