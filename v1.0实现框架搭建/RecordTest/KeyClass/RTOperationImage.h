
#import <Foundation/Foundation.h>

@interface RTOperationImage : NSObject

+ (NSString *)saveOperationImage:(UIImage *)image compressionQuality:(CGFloat)compressionQuality;
+ (NSString *)saveOperationPlayBackImage:(UIImage *)image compressionQuality:(CGFloat)compressionQuality;
+ (UIImage *)imageWithName:(NSString *)name;
+ (UIImage *)imageWithPlayBackName:(NSString *)name;
+ (BOOL)isExsitName:(NSString *)name;
+ (void)deleteOverdueImage;
+ (void)deleteOverduePlayBackImage;

@end
