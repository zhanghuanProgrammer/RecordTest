
#import "RTPlayBack.h"
#import "RecordTestHeader.h"

@implementation RTPlayBack

+ (RTPlayBack *)shareInstance{
    static dispatch_once_t pred = 0;
    __strong static RTPlayBack *_sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[RTPlayBack alloc] init];
    });
    return _sharedObject;
}

- (NSMutableDictionary *)playBacks{
    NSMutableDictionary *playBacks = [ZHSaveDataToFMDB selectDataWithIdentity:@"RTPlayBack"];
    if (!playBacks) {
        playBacks = [NSMutableDictionary dictionary];
    }
    return playBacks;
}

- (void)savePlayBack:(NSArray *)playBackModels{
    if (self.stamp > 0 && playBackModels.count > 0 && self.identify) {
        NSMutableDictionary *playBacks = [self playBacks];
        [playBacks setValue:@{[self.identify description]:playBackModels} forKey:[NSString stringWithFormat:@"%lld",self.stamp]];
        [ZHSaveDataToFMDB insertDataWithData:playBacks WithIdentity:@"RTPlayBack"];
    }
}

- (void)deletePlayBacks:(NSArray *)stamps{
    if (stamps.count>0) {
        NSMutableDictionary *playBacks = [self playBacks];
        for (NSString *stamp in stamps) {
            if (stamp.length>0) {
                [playBacks removeObjectForKey:stamp];
            }
        }
        [ZHSaveDataToFMDB insertDataWithData:playBacks WithIdentity:@"RTPlayBack"];
        [RTOperationImage deleteOverduePlayBackImage];
        [[RTRecordVideo shareInstance]deletePlayBackVideos:stamps];
    }
}

+ (NSArray *)allPlayBackModels{
    NSMutableArray *allPlayBackModels = [NSMutableArray array];
    NSMutableDictionary *playBacks = [[RTPlayBack shareInstance] playBacks];
    NSArray *values = [playBacks allValues];
    for (NSDictionary *value in values) {
        if (value.count>0) {
            NSArray *models = [value allValues][0];
            if ([models isKindOfClass:[NSArray class]] && models.count>0) {
                [allPlayBackModels addObjectsFromArray:models];
            }
        }
    }
    return allPlayBackModels;
}

@end
