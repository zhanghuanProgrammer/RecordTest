
#import "RTViewHierarchy.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreImage/CoreImage.h>
#import "UIView+Frame.h"
#import "SuspendBall.h"
#import "RTCommandList.h"
#import "RAYNewFunctionGuideVC.h"
#import "SuspendBall.h"

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
    
    [SuspendBall shareInstance].alpha = 0;
    for (int i = 0; i < [UIApplication sharedApplication].windows.count; i++) {
        UIWindow *window = [UIApplication sharedApplication].windows[i];
        if (window.subviews.count > 0) {
            [self renderImageFromWindow:window];
        }
    }
    [SuspendBall shareInstance].alpha = 1;
    
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
    if (highlightView) {
        CGRect rect = [highlightView rectIntersectionInWindow];// 获取 该view与window 交叉的 Rect
        if (!(CGRectIsEmpty(rect) || CGRectIsNull(rect))) {
            RAYNewFunctionGuideVC *vc = [RAYNewFunctionGuideVC new];
            vc.titleGuide = @"新增功能";
            vc.frameGuide = rect;
            vc.view.frame = backView.bounds;
            [backView addSubview:vc.view];
        }
    }
    UIImage *snapImage = [self renderImageFromView:backView];
    return snapImage;
}

- (void)renderImageFromWindow:(UIView *)aView{
    RTViewImageHolder *holder = [[RTViewImageHolder alloc] init];
    holder.image = [self renderImageFromView:aView];
    holder.rect = [aView rectIntersectionInWindow];// 获取 该view与window 交叉的 Rect
    [_holders addObject:holder];
}

@end
