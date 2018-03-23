
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, RTOperationQueueType) {
    RTOperationQueueTypeEvent,
    RTOperationQueueTypeScroll,
    RTOperationQueueTypeTableViewCellTap,
};

@interface RTOperationQueueModel : NSObject <NSCoding>

@property (nonatomic,copy)NSString *viewId;
@property (nonatomic,copy)NSString *view;
@property (nonatomic,assign)RTOperationQueueType type;
@property (nonatomic,strong)NSArray *parameters;

@end

@interface RTOperationQueue : NSObject

@property (nonatomic,strong)RTOperationQueueModel *curOperationModel;

+ (RTOperationQueue *)shareInstance;
+ (void)addOperation:(UIView *)view type:(RTOperationQueueType)type parameters:(NSArray *)parameters repeat:(BOOL)repeat;

+ (void)saveOperationQueue;
+ (void)runOperationQueue;

@end
