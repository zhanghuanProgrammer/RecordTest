
#import "RTSettingViewController.h"
#import "RecordTestHeader.h"

@interface RTSettingViewController ()
@end

@implementation RTSettingViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"设置";
    [TabBarAndNavagation setLeftBarButtonItemTitle:@"<返回" TintColor:[UIColor blackColor] target:self action:@selector(backAction)];
    
    // 1.第0组：3个
    [self add0SectionItems];
    
    // 2.第1组：6个
    [self add1SectionItems];
}

- (void)backAction{
    [[RTInteraction shareInstance]showAll];
    [self dismissViewControllerAnimated:YES completion:^{}];
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

#pragma mark 添加第1组的模型数据
- (void)add1SectionItems
{
    __weak typeof(self) weakSelf = self;
    // 帮助
    RTSettingItem *help = [RTSettingItem itemWithIcon:@"MoreHelp" title:@"帮助" type:ZFSettingItemTypeArrow];
    help.operation = ^{
        UIViewController *helpVC = [[UIViewController alloc] init];
        helpVC.view.backgroundColor = [UIColor grayColor];
        helpVC.title = @"帮助";
        [weakSelf.navigationController pushViewController:helpVC animated:YES];
    };
    
    // 分享
    RTSettingItem *share = [RTSettingItem itemWithIcon:@"MoreShare" title:@"分享" type:ZFSettingItemTypeArrow];
    share.operation = ^{
        UIViewController *helpVC = [[UIViewController alloc] init];
        helpVC.view.backgroundColor = [UIColor lightGrayColor];
        helpVC.title = @"分享";
        [weakSelf.navigationController pushViewController:helpVC animated:YES];
    };
    
    // 关于
    RTSettingItem *about = [RTSettingItem itemWithIcon:@"MoreAbout" title:@"关于" type:ZFSettingItemTypeArrow];
    about.operation = ^{
        
    };
    
    RTSettingGroup *group = [[RTSettingGroup alloc] init];
    group.header = @"高级设置";
    group.footer = @"这是footer";
    group.items = @[ help, share , about];
    [_allGroups addObject:group];
}

@end
