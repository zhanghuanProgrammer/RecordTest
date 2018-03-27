
#import "UIView+RT.h"

static const int is_KVO;
static const int is_NoNeedKVO;

@implementation UIView (RT)

- (BOOL)isKVO{
    id num=objc_getAssociatedObject(self, &is_KVO);
    if (num) {
        return [num boolValue];
    }
    return NO;
}

- (void)setIsKVO:(BOOL)isKVO{
    objc_setAssociatedObject(self, &is_KVO, [NSNumber numberWithBool:isKVO], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isNoNeedKVO{
    id num=objc_getAssociatedObject(self, &is_NoNeedKVO);
    if (num) {
        return [num boolValue];
    }
    return NO;
}

- (void)setIsNoNeedKVO:(BOOL)isNoNeedKVO{
    objc_setAssociatedObject(self, &is_NoNeedKVO, [NSNumber numberWithBool:isNoNeedKVO], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
