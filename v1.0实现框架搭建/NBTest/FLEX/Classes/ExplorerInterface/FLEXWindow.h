
#import <UIKit/UIKit.h>

@protocol FLEXWindowEventDelegate;

@interface FLEXWindow : UIWindow

@property (nonatomic, weak) id <FLEXWindowEventDelegate> eventDelegate;

@end

@protocol FLEXWindowEventDelegate <NSObject>

- (BOOL)shouldHandleTouchAtPoint:(CGPoint)pointInWindow;
- (BOOL)canBecomeKeyWindow;

@end
