
#import <UIKit/UIKit.h>

@interface FLEXTableListViewController : UITableViewController

+ (BOOL)supportsExtension:(NSString *)extension;
- (instancetype)initWithPath:(NSString *)path;

@end
