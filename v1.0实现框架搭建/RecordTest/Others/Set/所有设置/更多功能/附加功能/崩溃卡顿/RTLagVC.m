
#import "RTLagVC.h"
#import "RecordTestHeader.h"
#import "RTCrashLag.h"
#import "RTCrashLagIndexVC.h"

@implementation RTLagVC

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"卡顿分析";
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self add0SectionItems];
}

#pragma mark 添加第0组的模型数据
- (void)add0SectionItems{
    [self.allGroups removeAllObjects];
    NSDictionary *lags = [[RTCrashLag shareInstance] lags];
    __weak typeof(self)weakSelf=self;
    NSMutableArray *items = [NSMutableArray array];
    for (NSString *stamp in lags) {
        NSString *title = stamp;
        RTLagModel *model = lags[stamp];
        if (model.lagStack.length<=0) {
            [[RTCrashLag shareInstance] removeLag:stamp];
            continue;
        }
        RTSettingItem *item1 = [RTSettingItem itemWithIcon:@"" title:title detail:nil type:ZFSettingItemTypeArrow];
        item1.detailFontSize = 10;
        item1.operation = ^{
            [weakSelf openTextVC:stamp];
        };
        [items addObject:item1];
    }
    [items sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        RTSettingItem *item1 = obj1;
        RTSettingItem *item2 = obj2;
        return [item2.title compare:item1.title];
    }];
    RTSettingGroup *group1 = [[RTSettingGroup alloc] init];
    group1.header = @"卡顿(按时间降序)";
    group1.items = items;
    [self.allGroups addObject:group1];
    [self.tableView reloadData];
}

- (void)openTextVC:(NSString *)stamp{
    NSDictionary *lags = [[RTCrashLag shareInstance] lags];
    RTCrashLagIndexVC *detailVC = [RTCrashLagIndexVC new];
    RTLagModel *model = lags[stamp];
    detailVC.text = model.lagStack;
    detailVC.stamp = stamp;
    detailVC.imageName = model.imagePath;
    if (detailVC.text.length>0) {
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

@end
