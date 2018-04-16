
#import <Foundation/Foundation.h>

@interface RTTopVC : NSObject

+ (RTTopVC *)shareInstance;
- (void)updateTopVC;
- (void)hookTopVC;
- (void)removeNotShowInWindow:(NSMutableArray *)vcStack;

@property (nonatomic,copy)NSString *topVC;

@end
