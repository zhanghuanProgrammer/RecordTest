
#import "RTInteraction.h"
#import "RecordTestHeader.h"
#import "RTCommandList.h"
#import "ZHAlertAction.h"
#import "RTCommandListVCViewController.h"

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
    suspendBall.isNoNeedKVO = YES;
    RTCommandList *list = [[RTCommandList alloc]initInKeyWindowWithFrame:CGRectMake(0, suspendBall.maxY, 200, 12*10)];
    list.isRunOperationQueue = NO;
    list.isNoNeedKVO = YES;
    [list initData];
    __weak typeof(list)weakList=list;
    list.tapBlock = ^(RTCommandList *view) {
        RTCommandListVCViewController *vc = [RTCommandListVCViewController new];
        vc.title = weakList.curCommand.text;
        [vc.dataArr addObjectsFromArray:weakList.dataArr];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        vc.nav = nav;
        [[UIApplication sharedApplication].keyWindow addSubview:nav.view];
        [[UIViewController getCurrentVC] addChildViewController:nav];
    };
}

#pragma mark - SuspendBallDelegte
- (void)suspendBall:(UIButton *)subBall didSelectTag:(NSInteger)tag{
    switch (tag) {
        case 0:{
            if ([RTCommandList shareInstance].isRunOperationQueue) {
                [[RTCommandList shareInstance] runStep];
            }else{
                [ZHStatusBarNotification showWithStatus:@"没有正在执行的操作队列" dismissAfter:1 styleName:JDStatusBarStyleError];
            }
        }break;
        case 1:{
            if ([RTCommandList shareInstance].isRunOperationQueue) {
                [[RTCommandList shareInstance] nextStep];
            }else{
                [ZHStatusBarNotification showWithStatus:@"没有正在执行的操作队列" dismissAfter:1 styleName:JDStatusBarStyleError];
            }
        }break;
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
