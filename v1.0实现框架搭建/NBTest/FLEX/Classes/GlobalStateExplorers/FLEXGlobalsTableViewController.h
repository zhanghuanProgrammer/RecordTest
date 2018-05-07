
#import <UIKit/UIKit.h>

@protocol FLEXGlobalsTableViewControllerDelegate;

@interface FLEXGlobalsTableViewController : UITableViewController

@property (nonatomic, weak) id <FLEXGlobalsTableViewControllerDelegate> delegate;

+ (void)setApplicationWindow:(UIWindow *)applicationWindow;

@end

@protocol FLEXGlobalsTableViewControllerDelegate <NSObject>

- (void)globalsViewControllerDidFinish:(FLEXGlobalsTableViewController *)globalsViewController;

@end
