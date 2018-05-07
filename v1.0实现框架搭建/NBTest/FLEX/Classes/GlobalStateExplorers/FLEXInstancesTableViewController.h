
#import <UIKit/UIKit.h>

@interface FLEXInstancesTableViewController : UITableViewController

+ (instancetype)instancesTableViewControllerForClassName:(NSString *)className;
+ (instancetype)instancesTableViewControllerForInstancesReferencingObject:(id)object;

@end
