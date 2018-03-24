
#import "AutoRecordTest.h"
#import "RecordTestHeader.h"
#import "RTCommandList.h"

@implementation AutoRecordTest

+ (AutoRecordTest *)shareInstance{
    static dispatch_once_t pred = 0;
    __strong static AutoRecordTest *_sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[AutoRecordTest alloc] init];
        _sharedObject.isRuning=NO;
        if (Run) {
            [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
            SuspendBall *suspendBall = [SuspendBall suspendBallWithFrame:CGRectMake(0, 64, 50, 50) delegate:_sharedObject subBallImageArray:@[@"SuspendBall_down",@"SuspendBall_downmore",@"SuspendBall_list",@"SuspendBall_reback",@"SuspendBall_set"]];
            [[UIApplication sharedApplication].keyWindow addSubview:suspendBall];
            RTCommandList *list = [[RTCommandList alloc]initInKeyWindowWithFrame:CGRectMake(0, suspendBall.maxY, 200, 12*10)];
            list.draggable = NO;
            for (NSInteger i=0; i<20; i++) {
                [list.dataArr addObject:@"RTCommandList 1"];
                [list.dataArr addObject:@"RTCommandList 2"];
                [list.dataArr addObject:@"RTCommandList 3"];
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                list.curRow = 5;
            });
        }
    });
    return _sharedObject;
}

- (void)autoRecord{
    if (!Run) {
        return;
    }
    self.isRuning=YES;
    [[KVOAllView new] kvoAllView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self autoRecord];
        [RTOperationQueue runOperationQueue];
    });
}

#pragma mark - SuspendBallDelegte
- (void)suspendBall:(UIButton *)subBall didSelectTag:(NSInteger)tag{
    switch (tag) {
        case 0:break;
        case 1:break;
        case 2:{
            [RTCommandList shareInstance].hidden = ![RTCommandList shareInstance].hidden;
        }break;
        case 3:break;
        case 4:break;
        default:
            break;
    }
}

@end
