
#import "RTOperationsVC.h"
#import "RecordTestHeader.h"

@interface RTOperationsVC ()

@end

@implementation RTOperationsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = [self.identify debugDescription];
    [self add0SectionItems];
}

#pragma mark 添加第0组的模型数据
- (void)add0SectionItems
{
    NSArray *operationQueueModels = [RTOperationQueue getOperationQueue:self.identify];
    NSMutableArray *operations = [NSMutableArray array];
    for (RTOperationQueueModel *model in operationQueueModels) {
        [operations addObject:model.debugDescription];
    }
    NSMutableArray *items = [NSMutableArray array];
    for (NSString *operation in operations) {
        RTSettingItem *item = [RTSettingItem itemWithIcon:@"" title:operation detail:nil type:ZFSettingItemTypeArrow];
        item.operation = ^{
            
        };
        [items addObject:item];
    }
    
    RTSettingGroup *group = [[RTSettingGroup alloc] init];
    group.header = @"所有执行命令";
    group.items = items;
    [_allGroups addObject:group];
}

@end
