//
//  UITextView+KVO.m
//  CJOL
//
//  Created by mac on 2018/3/23.
//  Copyright © 2018年 SuDream. All rights reserved.
//

#import "UITextView+KVO.h"
#import "RecordTestHeader.h"

@implementation UITextView (KVO)

- (void)kvo{
    if (self.isKVO) {
        return;
    }
    if (KVO_TextView) {
        [self.rac_textSignal subscribeNext:^(id x) {
            NSLog(@"👌TextView 文字改变了%@",x);
            [RTOperationQueue addOperation:self type:(RTOperationQueueTypeTextChange) parameters:@[x] repeat:NO];
        }];
    }
    if(KVO_Super) [super kvo];
    self.isKVO = YES;
}

- (void)runOperation:(RTOperationQueueModel *)model{
    if (model) {
        if (model.viewId.length == self.layerDirector.length) {
            if ([model.viewId isEqualToString:self.layerDirector]) {
                if (model.type == RTOperationQueueTypeTextChange) {
                    NSString *text = model.parameters[0];
                    self.text = text;
                }
            }
        }
    }
}

@end
