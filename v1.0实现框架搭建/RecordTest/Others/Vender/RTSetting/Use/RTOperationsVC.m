
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
    NSMutableArray *items = [NSMutableArray array];
    for (RTOperationQueueModel *model in operationQueueModels) {
        RTSettingItem *item = [RTSettingItem itemWithIcon:@"" title:[model debugDescription] detail:nil type:ZFSettingItemTypeArrow];
        item.operation = ^{
            UIImage *image = [RTOperationImage imageWithName:model.imagePath];
            UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
            imageView.frame = [UIScreen mainScreen].bounds;
            imageView.backgroundColor = [UIColor redColor];
            [[UIApplication sharedApplication].keyWindow addSubview:imageView];
            [imageView addUITapGestureRecognizerWithTarget:self withAction:@selector(remove:)];
        };
        [items addObject:item];
    }
    
    RTSettingGroup *group = [[RTSettingGroup alloc] init];
    group.header = @"所有执行命令";
    group.items = items;
    [_allGroups addObject:group];
}

- (void)remove:(UITapGestureRecognizer *)ges{
    [ges.view removeFromSuperview];
}

@end
