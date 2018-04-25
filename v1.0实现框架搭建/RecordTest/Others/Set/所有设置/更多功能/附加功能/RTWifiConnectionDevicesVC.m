
#import "RTWifiConnectionDevicesVC.h"
#import "RecordTestHeader.h"
#import "MainPresenter.h"
#import "Device.h"

@interface RTWifiConnectionDevicesVC () <MainPresenterDelegate>
@property (strong, nonatomic) MainPresenter *presenter;
@property (strong, nonatomic) UIProgressView *progressView;
@property (strong, nonatomic) NSLayoutConstraint *tableVTopContraint;
@end

@implementation RTWifiConnectionDevicesVC

- (void)viewDidLoad{
    [super viewDidLoad];
    [self add0SectionItems];
    self.title = @"点击查看连接人数";
    [TabBarAndNavagation setRightBarButtonItemTitle:@"刷新" TintColor:[UIColor redColor] target:self action:@selector(refreshInfo)];
    
    self.presenter = [[MainPresenter alloc]initWithDelegate:self];
    [self scanButtonClicked];
    [self addObserversForKVO];
    
    _progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 64, CurrentScreen_Width, 20)];
    _progressView.progressTintColor = [UIColor redColor];
    _progressView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:_progressView];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.title =[self.presenter ssidName];
}

- (void)refreshInfo{
    [self scanButtonClicked];
}

#pragma mark - KVO Observers
-(void)addObserversForKVO {
    [self.presenter addObserver:self forKeyPath:@"connectedDevices" options:NSKeyValueObservingOptionNew context:nil];
    [self.presenter addObserver:self forKeyPath:@"progressValue" options:NSKeyValueObservingOptionNew context:nil];
    [self.presenter addObserver:self forKeyPath:@"isScanRunning" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)scanButtonClicked {
    [self showProgressBar];
    self.title = [self.presenter ssidName];
    [self.presenter scanButtonClicked];
}

#pragma mark - Show/Hide progress
-(void)showProgressBar {
    [self.progressView setProgress:0.0];
    [UIView animateWithDuration:0.5 animations:^{
        self.tableVTopContraint.constant=40;
        [self.view layoutIfNeeded];
    }];
}
-(void)hideProgressBar {
    [UIView animateWithDuration:0.5 animations:^{
        self.tableVTopContraint.constant=0;
        [self.view layoutIfNeeded];
    }];
}
#pragma mark - Presenter Delegates
-(void)mainPresenterIPSearchFinished {
    [[[UIAlertView alloc] initWithTitle:@"扫描结束" message:[NSString stringWithFormat:@"共有: %lu个设备连接此WIFI", (unsigned long)self.presenter.connectedDevices.count] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    [self hideProgressBar];
};

-(void)mainPresenterIPSearchFailed {
    [[[UIAlertView alloc] initWithTitle:@"扫描失败" message:[NSString stringWithFormat:@"请确保在扫描前连接WiFi"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
};

-(void)mainPresenterIPSearchCancelled {
    [self add0SectionItems];
};

#pragma mark - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.presenter){
        if ([keyPath isEqualToString:@"connectedDevices"]) {
            [self add0SectionItems];
        }
        else if ([keyPath isEqualToString:@"progressValue"]) {
            
            [self.progressView setProgress:self.presenter.progressValue];
        }
        else if ([keyPath isEqualToString:@"isScanRunning"]) {
            
        }
    }
}

#pragma mark - Dealloc

-(void)dealloc {
    [self removeObserversForKVO];
}

-(void)removeObserversForKVO {
    [self.presenter removeObserver:self forKeyPath:@"connectedDevices"];
    [self.presenter removeObserver:self forKeyPath:@"progressValue"];
    [self.presenter removeObserver:self forKeyPath:@"isScanRunning"];
}

#pragma mark 添加第0组的模型数据
- (void)add0SectionItems{
    [self.allGroups removeAllObjects];
    
    NSMutableArray *items = [NSMutableArray array];
    
    for (NSInteger i=0; i<self.presenter.connectedDevices.count; i++) {
        Device *nd = [self.presenter.connectedDevices objectAtIndex:i];
        NSString *title = [NSString stringWithFormat:@"%@ - %@ - %@",nd.ipAddress,nd.macAddress,nd.brand];
        RTSettingItem *item1 = [RTSettingItem itemWithIcon:@"" title:title detail:nil type:ZFSettingItemTypeNone];
        [items addObject:item1];
    }

    RTSettingGroup *group1 = [[RTSettingGroup alloc] init];
    group1.items = items;
    group1.header = @"";
    [self.allGroups addObject:group1];
    [self.tableView reloadData];
}

@end
