#import "RTCommandListVCViewController.h"
#import "RTCommandListVCTableViewCell.h"
#import "RTCommandList.h"

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

@end
