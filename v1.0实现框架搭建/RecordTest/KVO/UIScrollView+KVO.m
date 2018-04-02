
#import "UIScrollView+KVO.h"
#import "RecordTestHeader.h"

@implementation UIScrollView (KVO)

- (void)kvo{
    if (self.isKVO) {
        return;
    }
    if (KVO_Scroll) {
        [[RACObserve(self, contentOffset) distinctUntilChanged] subscribeNext:^(id x) {
            [RTOperationQueue addOperation:self type:(RTOperationQueueTypeScroll) parameters:@[x] repeat:NO];
        }];
    }
    self.isKVO = YES;
}

- (BOOL)runOperation:(RTOperationQueueModel *)model{
    BOOL result = NO;
    if (model) {
        if (model.viewId.length == self.layerDirector.length) {
            if ([model.viewId isEqualToString:self.layerDirector]) {
                if (model.type == RTOperationQueueTypeScroll) {
                    CGPoint point = [model.parameters[0] CGPointValue];
                    if (!CGRectContainsPoint(CGRectMake(0, 0, self.contentSize.width, self.contentSize.height), point)) {
                        NSLog(@"%@",@"滚动的位置 超出 可滚动的区域");
                    }
                    [self setContentOffset:point animated:YES];
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
