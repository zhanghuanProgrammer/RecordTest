
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
    NSMutableDictionary *stampDic = [NSMutableDictionary dictionary];
    for (NSString *stamp in playBacks) {
        NSString *compareTime = [self compareCurrentTime:stamp];
        NSMutableArray *playBackModels = stampDic[compareTime];
        if(!playBackModels) playBackModels = [NSMutableArray array];
        [playBackModels addObject:playBacks[stamp]];
        stampDic[compareTime] = playBackModels;
    }
    
    for (NSString *compareTime in stampDic) {
        NSArray *sections = stampDic[compareTime];
        NSMutableArray *items = [NSMutableArray array];
        for (NSDictionary *value in sections) {
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
        }
        RTSettingGroup *group = [[RTSettingGroup alloc] init];
        group.header = compareTime;
        group.items = items;
        [self.allGroups addObject:group];
    }
}

- (NSString *)compareCurrentTime:(NSString *)stamp{
    NSTimeInterval timeInterval = [DateTools getCurInterval] - [stamp longLongValue];
    long temp = 0;
    NSString *result;
    if (timeInterval/60 <= 10){
        result = [NSString stringWithFormat:@"刚刚 (10分钟内)"];
    }else if(timeInterval/60 <= 30){
        result = [NSString stringWithFormat:@"30分钟内"];
    }else if((temp = timeInterval/60) <=60){
        result = [NSString stringWithFormat:@"1小时内"];
    }else if((temp = temp/60) <= 6){
        result = [NSString stringWithFormat:@"6小时内"];
    }else if(temp <= 12){
        result = [NSString stringWithFormat:@"12小时内"];
    }else if(temp <= 24){
        result = [NSString stringWithFormat:@"1天内"];
    }else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
    }else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    return  result;
}

@end
