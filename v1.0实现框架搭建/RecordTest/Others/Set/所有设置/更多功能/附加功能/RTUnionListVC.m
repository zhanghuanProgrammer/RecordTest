
#import "RTUnionListVC.h"
#import "RecordTestHeader.h"

@implementation RTUnionListVC

- (void)viewDidLoad{
    [super viewDidLoad];
    [self add0SectionItems];
    self.title = @"并存控制器";
}

#pragma mark 添加第0组的模型数据
- (void)add0SectionItems{
    
    NSArray *traceVC = [[RTVCLearn shareInstance] unionVC];
    
    for (NSArray *subArr in traceVC) {
        
        NSMutableArray *items = [NSMutableArray array];
        for (NSString *vc in subArr) {
            if ([RTVCLearn filter:vc]) {
                continue;
            }
            NSString *title = [NSString stringWithFormat:@"%@",vc];
            RTSettingItem *item1 = [RTSettingItem itemWithIcon:@"" title:title subTitle:nil type:ZFSettingItemTypeNone];
            item1.subTitleFontSize = 10;
            [items addObject:item1];
        }
        if(items.count<=0)continue;
        
        RTSettingGroup *group1 = [[RTSettingGroup alloc] init];
        group1.header = @"并存控制器";
        group1.items = items;
        [self.allGroups addObject:group1];
    }
    
}

@end
