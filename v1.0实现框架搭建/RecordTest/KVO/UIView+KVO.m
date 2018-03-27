
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
                                [target aspect_hookSelector:targetAction.action withOptions:AspectPositionAfter usingBlock:^{
                                } before:nil after:^(id target, SEL sel, NSArray *args, NSTimeInterval interval, int deep, id retValue) {
                                    NSLog(@"%@",@"👌Tap evevnt");
                                    [RTOperationQueue addOperation:self type:(RTOperationQueueTypeTap) parameters:@[NSStringFromSelector(sel)] repeat:YES];
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

- (void)runOperation:(RTOperationQueueModel *)model{
    if (model) {
        if (model.viewId.length == self.layerDirector.length) {
            if ([model.viewId isEqualToString:self.layerDirector]) {
                if (model.type == RTOperationQueueTypeEvent) {
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
}

@end
