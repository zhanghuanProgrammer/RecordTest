
#import "RTOperationsVC.h"
#import "RecordTestHeader.h"
#import "RTPhotosViewController.h"

@interface RTOperationsVC ()
@property (nonatomic,strong)NSArray *operationQueueModels;
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
    self.operationQueueModels = operationQueueModels;
    NSMutableArray *items = [NSMutableArray array];
    for (RTOperationQueueModel *model in operationQueueModels) {
        RTSettingItem *item = [RTSettingItem itemWithIcon:@"" title:[model debugDescription] detail:nil type:ZFSettingItemTypeArrow];
        item.operation = ^{
            [self goToPhotoBrowser:model.imagePath];
        };
        [items addObject:item];
    }
    
    RTSettingGroup *group = [[RTSettingGroup alloc] init];
    group.header = @"所有执行命令";
    group.items = items;
    [self.allGroups addObject:group];
}

- (void)goToPhotoBrowser:(NSString *)imagePath{
    NSMutableArray *imagePaths = [NSMutableArray array];
    for (RTOperationQueueModel *model in self.operationQueueModels){
        if (model.imagePath.length > 0){
            [imagePaths addObject:[RTOperationImage imagePathWithName:model.imagePath]];
        }
    }
    RTPhotosViewController *vc=[RTPhotosViewController new];
    vc.imageNames = imagePaths;
    vc.indexCur = [imagePaths indexOfObject:[RTOperationImage imagePathWithName:imagePath]];
    vc.bgColor=[UIColor whiteColor];
    vc.isShowPageIndex = YES;
    [vc showToVC:self];
}

@end
