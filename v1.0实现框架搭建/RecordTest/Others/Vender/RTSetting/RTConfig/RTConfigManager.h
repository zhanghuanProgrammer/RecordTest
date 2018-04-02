
#import <Foundation/Foundation.h>

@interface RTConfigManager : NSObject

@property (nonatomic,assign)NSInteger autoDeleteDay;//录制截图多少天后自动清除
@property (nonatomic,assign)BOOL isAutoDelete;
@property (nonatomic,assign)CGFloat compressionQuality;//录制过程屏幕截图的压缩率

+ (RTConfigManager *)shareInstance;

@end
