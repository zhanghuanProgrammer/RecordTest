
#import "RTSetFileSizeViewController.h"
#import "RecordTestHeader.h"

@interface RTSetFileSizeViewController ()

@end

@implementation RTSetFileSizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"占用的存储空间";
    
    NSString *title = [NSString stringWithFormat:@"总个数: %@   截图张数: %@",[NSString stringWithFormat:@"%zd",[RTOperationQueue operationQueues].count],[RTOperationImage imagesFileCount]];
    NSString *subTitle = [NSString stringWithFormat:@"%@",[RTOperationImage imagesFileSize]];
    RTSettingItem *item1 = [RTSettingItem itemWithIcon:@"" title:title subTitle:subTitle type:ZFSettingItemTypeNone];
    item1.subTitleFontSize = 12;
    RTSettingGroup *group1 = [[RTSettingGroup alloc] init];
    group1.header = @"所有录制占用的存储空间";
    group1.items = @[item1];
    [self.allGroups addObject:group1];
    title = [NSString stringWithFormat:@"总个数: %@   截图张数: %@",[NSString stringWithFormat:@"%zd",[[RTPlayBack shareInstance] playBacks].count],[RTOperationImage imagesPlayBackFileCount]];
    subTitle = [NSString stringWithFormat:@"%@",[RTOperationImage imagesPlayBackFileSize]];
    RTSettingItem *item2 = [RTSettingItem itemWithIcon:@"" title:title subTitle:subTitle type:ZFSettingItemTypeNone];
    item2.subTitleFontSize = 12;
    RTSettingGroup *group2 = [[RTSettingGroup alloc] init];
    group2.header = @"所有运行回放的存储空间";
    group2.items = @[item2];
    [self.allGroups addObject:group2];
}

@end
