
#import "RTSettingViewController.h"
#import "RecordTestHeader.h"

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
    // 1.1.录制测试设置
    RTSettingItem *item1 = //[RTSettingItem itemWithIcon:@"MorePush" title:@"新消息通知" type:ZFSettingItemTypeArrow];
    [RTSettingItem itemWithIcon:@"" title:@"截图压缩率" detail:@"录制过程屏幕截图的压缩率" type:ZFSettingItemTypeArrow];
    //cell点击事件
    item1.operation = ^{
    };
    
    RTSettingGroup *group = [[RTSettingGroup alloc] init];
    group.header = @"录制测试设置";
    group.items = @[item1];
    [self.allGroups addObject:group];
    
    
    // 1.2.测试回放设置
    RTSettingItem *item2 = [RTSettingItem itemWithIcon:@"" title:@"录制截图自动清除" subTitle:@"30天" type:ZFSettingItemTypeSwitch];
    item2.subTitleFontSize = 10;
    //开关事件
    item2.switchBlock = ^(BOOL on) {
        
    };
    RTSettingGroup *group2 = [[RTSettingGroup alloc] init];
    group2.header = @"测试回放设置";
    group2.items = @[item2];
    [self.allGroups addObject:group2];
}


@end
