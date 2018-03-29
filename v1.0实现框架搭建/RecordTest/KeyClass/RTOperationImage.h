
#import <Foundation/Foundation.h>
@class RTIdentify;

@interface RTOperationImage : NSObject

+ (RTOperationImage *)shareInstance;

+ (void)addOperationImage:(UIImage *)image;

+ (BOOL)saveOperationQueue:(RTIdentify *)identify;
+ (NSMutableArray *)getOperationQueue:(RTIdentify *)identify;
+ (void)deleteOperationQueue:(RTIdentify *)identify;
+ (void)deleteOperationQueues:(NSArray *)identifys;
+ (void)deleteOperationQueueModelIndexs:(NSArray *)indexs forIdentify:(RTIdentify *)identify;
+ (BOOL)reChanggeOperationQueue:(RTIdentify *)identify;
+ (BOOL)isExsitOperationQueue:(RTIdentify *)identify;

+ (NSArray *)allIdentifyModels;
+ (NSArray *)allIdentifyModelsForVC:(NSString *)vc;

@end
