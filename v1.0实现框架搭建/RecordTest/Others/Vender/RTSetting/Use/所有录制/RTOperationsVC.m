
#import "RTOperationsVC.h"
#import "RecordTestHeader.h"
#import "RTPhotosViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface RTOperationsVC ()
@property (nonatomic,strong)NSArray *operationQueueModels;
@property (nonatomic,copy)NSString *videoPath;
@property (nonatomic,strong)MPMoviePlayerViewController *moviePlayerController;
@end

@implementation RTOperationsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = [self.identify debugDescription];
    [self add0SectionItems];
    
    self.videoPath = [[RTRecordVideo shareInstance] videos][[self.identify description]];
    if (self.videoPath.length>0) {
        [TabBarAndNavagation setRightBarButtonItemTitle:@"视频" TintColor:[UIColor redColor] target:self action:@selector(video)];
    }
}

- (void)video{
    NSURL *URL = [[NSURL alloc] initFileURLWithPath:[RTOperationImage videoPathWithName:self.videoPath]];
    _moviePlayerController = [[MPMoviePlayerViewController alloc] initWithContentURL:URL];
    [self presentMoviePlayerViewControllerAnimated:_moviePlayerController];
    _moviePlayerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [_moviePlayerController.moviePlayer setFullscreen:YES animated:YES];
    [_moviePlayerController.moviePlayer setControlStyle:MPMovieControlStyleEmbedded];
    _moviePlayerController.moviePlayer.movieSourceType=MPMovieSourceTypeFile;
    [_moviePlayerController.moviePlayer prepareToPlay];
}

#pragma mark 添加第0组的模型数据
- (void)add0SectionItems
{
    NSArray *operationQueueModels = [RTOperationQueue getOperationQueue:self.identify];
    self.operationQueueModels = operationQueueModels;
    NSMutableArray *items = [NSMutableArray array];
    for (RTOperationQueueModel *model in operationQueueModels) {
        RTSettingItem *item = [RTSettingItem itemWithIcon:@"" title:[model debugDescription] detail:nil type:ZFSettingItemTypeArrow];
        item.operation = ^{
            [self goToPhotoBrowser:model.imagePath];
        };
        [items addObject:item];
    }
    
    RTSettingGroup *group = [[RTSettingGroup alloc] init];
    group.header = @"所有执行命令";
    group.items = items;
    [self.allGroups addObject:group];
}

- (void)goToPhotoBrowser:(NSString *)imagePath{
    if (!imagePath || imagePath.length<=0) {
        [JohnAlertManager showAlertWithType:JohnTopAlertTypeError title:@"没有对应的截图!"];
        return;
    }
    NSMutableArray *imagePaths = [NSMutableArray array];
    for (RTOperationQueueModel *model in self.operationQueueModels){
        if (model.imagePath.length > 0){
            [imagePaths addObject:[RTOperationImage imagePathWithName:model.imagePath]];
        }
    }
    RTPhotosViewController *vc=[RTPhotosViewController new];
    vc.imageNames = imagePaths;
    vc.indexCur = [imagePaths indexOfObject:[RTOperationImage imagePathWithName:imagePath]];
    vc.bgColor=[UIColor whiteColor];
    vc.isShowPageIndex = YES;
    [vc showToVC:self];
}

@end
