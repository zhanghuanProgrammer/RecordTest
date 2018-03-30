
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

@end
