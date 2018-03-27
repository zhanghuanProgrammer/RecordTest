
#import <UIKit/UIKit.h>
@class RTOperationQueueModel;

@interface UIView (KVO)

- (void)kvo;
- (BOOL)runOperation:(RTOperationQueueModel *)model;

@end
