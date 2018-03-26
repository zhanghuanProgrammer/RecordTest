#import <UIKit/UIKit.h>
#import "RTOperationQueue.h"

@interface RTCommandListVCCellModel : NSObject

@property (nonatomic,strong)NSIndexPath *indexPath;
@property (nonatomic,strong)RTIdentify *identify;
@property (nonatomic,strong)RTOperationQueueModel *operationModel;

@end
