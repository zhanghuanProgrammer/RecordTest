
#import "RTPlaybackViewController.h"
#import "RecordTestHeader.h"
#import "RTPlayBackVC.h"

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
    NSDictionary *playBacks = [[RTPlayBack shareInstance] playBacks];
    for (NSString *stamp in playBacks) {
        NSDictionary *value = playBacks[stamp];
        NSMutableArray *items = [NSMutableArray array];
        if (value.count>0) {
            NSString *identifyString = [value allKeys][0];
            RTIdentify *identify = [[RTIdentify alloc]initWithIdentify:identifyString];
            NSArray *playBackModels = value[identifyString];
            RTSettingItem *item = [RTSettingItem itemWithIcon:@"" title:[identify debugDescription] detail:nil type:ZFSettingItemTypeArrow];
            item.operation = ^{
                RTPlayBackVC *playBackVC = [RTPlayBackVC new];
                playBackVC.identify = identify;
                playBackVC.playBackModels = playBackModels;
                [self.navigationController pushViewController:playBackVC animated:YES];
            };
            BOOL isRunSuccess = YES;
            for (RTOperationQueueModel *model in playBackModels){
                if(model.runResult != RTOperationQueueRunResultTypeSuccess){isRunSuccess = NO; break;}
            }
            if (isRunSuccess) {
                item.titleColor = [UIColor greenColor];
            }else{
                item.titleColor = [UIColor redColor];
            }
            [items addObject:item];
        }
        RTSettingGroup *group = [[RTSettingGroup alloc] init];
        group.header = stamp;
        group.items = items;
        [self.allGroups addObject:group];
    }
}

@end
