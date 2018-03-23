
#import "UIControl+KVO.h"
#import "RecordTestHeader.h"

@implementation UIControl (KVO)

- (void)kvo{
    if (self.isKVO) {
        return;
    }
    if (KVO_Event) {
        NSSet *allTargets=[self allTargets];
        if (allTargets.count>0) {
            for (id target in allTargets) {
                NSArray *actions = [self actionsForTarget:target forControlEvent:(UIControlEventTouchUpInside)];
                if (actions.count > 0) {
                    NSString *action = actions[0];
                    SEL sel = NSSelectorFromString(action);
                    if (target && [target respondsToSelector:sel]) {
                        [target aspect_hookSelector:sel withOptions:AspectPositionAfter usingBlock:^{
                        } before:nil after:^(id target, SEL sel, NSArray *args, NSTimeInterval interval, int deep, id retValue) {
                            NSLog(@"%@ - %@ : %@",@"👌Control evevnt",target,NSStringFromSelector(sel));
                        } error:nil];
                    }
                }
            }
        }else{
            if (KVO_Super) {
                [super kvo];
            }
        }
    }
    self.isKVO = YES;
}

@end
