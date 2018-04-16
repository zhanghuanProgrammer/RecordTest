
#import <Foundation/Foundation.h>

@interface RTConfigManager : NSObject

@property (nonatomic,assign)NSInteger autoDeleteDay;//录制截图多少天后自动清除
@property (nonatomic,assign)BOOL isAutoDelete;
@property (nonatomic,assign)CGFloat compressionQuality;//录制过程屏幕截图的压缩率
@property (nonatomic,assign)BOOL isRecoderVideo; //是否录制视频
@property (nonatomic,assign)BOOL isRecoderVideoPlayBack; //是否录制运行回放视频
@property (nonatomic,assign)NSInteger compressionQualityRecoderVideo;//录制视频的清晰程度
@property (nonatomic,assign)NSInteger compressionQualityRecoderVideoPlayBack;//录制运行回放视频的清晰程度
@property (nonatomic,assign)BOOL isMigrationImage; //是否共享录制截屏
@property (nonatomic,assign)BOOL isMigrationVideo; //是否共享回放视频

+ (RTConfigManager *)shareInstance;

@end
