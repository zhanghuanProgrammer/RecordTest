
#import "RTMoreFuncVC.h"
#import "RecordTestHeader.h"
#import "AutoTestProject.h"
#import "RTUnionListVC.h"
#import "RTTraceListVC.h"
#import "RTPerformanceVC.h"
#import "RTVCPerformanceVC.h"
#import "RTDeviceInfoVC.h"
#import "RTLagVC.h"
#import "RTCrashCollectionVC.h"

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
    
    RTSettingItem *item2 = [RTSettingItem itemWithIcon:@"" title:@"控制器轨迹" subTitle:nil type:ZFSettingItemTypeArrow];
    item2.subTitleFontSize = 10;
    item2.operation = ^{
        [weakSelf.navigationController pushViewController:[RTTraceListVC new] animated:YES];
    };
    
    RTSettingItem *item3 = [RTSettingItem itemWithIcon:@"" title:@"并存控制器" subTitle:nil type:ZFSettingItemTypeArrow];
    item3.subTitleFontSize = 10;
    item3.operation = ^{
        [weakSelf.navigationController pushViewController:[RTUnionListVC new] animated:YES];
    };
    
    RTSettingItem *item4_1 = [RTSettingItem itemWithIcon:@"" title:@"是否显示CPU使用率" subTitle:@"显示在第1个球上方" type:ZFSettingItemTypeSwitch];
    item4_1.on = [RTConfigManager shareInstance].isShowCpu;
    item4_1.subTitleFontSize = 10;
    //开关事件
    item4_1.switchBlock = ^(BOOL on) {
        weakSelf.isShowCpu = on;
    };
    
    RTSettingItem *item4_2 = [RTSettingItem itemWithIcon:@"" title:@"是否显示内存使用" subTitle:@"显示在第2个球上方" type:ZFSettingItemTypeSwitch];
    item4_2.on = [RTConfigManager shareInstance].isShowMemory;
    item4_2.subTitleFontSize = 10;
    //开关事件
    item4_2.switchBlock = ^(BOOL on) {
        weakSelf.isShowMemory = on;
    };
    
    RTSettingItem *item4_3 = [RTSettingItem itemWithIcon:@"" title:@"是否显示网络延迟" subTitle:@"显示在第3个球上方" type:ZFSettingItemTypeSwitch];
    item4_3.on = [RTConfigManager shareInstance].isShowNetDelay;
    item4_3.subTitleFontSize = 10;
    //开关事件
    item4_3.switchBlock = ^(BOOL on) {
        weakSelf.isShowNetDelay = on;
    };
    
    RTSettingItem *item4_4 = [RTSettingItem itemWithIcon:@"" title:@"是否显示网络延迟" subTitle:@"显示在第4个球上方" type:ZFSettingItemTypeSwitch];
    item4_4.on = [RTConfigManager shareInstance].isShowFPS;
    item4_4.subTitleFontSize = 10;
    //开关事件
    item4_4.switchBlock = ^(BOOL on) {
        weakSelf.isShowFPS = on;
    };
    
    RTSettingItem *item5 = [RTSettingItem itemWithIcon:@"" title:@"性能数据收集展示" subTitle:nil type:ZFSettingItemTypeArrow];
    item5.subTitleFontSize = 10;
    item5.operation = ^{
        [weakSelf.navigationController pushViewController:[RTPerformanceVC new] animated:YES];
    };
    
    RTSettingItem *item6 = [RTSettingItem itemWithIcon:@"" title:@"页面性能分析" subTitle:nil type:ZFSettingItemTypeArrow];
    item6.subTitleFontSize = 10;
    item6.operation = ^{
        [weakSelf.navigationController pushViewController:[RTVCPerformanceVC new] animated:YES];
    };
    
    RTSettingItem *item6_1 = [RTSettingItem itemWithIcon:@"" title:@"卡顿分析" subTitle:nil type:ZFSettingItemTypeArrow];
    item6_1.subTitleFontSize = 10;
    item6_1.operation = ^{
        [weakSelf.navigationController pushViewController:[RTLagVC new] animated:YES];
    };
    
    RTSettingItem *item6_2 = [RTSettingItem itemWithIcon:@"" title:@"崩溃收集" subTitle:nil type:ZFSettingItemTypeArrow];
    item6_2.subTitleFontSize = 10;
    item6_2.operation = ^{
        [weakSelf.navigationController pushViewController:[RTCrashCollectionVC new] animated:YES];
    };
    
    RTSettingItem *item7 = [RTSettingItem itemWithIcon:@"" title:@"手机设备信息" subTitle:nil type:ZFSettingItemTypeArrow];
    item7.subTitleFontSize = 10;
    item7.operation = ^{
        [weakSelf.navigationController pushViewController:[RTDeviceInfoVC new] animated:YES];
    };
    
    RTSettingGroup *group1 = [[RTSettingGroup alloc] init];
    group1.header = @"更多功能";
    group1.items = @[item1,item2,item3,item4_1,item4_2,item4_3,item4_4,item5,item6,item6_1,item6_2,item7];
    [self.allGroups addObject:group1];
}

- (void)setIsShowCpu:(BOOL)isShowCpu{
    [RTConfigManager shareInstance].isShowCpu = isShowCpu;
    [[SuspendBall shareInstance] setBadge:@"" index:0];
}

- (void)setIsShowMemory:(BOOL)isShowMemory{
    [RTConfigManager shareInstance].isShowMemory = isShowMemory;
    [[SuspendBall shareInstance] setBadge:@"" index:1];
}

- (void)setIsShowNetDelay:(BOOL)isShowNetDelay{
    [RTConfigManager shareInstance].isShowNetDelay = isShowNetDelay;
    [[SuspendBall shareInstance] setBadge:@"" index:2];
}

- (void)setIsShowFPS:(BOOL)isShowFPS{
    [RTConfigManager shareInstance].isShowFPS = isShowFPS;
    [[SuspendBall shareInstance] setBadge:@"" index:3];
}

@end
