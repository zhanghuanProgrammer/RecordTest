
#import <UIKit/UIKit.h>
@class RTOperationQueueModel;

@interface UIView (KVO)

- (void)kvo;
- (void)runOperation:(RTOperationQueueModel *)model;

@end
