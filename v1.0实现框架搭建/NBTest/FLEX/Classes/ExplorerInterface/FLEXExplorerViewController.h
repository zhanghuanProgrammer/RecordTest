
#import <UIKit/UIKit.h>

@protocol FLEXExplorerViewControllerDelegate;

@interface FLEXExplorerViewController : UIViewController

@property (nonatomic, weak) id <FLEXExplorerViewControllerDelegate> delegate;

- (BOOL)shouldReceiveTouchAtWindowPoint:(CGPoint)pointInWindowCoordinates;
- (BOOL)wantsWindowToBecomeKey;

- (void)toggleSelectTool;
- (void)toggleMoveTool;
- (void)toggleViewsTool;
- (void)toggleMenuTool;
- (void)handleDownArrowKeyPressed;
- (void)handleUpArrowKeyPressed;
- (void)handleRightArrowKeyPressed;
- (void)handleLeftArrowKeyPressed;

@end

@protocol FLEXExplorerViewControllerDelegate <NSObject>

- (void)explorerViewControllerDidFinish:(FLEXExplorerViewController *)explorerViewController;

@end
