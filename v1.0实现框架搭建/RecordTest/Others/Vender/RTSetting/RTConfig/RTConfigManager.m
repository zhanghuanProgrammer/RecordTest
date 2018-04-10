
#import "RTConfigManager.h"
#import "ZHSaveDataToFMDB.h"

@implementation RTConfigManager

+ (RTConfigManager *)shareInstance{
    static dispatch_once_t pred = 0;
    __strong static RTConfigManager *_sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[RTConfigManager alloc] init];
        
        NSString *autoDeleteDay = [ZHSaveDataToFMDB selectDataWithIdentity:@"RTAutoDeleteDay"];
        if(autoDeleteDay.length > 0) _sharedObject.autoDeleteDay = [autoDeleteDay integerValue];
        else _sharedObject.autoDeleteDay = -1;
        
        NSString *compressionQuality = [ZHSaveDataToFMDB selectDataWithIdentity:@"RTCompressionQuality"];
        if(compressionQuality.length > 0) _sharedObject.compressionQuality = [compressionQuality floatValue];
        else _sharedObject.compressionQuality = -1;
        
        NSString *isAutoDelete = [ZHSaveDataToFMDB selectDataWithIdentity:@"RTIsAutoDelete"];
        if(isAutoDelete.length > 0) _sharedObject.isAutoDelete = [isAutoDelete boolValue];
        else _sharedObject.isAutoDelete = NO;
        
        NSString *isRecoderVideo = [ZHSaveDataToFMDB selectDataWithIdentity:@"RTIsRecoderVideo"];
        if(isRecoderVideo.length > 0) _sharedObject.isRecoderVideo = [isRecoderVideo boolValue];
        else _sharedObject.isRecoderVideo = NO;
        
        NSString *isRecoderVideoPlayBack = [ZHSaveDataToFMDB selectDataWithIdentity:@"RTIsRecoderVideoPlayBack"];
        if(isRecoderVideoPlayBack.length > 0) _sharedObject.isRecoderVideoPlayBack = [isRecoderVideoPlayBack boolValue];
        else _sharedObject.isRecoderVideoPlayBack = NO;
        
        NSString *compressionQualityRecoderVideo = [ZHSaveDataToFMDB selectDataWithIdentity:@"RTCompressionQualityRecoderVideo"];
        if(compressionQualityRecoderVideo.length > 0) _sharedObject.compressionQualityRecoderVideo = [compressionQualityRecoderVideo integerValue];
        else _sharedObject.compressionQualityRecoderVideo = -1;
        
        NSString *compressionQualityRecoderVideoPlayBack = [ZHSaveDataToFMDB selectDataWithIdentity:@"RTCompressionQualityRecoderVideoPlayBack"];
        if(compressionQualityRecoderVideoPlayBack.length > 0) _sharedObject.compressionQualityRecoderVideoPlayBack = [compressionQualityRecoderVideoPlayBack integerValue];
        else _sharedObject.compressionQualityRecoderVideoPlayBack = -1;
    });
    return _sharedObject;
}

- (void)setAutoDeleteDay:(NSInteger)autoDeleteDay{
    _autoDeleteDay = autoDeleteDay;
    [ZHSaveDataToFMDB insertDataWithData:[NSString stringWithFormat:@"%zd",autoDeleteDay] WithIdentity:@"RTAutoDeleteDay"];
}

- (void)setCompressionQuality:(CGFloat)compressionQuality{
    _compressionQuality = compressionQuality;
    [ZHSaveDataToFMDB insertDataWithData:[NSString stringWithFormat:@"%0.2f",compressionQuality] WithIdentity:@"RTCompressionQuality"];
}

- (void)setIsAutoDelete:(BOOL)isAutoDelete{
    _isAutoDelete = isAutoDelete;
    [ZHSaveDataToFMDB insertDataWithData:[NSString stringWithFormat:@"%d",isAutoDelete] WithIdentity:@"RTIsAutoDelete"];
}

- (void)setIsRecoderVideo:(BOOL)isRecoderVideo{
    _isRecoderVideo = isRecoderVideo;
    [ZHSaveDataToFMDB insertDataWithData:[NSString stringWithFormat:@"%d",isRecoderVideo] WithIdentity:@"RTIsRecoderVideo"];
}

- (void)setIsRecoderVideoPlayBack:(BOOL)isRecoderVideoPlayBack{
    _isRecoderVideoPlayBack = isRecoderVideoPlayBack;
    [ZHSaveDataToFMDB insertDataWithData:[NSString stringWithFormat:@"%d",isRecoderVideoPlayBack] WithIdentity:@"RTIsRecoderVideoPlayBack"];
}

- (void)setCompressionQualityRecoderVideo:(NSInteger)compressionQualityRecoderVideo{
    _compressionQualityRecoderVideo = compressionQualityRecoderVideo;
    [ZHSaveDataToFMDB insertDataWithData:[NSString stringWithFormat:@"%zd",compressionQualityRecoderVideo] WithIdentity:@"RTCompressionQualityRecoderVideo"];
}

- (void)setCompressionQualityRecoderVideoPlayBack:(NSInteger)compressionQualityRecoderVideoPlayBack{
    _compressionQualityRecoderVideoPlayBack = compressionQualityRecoderVideoPlayBack;
    [ZHSaveDataToFMDB insertDataWithData:[NSString stringWithFormat:@"%zd",compressionQualityRecoderVideoPlayBack] WithIdentity:@"RTCompressionQualityRecoderVideoPlayBack"];
}

@end
