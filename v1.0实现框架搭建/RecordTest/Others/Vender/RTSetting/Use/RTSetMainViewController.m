
#import "RTSetMainViewController.h"
#import "RTSegmentedSlideSwitch.h"
#import "RTSettingViewController.h"
#import "RecordTestHeader.h"
#import "RTAllRecordVC.h"

@interface RTSetMainViewController ()<RTSlideSwitchDelegate>
@property (nonatomic,strong)RTSegmentedSlideSwitch *slideSwitch;
@end

@implementation RTSetMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [TabBarAndNavagation setLeftBarButtonItemTitle:@"<返回" TintColor:[UIColor blackColor] target:self action:@selector(backAction)];
    
    NSMutableArray *viewControllers = [NSMutableArray new];
    NSArray *titles = @[@"运行结果",@"所有录制",@"运行结果",@"设置"];
    
    RTAllRecordVC *allRecord_vc = [RTAllRecordVC new];
    allRecord_vc.title = @"所有录制";
    [viewControllers addObject:allRecord_vc];
    [self addChildViewController:allRecord_vc];
    
    
    RTSettingViewController *set_vc = [RTSettingViewController new];
    set_vc.title = @"设置";
    [viewControllers addObject:set_vc];
    [self addChildViewController:set_vc];
    
    
    
    _slideSwitch = [[RTSegmentedSlideSwitch alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    _slideSwitch.delegate = self;
    _slideSwitch.tintColor = [UIColor darkGrayColor];
    _slideSwitch.viewControllers = viewControllers;
    [_slideSwitch showsInNavBarOf:self];
    [self.view addSubview:_slideSwitch];
}

- (void)backAction{
    [[RTInteraction shareInstance]showAll];
    [self dismissViewControllerAnimated:YES completion:^{}];
}

@end
