//
//  UITextField+KVO.m
//  CJOL
//
//  Created by mac on 2018/3/23.
//  Copyright © 2018年 SuDream. All rights reserved.
//

#import "UITextField+KVO.h"
#import "RecordTestHeader.h"

@implementation UITextField (KVO)

- (void)kvo{
    if (self.isKVO) {
        return;
    }
    if (KVO_TextField) {
        [self.rac_textSignal subscribeNext:^(id x) {
            NSLog(@"👌TextField 文字改变了%@",x);
            [RTOperationQueue addOperation:self type:(RTOperationQueueTypeTextChange) parameters:@[x] repeat:NO];
        }];
    }
    if(KVO_Super) [super kvo];
    self.isKVO = YES;
}

- (BOOL)runOperation:(RTOperationQueueModel *)model{
    BOOL result = NO;
    if (model) {
        if (model.viewId.length == self.layerDirector.length) {
            if ([model.viewId isEqualToString:self.layerDirector]) {
                if (model.type == RTOperationQueueTypeTextChange) {
                    NSString *text = model.parameters[0];
                    if (self.delegate) {
                        if([self.delegate respondsToSelector:@selector(textFieldShouldBeginEditing:)])
                            [self.delegate textFieldShouldBeginEditing:self];
                        if([self.delegate respondsToSelector:@selector(textFieldDidBeginEditing:)])
                            [self.delegate textFieldDidBeginEditing:self];
                    }
                    
                    self.text = text;
                    
                    if (self.delegate) {
                        if([self.delegate respondsToSelector:@selector(textFieldShouldEndEditing:)])
                            [self.delegate textFieldShouldEndEditing:self];
                        if([self.delegate respondsToSelector:@selector(textFieldDidEndEditing:)])
                            [self.delegate textFieldDidEndEditing:self];
                        if([self.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)])
                            [self.delegate textField:self shouldChangeCharactersInRange:NSMakeRange(0, 0) replacementString:text];
                    }
                    result = YES;
                }
            }
        }
    }
    if ([super runOperation:model]) {
        result = YES;
    }
    return result;
}

@end
