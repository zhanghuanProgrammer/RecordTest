
#import "RTCrashLagIndexVC.h"
#import "RTSegmentedSlideSwitch.h"
#import "RecordTestHeader.h"
#import "RTTextPreVC.h"
#import "RTCrashLag.h"
#import "RTImagePreVC.h"
#import "RTOperationImage.h"

@interface RTCrashLagIndexVC ()<RTSlideSwitchDelegate>
@property (nonatomic,strong)RTSegmentedSlideSwitch *slideSwitch;
@end

@implementation RTCrashLagIndexVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [TabBarAndNavagation setRightBarButtonItemTitle:@"删除" TintColor:[UIColor redColor] target:self action:@selector(deleteAction)];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadVC];
}

- (void)deleteAction{
    if (self.isCrash) {
        [[RTCrashLag shareInstance] removeCrash:self.stamp];
        [RTOperationImage removeCrash:self.imageName];
    }else{
        [[RTCrashLag shareInstance] removeLag:self.stamp];
        [RTOperationImage removeLag:self.imageName];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadVC{
    NSMutableArray *viewControllers = [NSMutableArray new];
    
    RTTextPreVC *statck_vc = [RTTextPreVC new];
    statck_vc.isCrash = self.isCrash;
    statck_vc.text = self.text;
    statck_vc.stamp = self.stamp;
    statck_vc.title = @"堆栈";
    [viewControllers addObject:statck_vc];
    [self addChildViewController:statck_vc];
    
    RTImagePreVC *image_vc = [RTImagePreVC new];
    if (self.isCrash) {
        image_vc.image = [RTOperationImage imageWithCrash:self.imageName];
    }else{
        image_vc.image = [RTOperationImage imageWithLag:self.imageName];
    }
    image_vc.title = @"截图";
    [viewControllers addObject:image_vc];
    [self addChildViewController:image_vc];
    
    _slideSwitch = [[RTSegmentedSlideSwitch alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64)];
    _slideSwitch.backgroundColor = [UIColor whiteColor];
    _slideSwitch.delegate = self;
    _slideSwitch.tintColor = [UIColor darkGrayColor];
    _slideSwitch.viewControllers = viewControllers;
    [_slideSwitch showsInNavBarOf:self];
    [self.view addSubview:_slideSwitch];
}

@end
