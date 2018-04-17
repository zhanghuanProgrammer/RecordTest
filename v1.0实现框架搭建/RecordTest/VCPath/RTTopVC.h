
#import <Foundation/Foundation.h>

@interface RTTopVC : NSObject

+ (RTTopVC *)shareInstance;
- (void)updateTopVC:(BOOL)isNewVC;
- (void)hookTopVC;
- (void)removeNotShowInWindow:(NSMutableArray *)vcStack;

@property (nonatomic,copy)NSString *topVC;

@end
