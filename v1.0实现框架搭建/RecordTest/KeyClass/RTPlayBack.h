
#import <Foundation/Foundation.h>
@class RTIdentify;

@interface RTPlayBack : NSObject

@property (nonatomic,assign)long long stamp;
@property (nonatomic,strong)RTIdentify *identify;

+ (RTPlayBack *)shareInstance;
- (NSMutableDictionary *)playBacks;
- (void)savePlayBack:(NSArray *)playBackModels;

@end
