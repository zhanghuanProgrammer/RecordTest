
#import "RTViewHierarchy.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreImage/CoreImage.h>
#import "UIView+Frame.h"
#import "SuspendBall.h"
#import "RTCommandList.h"

#if !__has_feature(objc_arc)
#error add -fobjc-arc to compiler flags
#endif

@interface RTViewImageHolder : NSObject
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, assign) CGRect rect;
@property (nonatomic, retain) UIView *view;
@property (nonatomic, assign) NSInteger layerIndex;
@property (nonatomic, assign) uint64_t superView;

@end

@implementation RTViewImageHolder
@synthesize image = _image;
@synthesize rect = _rect;
@synthesize view = _view;
@end

@interface RTViewHierarchy ()
@property (nonatomic, retain) NSMutableArray *holders;
@end

@implementation RTViewHierarchy
@synthesize holders = _holders;

- (UIImage *)renderImageFromView:(UIView *)view {
    return [self renderImageFromView:view withRect:view.bounds];
}

- (UIImage *)renderImageFromView:(UIView *)view withRect:(CGRect)frame {
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!context) {
        return nil;
    }
    CGContextTranslateCTM(context, -frame.origin.x, -frame.origin.y);
    [view.layer renderInContext:context];
    UIImage *renderedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return renderedImage;
}

- (UIImage *)snap {
//    return [self renderImageFromView:[UIApplication sharedApplication].keyWindow];
    UIView *backView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.holders = nil;
    self.holders = [NSMutableArray arrayWithCapacity:100];
    
    for (int i = 0; i < [UIApplication sharedApplication].windows.count; i++) {
        //每个window都要加上去,但是可能出现有时候手误加了一个透明的window在最上面,导致下面的被挡住
        UIWindow *window = [UIApplication sharedApplication].windows[i];
        if (window.subviews.count > 0) {
//            [self    dumpView:window
//                    superView:0
//                   layerIndex:0
//                      toArray:_holders];
            [self dumpView:window];
        }
    }
    
    for (RTViewImageHolder *h in _holders) {
        UIImageView *imgV = [[UIImageView alloc] initWithImage:h.image];
        imgV.contentMode = UIViewContentModeTopLeft;
        imgV.frame = h.rect;
        imgV.clipsToBounds = YES;
        [backView addSubview:imgV];
        h.view = imgV;
        CGRect r = imgV.frame;
        CGRect scr = [UIScreen mainScreen].bounds;
        imgV.layer.anchorPoint = CGPointMake((scr.size.width / 2 - imgV.frame.origin.x) / imgV.frame.size.width,
                                             (scr.size.height / 2 - imgV.frame.origin.y) / imgV.frame.size.height);
        imgV.frame = r;
        imgV.layer.backgroundColor = [UIColor clearColor].CGColor;
    }
    return [self renderImageFromView:backView];
}

- (void) dumpView:(UIView *)aView{
    RTViewImageHolder *holder = [[RTViewImageHolder alloc] init];
    holder.image = [self renderImageFromView:aView];
    holder.rect = [aView rectIntersectionInWindow];// 获取 该view与window 交叉的 Rect
    [_holders addObject:holder];
}

#pragma mark - 核心逻辑

- (void) dumpView:(UIView *)aView
        superView:(UIView *)superView
       layerIndex:(NSInteger)layerIndex
          toArray:(NSMutableArray *)holders {
    //如果视图是隐藏不可见的,就忽略不计
    if (aView.hidden || aView.alpha <0.01 || aView.width <= 0 || aView.height <= 0) {
        return;
    }
    
    NSMutableArray *notHiddens = [NSMutableArray arrayWithCapacity:0];
    for (UIView *v in aView.subviews) {
        if (!v.hidden) {
            [notHiddens addObject:v];
            v.hidden = YES;
        }
    }
    UIImage *img = [self renderImageFromView:aView];
    for (UIView *v in notHiddens) {
        v.hidden = NO;
    }
    
    if (img) {
        RTViewImageHolder *holder = [[RTViewImageHolder alloc] init];
        holder.image = img;
        holder.layerIndex = layerIndex;
        holder.superView = (uint64_t)superView;
        holder.rect = [aView rectIntersectionInWindow];// 获取 该view与window 交叉的 Rect
        
        if (!(CGRectIsEmpty(holder.rect) || CGRectIsNull(holder.rect))) {
            CGRect canShowFrame = [aView canShowFrameRecursive];
            if (!(CGRectIsEmpty(canShowFrame) || CGRectIsNull(canShowFrame))){
                if (!CGRectEqualToRect(canShowFrame, [UIScreen mainScreen].bounds)) {
                    holder.rect = canShowFrame;
                }
                if ([aView isHitTest]) {
                    [holders addObject:holder];
                }
            }
        }
    }
    
    for (int i = 0; i < aView.subviews.count; i++) {
        UIView *v = aView.subviews[i];
        [self dumpView:v superView:aView layerIndex:layerIndex+1 toArray:holders];
    }
}

@end
