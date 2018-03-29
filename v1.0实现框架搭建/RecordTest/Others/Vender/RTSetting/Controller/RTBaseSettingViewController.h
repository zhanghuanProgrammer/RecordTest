
#import <UIKit/UIKit.h>
#import "RTSettingGroup.h"
#import "RTSettingItem.h"

@interface RTBaseSettingViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *_allGroups; // 所有的组模型
}
@end
