
#import "UIControl+KVO.h"
#import "RecordTestHeader.h"

@implementation UIControl (KVO)

- (void)kvo{
    if (self.isKVO) {
        return;
    }
    [[self rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"++++++按钮点击了");
    }];
    self.isKVO = YES;
}

@end
