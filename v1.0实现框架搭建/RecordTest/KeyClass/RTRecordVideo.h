
#import <Foundation/Foundation.h>
@class RTIdentify;

@interface RTRecordVideo : NSObject

+ (RTRecordVideo *)shareInstance;

- (NSMutableDictionary *)videos;
- (NSMutableDictionary *)videosPlayBacks;

- (void)saveVideoPlayBackForStamp:(NSString *)stamp videoPath:(NSString *)videoPath;
- (void)saveVideoForIdentify:(RTIdentify *)identify videoPath:(NSString *)videoPath;

- (void)deleteVideos:(NSArray *)identifys;
- (void)deletePlayBackVideos:(NSArray *)stamps;

@end
