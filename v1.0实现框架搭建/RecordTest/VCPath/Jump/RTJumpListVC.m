
#import "RTJumpListVC.h"
#import "RecordTestHeader.h"
#import "AutoTestProject.h"
#import "RTVertex.h"
#import "RTSearchVCPath.h"
#import "NSArray+ZH.h"
#import "RTAutoJump.h"

@implementation RTJumpListVC

- (void)viewDidLoad{
    [super viewDidLoad];
    // 1.第0组：3个
    [self add0SectionItems];
}

#pragma mark 添加第0组的模型数据
- (void)add0SectionItems{
    
    NSArray *allCanGotoVcs = [[RTSearchVCPath shareInstance] allCanGotoVcs];
    __weak typeof(self)weakSelf=self;
    NSMutableArray *items = [NSMutableArray array];
    for (NSString *vcIdentity in allCanGotoVcs) {
        NSString *vc = [[RTVCLearn shareInstance] getVcWithIdentity:vcIdentity];
        if ([self filter:vc] || [[RTTopVC shareInstance] isContainVC:vc]) {
            continue;
        }
        RTSettingItem *item1 = [RTSettingItem itemWithIcon:@"" title:vc subTitle:nil type:ZFSettingItemTypeArrow];
        item1.subTitleFontSize = 10;
        __weak typeof(item1)weakitem1=item1;
        item1.operation = ^{
            NSString *targetVC = weakitem1.title;
            [[RTInteraction shareInstance] showAll];
            [weakSelf dismissViewControllerAnimated:NO completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[RTAutoJump shareInstance] gotoVC:targetVC];
                });
            }];
        };
        [items addObject:item1];
    }
    
    RTSettingGroup *group1 = [[RTSettingGroup alloc] init];
    group1.header = @"更多功能";
    group1.items = items;
    [self.allGroups addObject:group1];
}

- (BOOL)filter:(NSString *)vc{
    return [@[
             @"RTAllRecordVC",@"RTPlaybackViewController",@"RTPlayBackVC",
             @"RTCommandListVCViewController",@"RTJumpListVC",@"RTJumpVC",
             @"RTMoreFuncVC",@"RTSetFileSizeViewController",@"RTSetMainViewController",
             @"RTSettingViewController",@"JDStatusBarNotificationViewController"
             ]
            containsObject:vc];
}

@end
