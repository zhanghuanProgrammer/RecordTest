
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
    // 1.1.推送和提醒
    RTSettingItem *push = //[RTSettingItem itemWithIcon:@"MorePush" title:@"新消息通知" type:ZFSettingItemTypeArrow];
    [RTSettingItem itemWithIcon:@"MorePush" title:@"新消息通知" detail:@"新消息通知" type:ZFSettingItemTypeArrow];
    //cell点击事件
    push.operation = ^{
    };
    
    // 1.2.声音提示
    RTSettingItem *shake =
    //[RTSettingItem itemWithIcon:@"sound_Effect" title:@"声音提示" type:ZFSettingItemTypeSwitch];
    [RTSettingItem itemWithIcon:@"sound_Effect" title:@"声音提示" subTitle:@"声音提示" type:ZFSettingItemTypeSwitch];
    shake.subTitleFontSize = 8;
    //开关事件
    shake.switchBlock = ^(BOOL on) {
        NSLog(@"声音提示%zd",on);
    };
    
    RTSettingGroup *group = [[RTSettingGroup alloc] init];
    group.header = @"基本设置";
    group.items = @[push, shake];
    [_allGroups addObject:group];
}


@end
