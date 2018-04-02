
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

@end
