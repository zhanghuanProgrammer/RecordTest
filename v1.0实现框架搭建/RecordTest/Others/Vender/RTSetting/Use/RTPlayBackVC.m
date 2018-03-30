
#import "RTPlayBackVC.h"
#import "RecordTestHeader.h"

@implementation RTPlayBackVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = [self.identify debugDescription];
    [self add0SectionItems];
}

#pragma mark 添加第0组的模型数据
- (void)add0SectionItems
{
    NSMutableArray *items = [NSMutableArray array];
    for (RTOperationQueueModel *model in self.playBackModels) {
        RTSettingItem *item = [RTSettingItem itemWithIcon:@"" title:[model debugDescription] detail:nil type:ZFSettingItemTypeArrow];
        item.operation = ^{
            if (model.imagePath.length > 0) {
                UIImage *image = [RTOperationImage imageWithPlayBackName:model.imagePath];
                UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
                imageView.frame = [UIScreen mainScreen].bounds;
                imageView.backgroundColor = [UIColor redColor];
                [[UIApplication sharedApplication].keyWindow addSubview:imageView];
                [imageView addUITapGestureRecognizerWithTarget:self withAction:@selector(remove:)];
            }
        };
        switch (model.runResult) {
            case RTOperationQueueRunResultTypeNoRun:
                item.titleColor = [UIColor darkGrayColor];
                break;
            case RTOperationQueueRunResultTypeSuccess:
                item.titleColor = [UIColor greenColor];
                break;
            case RTOperationQueueRunResultTypeFailure:
                item.titleColor = [UIColor redColor];
                break;
            default:
                break;
        }
        [items addObject:item];
    }
    
    RTSettingGroup *group = [[RTSettingGroup alloc] init];
    group.header = @"所有执行命令";
    group.items = items;
    [self.allGroups addObject:group];
}

- (void)remove:(UITapGestureRecognizer *)ges{
    [ges.view removeFromSuperview];
}


@end
