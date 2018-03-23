
#import "UITableView+KVO.h"
#import "RecordTestHeader.h"

@implementation UITableView (KVO)

- (void)kvo{
    if (self.isKVO) {
        return;
    }
    if (KVO_Scroll) {
        [RACObserve(self, contentOffset) subscribeNext:^(id x) {
            [RTOperationQueue addOperation:self type:(RTOperationQueueTypeScroll) parameters:@[x] repeat:NO];
            // NSLog(@"%@",@"👌tableView scrolling");
        }];
    }
    if (KVO_tableView_didSelectRowAtIndexPath) {
        if (self.delegate) {
            id delegate= self.delegate;
            [delegate aspect_hookSelector:@selector(tableView:didSelectRowAtIndexPath:) withOptions:AspectPositionAfter usingBlock:^{
            } before:nil after:^(id target, SEL sel, NSArray *args, NSTimeInterval interval, int deep, id retValue) {
                UITableView *tableView = args[0];
                NSIndexPath *indexPath = args[1];
                [RTOperationQueue addOperation:tableView type:(RTOperationQueueTypeTableViewCellTap) parameters:@[@(indexPath.section),@(indexPath.row)] repeat:YES];
                NSLog(@"%@",@"👌tableView:didSelectRowAtIndexPath:");
            } error:nil];
        }
    }
    self.isKVO = YES;
}

- (void)runOperation{
    RTOperationQueueModel *model = [RTOperationQueue shareInstance].curOperationModel;
    if (model) {
        if (model.viewId.length == self.layerDirector.length) {
            if ([model.viewId isEqualToString:self.layerDirector]) {
                [self cornerRadiusWithFloat:0 borderColor:[UIColor redColor] borderWidth:10];
                if (model.type == RTOperationQueueTypeScroll) {
                    CGPoint point = [model.parameters[0] CGPointValue];
                    if (!CGRectContainsPoint(CGRectMake(0, 0, self.contentSize.width, self.contentSize.height), point)) {
                        NSLog(@"%@",@"滚动的位置 超出 可滚动的区域");
                    }
                    [self setContentOffset:point animated:YES];
                }
                if (model.type == RTOperationQueueTypeTableViewCellTap) {
                    if (self.delegate) {
                        id delegate= self.delegate;
                        if ([delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
                            @try {
                                [delegate tableView:self didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:[model.parameters[1] integerValue] inSection:[model.parameters[0] integerValue]]];
                            } @catch (NSException *exception) {
                                //捕获异常
                            } @finally {
                                //这里一定执行，无论你异常与否
                            }
                        }
                    }
                }
            }
        }
    }
}

@end
