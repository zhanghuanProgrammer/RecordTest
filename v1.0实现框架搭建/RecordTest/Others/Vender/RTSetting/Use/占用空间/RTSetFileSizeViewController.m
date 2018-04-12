
#import "RTSetFileSizeViewController.h"
#import "RecordTestHeader.h"
#import "RTFileListVC.h"

@interface RTSetFileSizeViewController ()

@end

@implementation RTSetFileSizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"占用的存储空间";
    [TabBarAndNavagation setRightBarButtonItemTitle:@"清除过期" TintColor:[UIColor redColor] target:self action:@selector(delete)];
    [self loadData];
}

- (void)loadData{
    [self.allGroups removeAllObjects];
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
    title = [NSString stringWithFormat:@"总个数: %@",[RTOperationImage videoFileCount]];
    subTitle = [NSString stringWithFormat:@"%@",[RTOperationImage videoFileSize]];
    RTSettingItem *item3 = [RTSettingItem itemWithIcon:@"" title:title subTitle:subTitle type:ZFSettingItemTypeNone];
    item3.subTitleFontSize = 12;
    RTSettingGroup *group3 = [[RTSettingGroup alloc] init];
    group3.header = @"所有录制的视频占用的存储空间";
    group3.items = @[item3];
    [self.allGroups addObject:group3];
    title = [NSString stringWithFormat:@"总个数: %@",[RTOperationImage videoPlayBackFileCount]];
    subTitle = [NSString stringWithFormat:@"%@",[RTOperationImage videoPlayBackFileSize]];
    RTSettingItem *item4 = [RTSettingItem itemWithIcon:@"" title:title subTitle:subTitle type:ZFSettingItemTypeNone];
    item4.subTitleFontSize = 12;
    RTSettingGroup *group4 = [[RTSettingGroup alloc] init];
    group4.header = @"所有运行回放视频的存储空间";
    group4.footer = [NSString stringWithFormat:@"总占用空间: %@",[RTOperationImage allSize]];
    group4.items = @[item4];
    [self.allGroups addObject:group4];
    [self.tableView reloadData];
}

- (void)delete{
    [RTOperationImage deleteOverduePlayBackVideo];
    [RTOperationImage deleteOverdueVideo];
    [RTOperationImage deleteOverdueImage];
    [RTOperationImage deleteOverduePlayBackImage];
    [TabBarAndNavagation setRightBarButtonItemTitle:@"沙盒浏览" TintColor:[UIColor redColor] target:self action:@selector(sandbox)];
    [self loadData];
}

- (void)sandbox{
    [self.navigationController pushViewController:[RTFileListVC new] animated:YES];
}

@end
