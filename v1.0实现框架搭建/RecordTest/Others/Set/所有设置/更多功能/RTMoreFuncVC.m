
#import "RTMoreFuncVC.h"
#import "RecordTestHeader.h"
#import "AutoTestProject.h"

@implementation RTMoreFuncVC

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
    RTSettingItem *item1 = [RTSettingItem itemWithIcon:@"" title:@"开始自动(Monkey)测试" subTitle:nil type:ZFSettingItemTypeArrow];
    item1.subTitleFontSize = 10;
    item1.operation = ^{
        [[RTInteraction shareInstance] hideAll];
        [JohnAlertManager showAlertWithType:JohnTopAlertTypeError title:@"开始Monkey测试!"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[AutoTestProject shareInstance] autoTest];
            [weakSelf dismissViewControllerAnimated:NO completion:nil];
        });
    };
    RTSettingGroup *group1 = [[RTSettingGroup alloc] init];
    group1.header = @"更多功能";
    group1.items = @[item1];
    [self.allGroups addObject:group1];
}

@end
