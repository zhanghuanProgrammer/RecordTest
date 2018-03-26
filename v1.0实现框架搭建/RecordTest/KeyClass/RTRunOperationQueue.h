
#import <Foundation/Foundation.h>

@interface RTRunOperationQueue : NSObject

@property (nonatomic,strong)NSMutableArray *operationQueue;
@property (nonatomic,copy)NSString *forVC;
@property (nonatomic,assign)NSInteger curRow;

- (void)nextStep;
- (void)nextSteps;

@end
