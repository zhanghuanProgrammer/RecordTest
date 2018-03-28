
#import "UIView+KVO.h"
#import "RecordTestHeader.h"
#import "ZHGestureRecognizerTargetAndAction.h"
#import "UIGestureRecognizer+Ext.h"

@implementation UIView (KVO)

- (void)kvo{
    if (self.isKVO) {
        return;
    }
    if (KVO_Tap) {
        NSArray *gestureRecognizers=self.gestureRecognizers;
        if (gestureRecognizers.count>0) {
            for (UIGestureRecognizer *ges in gestureRecognizers) {
                if ([ges isKindOfClass:[UITapGestureRecognizer class]]) {
                    if (ges.view) {
                        NSArray *allTargetAndAction=[ges allGestureRecognizerTargetAndAction];
                        for (ZHGestureRecognizerTargetAndAction *targetAction in allTargetAndAction) {
                            if (targetAction.target && [targetAction.target respondsToSelector:targetAction.action]) {
                                id target = targetAction.target;
                                __weak typeof(ges.view)weakView=ges.view;
                                [target aspect_hookSelector:targetAction.action withOptions:AspectPositionAfter usingBlock:^{
                                } before:nil after:^(id target, SEL sel, NSArray *args, NSTimeInterval interval, int deep, id retValue) {
                                    NSLog(@"%@",@"👌Tap evevnt");
                                    UIView *view = weakView;
                                    if (args.count>0) {
                                        id obj = args[0];
                                        if([obj isKindOfClass:[UIGestureRecognizer class]]){
                                            UIGestureRecognizer *gesTemp = (UIGestureRecognizer *)obj;
                                            view = gesTemp.view;
                                        }
                                    }
                                    [RTOperationQueue addOperation:view type:(RTOperationQueueTypeTap) parameters:@[NSStringFromSelector(sel)] repeat:YES];
                                } error:nil];
                            }
                        }
                    }
                }
            }
        }
    }
    self.isKVO = YES;
}

- (BOOL)runOperation:(RTOperationQueueModel *)model{
    BOOL result = NO;
    if (model) {
        if (model.viewId.length == self.layerDirector.length) {
            if ([model.viewId isEqualToString:self.layerDirector]) {
                if (model.type == RTOperationQueueTypeTap) {
                    NSArray *gestureRecognizers=self.gestureRecognizers;
                    if (gestureRecognizers.count>0) {
                        for (UIGestureRecognizer *ges in gestureRecognizers) {
                            if ([ges isKindOfClass:[UITapGestureRecognizer class]]) {
                                if (ges.view) {
                                    NSArray *allTargetAndAction=[ges allGestureRecognizerTargetAndAction];
                                    for (ZHGestureRecognizerTargetAndAction *targetAction in allTargetAndAction) {
                                        if (targetAction.target && [targetAction.target respondsToSelector:targetAction.action]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                                            [targetAction.target performSelector:targetAction.action withObject:ges];
                                            result = YES;
#pragma clang diagnostic pop
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    return result;
}

@end
