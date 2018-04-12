
#import "RTPlayBackVC.h"
#import "RecordTestHeader.h"
#import "RTPhotosViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface RTPlayBackVC ()
@property (nonatomic,strong)MPMoviePlayerViewController *moviePlayerController;
@end

@implementation RTPlayBackVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = [self.identify debugDescription];
    [self add0SectionItems];
    
    self.videoPath = [[RTRecordVideo shareInstance] videosPlayBacks][self.stamp];
    if (self.videoPath.length>0 && [[NSFileManager defaultManager] fileExistsAtPath:[RTOperationImage videoPlayBackPathWithName:self.videoPath]]) {
        [TabBarAndNavagation setRightBarButtonItemTitle:@"视频" TintColor:[UIColor redColor] target:self action:@selector(video)];
    }
}

- (void)video{
    NSURL *URL = [[NSURL alloc] initFileURLWithPath:[RTOperationImage videoPlayBackPathWithName:self.videoPath]];
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
    NSMutableArray *items = [NSMutableArray array];
    for (RTOperationQueueModel *model in self.playBackModels) {
        RTSettingItem *item = [RTSettingItem itemWithIcon:@"" title:[model debugDescription] detail:nil type:ZFSettingItemTypeArrow];
        item.operation = ^{
            if (model.imagePath.length > 0) {
                [self goToPhotoBrowser:model.imagePath];
            }
        };
        switch (model.runResult) {
            case RTOperationQueueRunResultTypeNoRun:
                item.titleColor = [UIColor darkGrayColor];
                break;
            case RTOperationQueueRunResultTypeSuccess:
                item.titleColor = [UIColor greenColor];
                break;
            case RTOperationQueueRunResultTypeFailure:
                item.titleColor = [UIColor redColor];
                break;
            default:
                break;
        }
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
    for (RTOperationQueueModel *model in self.playBackModels){
        if (model.imagePath.length > 0){
            [imagePaths addObject:[RTOperationImage imagePathWithPlayBackName:model.imagePath]];
        }
    }
    RTPhotosViewController *vc=[RTPhotosViewController new];
    vc.imageNames = imagePaths;
    vc.indexCur = [imagePaths indexOfObject:[RTOperationImage imagePathWithPlayBackName:imagePath]];
    vc.bgColor=[UIColor whiteColor];
    vc.isShowPageIndex = YES;
    [vc showToVC:self];
}

- (void)remove:(UITapGestureRecognizer *)ges{
    [ges.view removeFromSuperview];
}


@end
