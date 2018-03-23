
#import "UITableView+KVO.h"
#import "RecordTestHeader.h"

@implementation UITableView (KVO)

- (void)kvo{
    if (self.isKVO) {
        return;
    }
    [RACObserve(self, contentOffset) subscribeNext:^(id x) {
        [RTOperationQueue addOperation:self type:(RTOperationQueueTypeScroll) parameters:@[x] repeat:NO];
    }];
    if (self.delegate) {
        id delegate= self.delegate;
        [delegate aspect_hookSelector:@selector(tableView:didSelectRowAtIndexPath:) withOptions:AspectPositionAfter usingBlock:^{
        } before:nil after:^(id target, SEL sel, NSArray *args, NSTimeInterval interval, int deep, id retValue) {
            UITableView *tableView = args[0];
            NSIndexPath *indexPath = args[1];
            [RTOperationQueue addOperation:tableView type:(RTOperationQueueTypeTableViewCellTap) parameters:@[@(indexPath.section),@(indexPath.row)] repeat:YES];
        } error:nil];
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
                    [self setContentOffset:[model.parameters[0] CGPointValue] animated:YES];
                    [RTOperationQueue shareInstance].curOperationModel = nil;
                }
                if (model.type == RTOperationQueueTypeTableViewCellTap) {
                    if (self.delegate) {
                        id delegate= self.delegate;
                        [delegate tableView:self didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:[model.parameters[1] integerValue] inSection:[model.parameters[0] integerValue]]];
                    }
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        NSLog(@"%@",@"执行下一个命令😄");
                        [RTOperationQueue shareInstance].curOperationModel = nil;
                    });
                }
            }
        }
    }
}

@end
