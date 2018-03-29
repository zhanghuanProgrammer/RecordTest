
#import "RTSetMainViewController.h"
#import "RTSlideSwitch.h"
#import "RTSettingViewController.h"

@interface RTSetMainViewController ()<RTSlideSwitchDelegate>
@property (nonatomic,strong)RTSlideSwitch *slideSwitch;
@end

@implementation RTSetMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *viewControllers = [NSMutableArray new];
    NSArray *titles = @[@"即时比分",@"竞彩比分"];
    for (int i = 0 ; i<titles.count; i++) {
        RTSettingViewController *vc = [RTSettingViewController new];
        vc.title = titles[i];
        [viewControllers addObject:vc];
        [self addChildViewController:vc];
    }
    
    _slideSwitch = [[RTSlideSwitch alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    _slideSwitch.isUnderArrow = YES;
    _slideSwitch.delegate = self;
    _slideSwitch.btnSelectedColor = [UIColor whiteColor];
    _slideSwitch.btnNormalColor = [UIColor getColor:@"#eeeeee"];
    _slideSwitch.viewControllers = viewControllers;
    //设置适配屏幕宽度属性为真
    _slideSwitch.adjustBtnSize2Screen = true;
    //显示在viewcontroller的navigationBar上
    [_slideSwitch showsInNavBarOf:self];
    //设置隐藏阴影
    _slideSwitch.hideShadow = true;
    [self.view addSubview:_slideSwitch];
}

@end
