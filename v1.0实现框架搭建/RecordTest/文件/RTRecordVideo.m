
#import "RTRecordVideo.h"
#import "RecordTestHeader.h"

@implementation RTRecordVideo

+ (RTRecordVideo *)shareInstance{
    static dispatch_once_t pred = 0;
    __strong static RTRecordVideo *_sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[RTRecordVideo alloc] init];
    });
    return _sharedObject;
}
- (NSMutableDictionary *)videos{
    NSMutableDictionary *videos = [ZHSaveDataToFMDB selectDataWithIdentity:@"RTVideo"];
    if (!videos) {
        videos = [NSMutableDictionary dictionary];
    }
    return videos;
}
+ (void)addVideosFromOtherDataBase:(NSString *)dataBase{
    NSDictionary *videosOther = [RTOpenDataBase selectDataWithIdentity:@"RTVideo" dataBasePath:dataBase];
    if (videosOther.count>0) {
        NSMutableDictionary *videos = [[RTRecordVideo shareInstance] videos];
        [videos setValuesForKeysWithDictionary:videosOther];
        [ZHSaveDataToFMDB insertDataWithData:videos WithIdentity:@"RTVideo"];
    }
}
- (NSMutableDictionary *)videosPlayBacks{
    NSMutableDictionary *videosPlayBacks = [ZHSaveDataToFMDB selectDataWithIdentity:@"RTVideoPlayBack"];
    if (!videosPlayBacks) {
        videosPlayBacks = [NSMutableDictionary dictionary];
    }
    return videosPlayBacks;
}
+ (void)addVideosPlayBacksFromOtherDataBase:(NSString *)dataBase{
    NSDictionary *videosPlayBacksOther = [RTOpenDataBase selectDataWithIdentity:@"RTVideoPlayBack" dataBasePath:dataBase];
    if (videosPlayBacksOther.count>0) {
        NSMutableDictionary *videosPlayBacks = [[RTRecordVideo shareInstance] videosPlayBacks];
        [videosPlayBacks setValuesForKeysWithDictionary:videosPlayBacksOther];
        [ZHSaveDataToFMDB insertDataWithData:videosPlayBacks WithIdentity:@"RTVideoPlayBack"];
    }
}
- (void)saveVideoPlayBackForStamp:(NSString *)stamp videoPath:(NSString *)videoPath{
    if (stamp > 0 && videoPath.length > 0) {
        NSMutableDictionary *playBacks = [self videosPlayBacks];
        [playBacks setValue:[RTOperationImage savePlayBackVideo:videoPath] forKey:stamp];
        [ZHSaveDataToFMDB insertDataWithData:playBacks WithIdentity:@"RTVideoPlayBack"];
    }
}
- (void)saveVideoForIdentify:(RTIdentify *)identify videoPath:(NSString *)videoPath{
    if ([identify description] > 0 && videoPath.length > 0) {
        NSMutableDictionary *videos = [self videos];
        [videos setValue:[RTOperationImage saveVideo:videoPath] forKey:[identify description]];
        [ZHSaveDataToFMDB insertDataWithData:videos WithIdentity:@"RTVideo"];
    }
}

- (void)deleteVideos:(NSArray *)identifys{
    NSMutableDictionary *videos = [self videos];
    for (RTIdentify *identify in identifys) {
        if (videos[[identify description]]) {
            [videos removeObjectForKey:[identify description]];
        }
    }
    [ZHSaveDataToFMDB insertDataWithData:videos WithIdentity:@"RTVideo"];
    [RTOperationImage deleteOverdueVideo];
}

- (void)deletePlayBackVideos:(NSArray *)stamps{
    NSMutableDictionary *videosPlayBacks = [self videos];
    for (NSString *stamp in stamps) {
        if (videosPlayBacks[stamp]) {
            [videosPlayBacks removeObjectForKey:stamp];
        }
    }
    [ZHSaveDataToFMDB insertDataWithData:videosPlayBacks WithIdentity:@"RTVideoPlayBack"];
    [RTOperationImage deleteOverduePlayBackVideo];
}

@end
