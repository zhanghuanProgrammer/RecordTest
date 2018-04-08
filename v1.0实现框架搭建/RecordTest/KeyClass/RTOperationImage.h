
#import <Foundation/Foundation.h>

@interface RTOperationImage : NSObject

+ (NSString *)imagesFileSize;
+ (NSString *)imagesPlayBackFileSize;
+ (NSString *)imagesFileCount;
+ (NSString *)imagesPlayBackFileCount;
+ (NSString *)saveOperationImage:(UIImage *)image;
+ (NSString *)saveOperationPlayBackImage:(UIImage *)image;
+ (UIImage *)imageWithName:(NSString *)name;
+ (UIImage *)imageWithPlayBackName:(NSString *)name;
+ (NSString *)imagePathWithName:(NSString *)name;
+ (NSString *)imagePathWithPlayBackName:(NSString *)name;
+ (BOOL)isExsitName:(NSString *)name;
+ (void)deleteOverdueImage;
+ (void)deleteOverduePlayBackImage;

@end
