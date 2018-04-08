
#import "RTOperationImage.h"
#import "RecordTestHeader.h"
#import "ZHFileManager.h"

@implementation RTOperationImage

+ (void)load{
    [super load];
    NSString *imagesPath = [[self documentsPath] stringByAppendingPathComponent:@"/rtImages"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:imagesPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:imagesPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *imagesPlaBackPath = [[self documentsPath] stringByAppendingPathComponent:@"/rtPlayBackImagesPath"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:imagesPlaBackPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:imagesPlaBackPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

+ (NSString *)documentsPath{
    NSString *documentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    return documentsPath;
}

+ (NSString *)imagesPath{
    NSString *imagesPath = [[self documentsPath] stringByAppendingPathComponent:@"/rtImages"];
    return imagesPath;
}
+ (NSString *)playBackImagesPath{
    NSString *imagesPath = [[self documentsPath] stringByAppendingPathComponent:@"/rtPlayBackImagesPath"];
    return imagesPath;
}
+ (NSString *)imagesFileSize{
    return [ZHFileManager fileSizeString:[self imagesPath]];
}
+ (NSString *)imagesPlayBackFileSize{
    return [ZHFileManager fileSizeString:[self playBackImagesPath]];
}
+ (NSString *)imagesFileCount{
    NSInteger count = [ZHFileManager subPathFileArrInDirector:[self imagesPath] hasPathExtension:@[@".png",@".jpg"]].count;
    return [NSString stringWithFormat:@"%zd",count];
}
+ (NSString *)imagesPlayBackFileCount{
    NSInteger count = [ZHFileManager subPathFileArrInDirector:[self playBackImagesPath] hasPathExtension:@[@".png",@".jpg"]].count;
    return [NSString stringWithFormat:@"%zd",count];
}

+ (BOOL)isExsitImageName:(NSString *)imageName{
    NSString *path = [[self imagesPath] stringByAppendingPathComponent:imageName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return YES;
    }
    return NO;
}
+ (BOOL)isExsitPlayBackImageName:(NSString *)imageName{
    NSString *path = [[self playBackImagesPath] stringByAppendingPathComponent:imageName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return YES;
    }
    return NO;
}

+ (NSString *)getRandomImageName{
    NSString *imageName = [self getCharacterFileName];
    while ([self isExsitImageName:imageName]) {
        imageName = [self getCharacterFileName];
    }
    return imageName;
}
+ (NSString *)getRandomPlayBackImageName{
    NSString *imageName = [self getCharacterFileName];
    while ([self isExsitPlayBackImageName:imageName]) {
        imageName = [self getCharacterFileName];
    }
    return imageName;
}

+ (NSString *)getCharacterFileName{
    NSInteger len=25;
    unichar ch;
    NSMutableString *fileName=[NSMutableString string];
    for (NSInteger i=0; i<len; i++) {
        ch='A'+arc4random()%26;
        [fileName appendFormat:@"%C",ch];
    }
    return fileName;
}

+ (NSString *)saveOperationImage:(UIImage *)image compressionQuality:(CGFloat)compressionQuality{
    NSData *imageData = UIImageJPEGRepresentation(image,compressionQuality);
    NSString *imageName=[NSString stringWithFormat:@"%@.png",[self getRandomImageName]];
    NSString *savePath = [[self imagesPath] stringByAppendingPathComponent:imageName];
    [imageData writeToFile:savePath atomically:YES];
    NSLog(@"图片大小:%@kb",@(imageData.length/1024.0));
    return imageName;
}

+ (NSString *)saveOperationPlayBackImage:(UIImage *)image compressionQuality:(CGFloat)compressionQuality{
    NSData *imageData = UIImageJPEGRepresentation(image,compressionQuality);
    NSString *imageName=[NSString stringWithFormat:@"%@.png",[self getRandomPlayBackImageName]];
    NSString *savePath = [[self playBackImagesPath] stringByAppendingPathComponent:imageName];
    [imageData writeToFile:savePath atomically:YES];
    NSLog(@"%@",savePath);
    NSLog(@"图片大小:%@kb",@(imageData.length/1024.0));
    return imageName;
}

+ (UIImage *)imageWithName:(NSString *)name{
    NSString *path = [[self imagesPath] stringByAppendingPathComponent:name];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return [UIImage imageWithContentsOfFile:path];
    }
    return [UIImage new];
}

+ (UIImage *)imageWithPlayBackName:(NSString *)name{
    NSString *path = [[self playBackImagesPath] stringByAppendingPathComponent:name];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return [UIImage imageWithContentsOfFile:path];
    }
    return [UIImage new];
}

+ (NSString *)imagePathWithName:(NSString *)name{
    return [[self imagesPath] stringByAppendingPathComponent:name];
}

+ (NSString *)imagePathWithPlayBackName:(NSString *)name{
    return [[self playBackImagesPath] stringByAppendingPathComponent:name];
}

+ (BOOL)isExsitName:(NSString *)name{
    NSString *path = [[self imagesPath] stringByAppendingPathComponent:name];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return YES;
    }
    return NO;
}
+ (BOOL)isExsitPlayBackName:(NSString *)name{
    NSString *path = [[self playBackImagesPath] stringByAppendingPathComponent:name];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return YES;
    }
    return NO;
}
+ (void)deleteOverdueImage{
    NSString *director = [self imagesPath];
    NSArray *subPathFilesArrInDirector = [self subPathFileArrInDirector:director];
    NSMutableArray *allImages = [NSMutableArray array];
    NSArray *operationQueueModels = [RTOperationQueue alloperationQueueModels];
    for (RTOperationQueueModel *model in operationQueueModels) {
        if (model.imagePath.length>0) {
            [allImages addObject:model.imagePath];
        }
    }
    for (NSString *filename in subPathFilesArrInDirector) {
        if (![allImages containsObject:filename]) {
            NSString *deletePath = [director stringByAppendingPathComponent:filename];
            [[NSFileManager defaultManager] removeItemAtPath:deletePath error:nil];
        }
    }
}

+ (void)deleteOverduePlayBackImage{
    NSString *director = [self playBackImagesPath];
    NSArray *subPathFilesArrInDirector = [self subPathFileArrInDirector:director];
    NSMutableArray *allImages = [NSMutableArray array];
    NSArray *allPlayBackModels = [RTPlayBack allPlayBackModels];
    for (RTOperationQueueModel *model in allPlayBackModels) {
        if (model.imagePath.length>0) {
            [allImages addObject:model.imagePath];
        }
    }
    for (NSString *filename in subPathFilesArrInDirector) {
        if (![allImages containsObject:filename]) {
            NSString *deletePath = [director stringByAppendingPathComponent:filename];
            [[NSFileManager defaultManager] removeItemAtPath:deletePath error:nil];
        }
    }
}

+ (NSArray *)subPathFileArrInDirector:(NSString *)DirectorPath{
    if (![[NSFileManager defaultManager]fileExistsAtPath:DirectorPath]) {
        return nil;
    }
    NSArray *arrTemp=[[NSFileManager defaultManager]subpathsAtPath:DirectorPath];
    NSMutableArray *pathFileArr=[NSMutableArray array];
    for (NSString *str in arrTemp) {
        if (str.length>0) {
            [pathFileArr addObject:str];
        }
    }
    if (pathFileArr.count>0) {
        return pathFileArr;
    }
    return nil;
}

@end
