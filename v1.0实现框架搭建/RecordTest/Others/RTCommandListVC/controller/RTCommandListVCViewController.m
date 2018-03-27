#import "RTCommandListVCViewController.h"
#import "RTCommandListVCTableViewCell.h"
#import "RTCommandList.h"
#import "ZHAlertAction.h"
#import "RecordTestHeader.h"

@interface RTCommandListVCViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation RTCommandListVCViewController

- (NSMutableArray *)dataArr{
	if (!_dataArr) {
		_dataArr = [NSMutableArray array];
	}
	return _dataArr;
}

- (void)viewDidLoad{
	[super viewDidLoad];
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
    [self.tableView registerClass:[RTCommandListVCTableViewCell class] forCellReuseIdentifier:@"RTCommandListVCTableViewCell"];
    [self.view addSubview:self.tableView];
	self.tableView.delegate=self;
	self.tableView.dataSource=self;
	self.tableView.tableFooterView=[UIView new];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    
    [TabBarAndNavagation setLeftBarButtonItemTitle:@"<返回" TintColor:[UIColor blackColor] target:self action:@selector(backAction)];
    if (self.dataArr.count>0) {
        RTCommandListVCCellModel *model = [self.dataArr firstObject];
        if (model.operationModel) {
            [TabBarAndNavagation setRightBarButtonItemTitle:@"停止" TintColor:[UIColor redColor] target:self action:@selector(stopAction)];
        }
    }
    self.navigationController.navigationBar.translucent = NO;
}

- (void)backAction{
    [self.nav.view removeFromSuperview];
    [self.nav removeFromParentViewController];
    [[RTDisPlayAllView new]disPlayAllView];
}

- (void)stopAction{
    [RTCommandList shareInstance].isRunOperationQueue = NO;
    [[RTCommandList shareInstance] initData];
    [self backAction];
}

#pragma mark - TableViewDelegate实现的方法:
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	id modelObjct=self.dataArr[indexPath.row];
	if ([modelObjct isKindOfClass:[RTCommandListVCCellModel class]]){
		RTCommandListVCTableViewCell *rTCommandListVCCell=[tableView dequeueReusableCellWithIdentifier:@"RTCommandListVCTableViewCell"];
		RTCommandListVCCellModel *model=modelObjct;
		[rTCommandListVCCell refreshUI:model];
		return rTCommandListVCCell;
	}
	//随便给一个cell
	UITableViewCell *cell=[UITableViewCell new];
	return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	id modelObjct=self.dataArr[indexPath.row];
	if ([modelObjct isKindOfClass:[RTCommandListVCCellModel class]]){
		return 44.0f;
	}
	return 44.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    RTCommandListVCCellModel *model=self.dataArr[indexPath.row];
    if (model.operationModel) {
        [RTCommandList shareInstance].curRow = indexPath.row;
    }else if (model.identify) {
        [[RTCommandList shareInstance]setOperationQueue:model.identify];
    }
    [self backAction];
}
///**是否可以编辑*/
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
//    return YES;
//}
///**编辑风格*/
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
//    return UITableViewCellEditingStyleDelete;
//}
///**设置编辑的控件  删除*/
//- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
//    //设置删除按钮
//    UITableViewRowAction *deleteRowAction=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//
//        [self.dataArr removeObjectAtIndex:indexPath.row];
//        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationAutomatic)];
//
////
////        NSString *title = @"";
////        if ([RTCommandList shareInstance].isRunOperationQueue) title = @"是否删除该单条目录?";
////        else title = @"是否删除该测试录制?";
////        NSLog(@"%@",[[UIApplication sharedApplication] keyWindow].rootViewController);
////        [ZHAlertAction alertWithTitle:title withMsg:nil addToViewController:[[UIApplication sharedApplication] keyWindow].rootViewController ActionSheet:NO otherButtonBlocks:@[^{
////        },^{
////
////        }] otherButtonTitles:@[@"删除",@"取消"]];
//
//    }];
//    return @[deleteRowAction];
//}

/**是否可以编辑*/
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if (indexPath.row==self.dataArr.count) {
        return NO;
    }
    return YES;
}

/**编辑风格*/
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

/**设置编辑的控件  删除,置顶,收藏*/
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //设置删除按钮
    UITableViewRowAction *deleteRowAction=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self.dataArr removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationAutomatic)];
    }];
    return  @[deleteRowAction];
}

@end
