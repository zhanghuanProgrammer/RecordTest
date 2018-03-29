
#import "RTViewHierarchy.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreImage/CoreImage.h>
#import "UIView+Frame.h"
#import "SuspendBall.h"
#import "RTCommandList.h"
#import "RAYNewFunctionGuideVC.h"

#if !__has_feature(objc_arc)
#error add -fobjc-arc to compiler flags
#endif

@interface RTViewImageHolder : NSObject
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, assign) CGRect rect;
@end

@implementation RTViewImageHolder
@synthesize image = _image;
@synthesize rect = _rect;
@end

@interface RTViewHierarchy ()
@property (nonatomic, retain) NSMutableArray *holders;
@property (nonatomic,strong)RAYNewFunctionGuideVC *guideVC;
@end

@implementation RTViewHierarchy
@synthesize holders = _holders;

- (UIImage *)renderImageFromView:(UIView *)view{
    UIImage *img;
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);
    BOOL result = [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
    if (!result) {
        @try {
            [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
        } @catch (NSException *exception) {
            //捕获异常
        } @finally {
            //这里一定执行，无论你异常与否
        }
    }
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (UIImage *)snap:(UIView *)highlightView{
    UIView *backView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.holders = nil;
    self.holders = [NSMutableArray arrayWithCapacity:100];
    
    for (int i = 0; i < [UIApplication sharedApplication].windows.count; i++) {
        UIWindow *window = [UIApplication sharedApplication].windows[i];
        if (window.subviews.count > 0) {
            [self dumpView:window highlight:YES highlightView:highlightView];
            [self renderImageFromWindow:window];
        }
    }
    
    for (RTViewImageHolder *h in _holders) {
        UIImageView *imgV = [[UIImageView alloc] initWithImage:h.image];
        imgV.contentMode = UIViewContentModeTopLeft;
        imgV.frame = h.rect;
        imgV.clipsToBounds = YES;
        [backView addSubview:imgV];
        CGRect r = imgV.frame;
        CGRect scr = [UIScreen mainScreen].bounds;
        imgV.layer.anchorPoint = CGPointMake((scr.size.width / 2 - imgV.frame.origin.x) / imgV.frame.size.width,
                                             (scr.size.height / 2 - imgV.frame.origin.y) / imgV.frame.size.height);
        imgV.frame = r;
        imgV.layer.backgroundColor = [UIColor clearColor].CGColor;
    }
    if (self.guideVC) {
        self.guideVC.view.frame = backView.bounds;
        [backView addSubview:self.guideVC.view];
    }
    return [self renderImageFromView:backView];
}

- (void)renderImageFromWindow:(UIView *)aView{
    RTViewImageHolder *holder = [[RTViewImageHolder alloc] init];
    holder.image = [self renderImageFromView:aView];
    holder.rect = [aView rectIntersectionInWindow];// 获取 该view与window 交叉的 Rect
    [_holders addObject:holder];
}

- (void)dumpView:(UIView *)aView highlight:(BOOL)highlight highlightView:(UIView *)highlightView{
    if (self.guideVC) {
        return;
    }
    if ([aView isEqual:highlightView]) {
        CGRect rect = [aView rectIntersectionInWindow];// 获取 该view与window 交叉的 Rect
        if (!(CGRectIsEmpty(rect) || CGRectIsNull(rect))) {
            RAYNewFunctionGuideVC *vc = [RAYNewFunctionGuideVC new];
            vc.titleGuide = @"新增功能";
            vc.frameGuide = rect;
            vc.targetView = aView;
            self.guideVC = vc;
            return;
        }
    }
    for (int i = 0; i < aView.subviews.count; i++) {
        UIView *v = aView.subviews[i];
        [self dumpView:v highlight:highlight highlightView:highlightView];
    }
}

@end
