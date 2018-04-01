
#import "RTSettingViewController.h"
#import "RecordTestHeader.h"
#import "RTPickerManager.h"

@interface RTSettingViewController ()
@end

@implementation RTSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 1.第0组：3个
    [self add0SectionItems];
}

#pragma mark 添加第0组的模型数据
- (void)add0SectionItems
{
    __weak typeof(self)weakSelf=self;
    // 1.1.录制测试设置
    RTSettingItem *item1 = //[RTSettingItem itemWithIcon:@"MorePush" title:@"新消息通知" type:ZFSettingItemTypeArrow];
    [RTSettingItem itemWithIcon:@"" title:@"截图压缩率" detail:@"录制过程屏幕截图的压缩率 0" type:ZFSettingItemTypeArrow];
    //cell点击事件
    __weak typeof(item1)weakItem1=item1;
    item1.operation = ^{
        NSMutableArray *dataArr = [NSMutableArray array];
        for (NSInteger i=0; i<=10; i++) {
            [dataArr addObject:[NSString stringWithFormat:@"%0.1f",i/10.0]];
        }
        NSString *curTitle = dataArr[0];
        if ([RTConfigManager shareInstance].compressionQuality != -1) {
            curTitle = [NSString stringWithFormat:@"%0.2f",[RTConfigManager shareInstance].compressionQuality];
        }
        [[RTPickerManager shareManger] showPickerViewWithDataArray:dataArr curTitle:curTitle title:@"选择截图压缩率" cancelTitle:@"取消" commitTitle:@"确定" commitBlock:^(NSString *string) {
            weakItem1.detail = [NSString stringWithFormat:@"录制过程屏幕截图的压缩率: %@",string];
            [(UITableView *)weakSelf.view reloadData];
        } cancelBlock:^{
            
        }];
    };
    
    RTSettingGroup *group = [[RTSettingGroup alloc] init];
    group.header = @"录制测试设置";
    group.items = @[item1];
    [self.allGroups addObject:group];
    
    
    // 1.2.测试回放设置
    RTSettingItem *item2 = [RTSettingItem itemWithIcon:@"" title:@"录制截图自动清除" subTitle:@"30天" type:ZFSettingItemTypeSwitch];
    item2.subTitleFontSize = 10;
    __weak typeof(item2)weakItem2=item2;
    //开关事件
    item2.switchBlock = ^(BOOL on) {
        
    };
    item2.operation = ^{
        NSMutableArray *dataArr = [NSMutableArray array];
        for (NSInteger i=5; i<=30; i++) {
            [dataArr addObject:[NSString stringWithFormat:@"%zd天",i]];
        }
        NSString *curTitle = dataArr[0];
        if ([RTConfigManager shareInstance].autoDeleteDay != -1) {
            curTitle = [NSString stringWithFormat:@"%zd天",[RTConfigManager shareInstance].autoDeleteDay];
        }
        [[RTPickerManager shareManger] showPickerViewWithDataArray:dataArr curTitle:curTitle title:@"选择截图压缩率" cancelTitle:@"取消" commitTitle:@"确定" commitBlock:^(NSString *string) {
            weakItem2.detail = [NSString stringWithFormat:@"%@天",string];
            [(UITableView *)weakSelf.view reloadData];
        } cancelBlock:^{
            
        }];
    };
    RTSettingGroup *group2 = [[RTSettingGroup alloc] init];
    group2.header = @"测试回放设置";
    group2.items = @[item2];
    [self.allGroups addObject:group2];
}

@end
