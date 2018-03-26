
#import "RTInteraction.h"
#import "RecordTestHeader.h"
#import "RTCommandList.h"
#import "ZHAlertAction.h"

@interface RTInteraction ()<SuspendBallDelegte>

@end

@implementation RTInteraction

+ (RTInteraction *)shareInstance{
    static dispatch_once_t pred = 0;
    __strong static RTInteraction *_sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[RTInteraction alloc] init];
    });
    return _sharedObject;
}

- (void)startInteraction{
    SuspendBall *suspendBall = [SuspendBall suspendBallWithFrame:CGRectMake(0, 64, 50, 50) delegate:self subBallImageArray:@[@"SuspendBall_down",@"SuspendBall_downmore",@"SuspendBall_list",@"SuspendBall_startrecord",@"SuspendBall_set"]];
    [[UIApplication sharedApplication].keyWindow addSubview:suspendBall];
    RTCommandList *list = [[RTCommandList alloc]initInKeyWindowWithFrame:CGRectMake(0, suspendBall.maxY, 200, 12*10)];
    list.curCommand.text = @"与该控制器相关的可执行测试列表:";
    list.draggable = NO;
    NSArray *arr = [RTOperationQueue allIdentifyModels];
    for (RTIdentify *identify in arr) {
        [list.dataArr addObject:[identify debugDescription]];
    }
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        list.curRow = 5;
//    });
}

#pragma mark - SuspendBallDelegte
- (void)suspendBall:(UIButton *)subBall didSelectTag:(NSInteger)tag{
    switch (tag) {
        case 0:[JohnAlertManager showAlertWithType:JohnTopAlertTypeSuccess title:@"导出成功!"];break;
        case 1:break;
        case 2:{
            [RTCommandList shareInstance].hidden = ![RTCommandList shareInstance].hidden;
        }break;
        case 3:{
            [RTOperationQueue startOrStopRecord];//开始录制 结束录制
        }break;
        case 4:{
        }break;
        default:
            break;
    }
}

@end
