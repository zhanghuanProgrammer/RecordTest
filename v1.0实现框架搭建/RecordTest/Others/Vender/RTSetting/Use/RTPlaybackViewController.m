
#import "RTPlaybackViewController.h"
#import "RecordTestHeader.h"

@interface RTPlaybackViewController ()

@end

@implementation RTPlaybackViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self add0SectionItems];
}

#pragma mark 添加第0组的模型数据
- (void)add0SectionItems
{
    
    NSArray *identifys = [RTOperationQueue allIdentifyModels];
    NSMutableArray *forVCs = [NSMutableArray array];
    for (RTIdentify *identify in identifys) {
        if (![forVCs containsObject:identify.forVC]) {
            [forVCs addObject:identify.forVC];
        }
    }
    
    for (NSString *vc in forVCs) {
        NSMutableArray *items = [NSMutableArray array];
        for (RTIdentify *identify in identifys) {
            if ([vc isEqualToString:identify.forVC]) {
                RTSettingItem *item = [RTSettingItem itemWithIcon:@"" title:identify.identify detail:identify.forVC type:ZFSettingItemTypeArrow];
                RTIdentify *copNew = [identify copyNew];
                item.operation = ^{
//                    RTOperationsVC *operationsVC = [RTOperationsVC new];
//                    operationsVC.identify = copNew;
//                    [self.navigationController pushViewController:operationsVC animated:YES];
                };
                [items addObject:item];
            }
        }
        
        RTSettingGroup *group = [[RTSettingGroup alloc] init];
        group.header = vc;
        group.items = items;
        [_allGroups addObject:group];
    }
}

@end
