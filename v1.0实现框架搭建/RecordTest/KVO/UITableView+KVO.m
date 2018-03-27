
#import "UITableView+KVO.h"
#import "RecordTestHeader.h"

@implementation UITableView (KVO)

- (void)kvo{
    if (self.isKVO) {
        return;
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
    if (KVO_Super) {
        [super kvo];
    }
    self.isKVO = YES;
}

- (void)runOperation:(RTOperationQueueModel *)model{
    if (model) {
        if (model.viewId.length == self.layerDirector.length) {
            if ([model.viewId isEqualToString:self.layerDirector]) {
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
    [super runOperation:model];
}

@end
