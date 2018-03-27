
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, RTOperationQueueType) {
    RTOperationQueueTypeEvent,
    RTOperationQueueTypeTap,
    RTOperationQueueTypeScroll,
    RTOperationQueueTypeTableViewCellTap,
    RTOperationQueueTypeTextChange,
};

@interface RTOperationQueueModel : NSObject <NSCoding>

@property (nonatomic,copy)NSString *viewId;
@property (nonatomic,copy)NSString *view;
@property (nonatomic,copy)NSString *vc;
@property (nonatomic,assign)RTOperationQueueType type;
@property (nonatomic,strong)NSArray *parameters;

- (instancetype)copyNew;

@end

@interface RTIdentify : NSObject

@property (nonatomic,copy)NSString *identify;
@property (nonatomic,copy)NSString *forVC;

- (instancetype)initWithIdentify:(NSString *)identify forVC:(NSString *)forVC;

@end

@interface RTOperationQueue : NSObject

@property (nonatomic,copy)NSString *forVC;
@property (nonatomic,assign)BOOL isRecord;
@property (nonatomic,assign)BOOL isStopRecordTemp;

+ (RTOperationQueue *)shareInstance;
+ (void)startOrStopRecord;
+ (void)addOperation:(UIView *)view type:(RTOperationQueueType)type parameters:(NSArray *)parameters repeat:(BOOL)repeat;

+ (BOOL)saveOperationQueue:(RTIdentify *)identify;
+ (NSMutableArray *)getOperationQueue:(RTIdentify *)identify;
+ (void)deleteOperationQueue:(RTIdentify *)identify;
+ (BOOL)reChanggeOperationQueue:(RTIdentify *)identify;
+ (BOOL)isExsitOperationQueue:(RTIdentify *)identify;

+ (NSArray *)allIdentifyModels;
+ (NSArray *)allIdentifyModelsForVC:(NSString *)vc;

@end
