
#import <Foundation/Foundation.h>

@interface RTTopVC : NSObject

+ (RTTopVC *)shareInstance;
- (void)hookTopVC;

@property (nonatomic,copy)NSString *topVC;

@end
