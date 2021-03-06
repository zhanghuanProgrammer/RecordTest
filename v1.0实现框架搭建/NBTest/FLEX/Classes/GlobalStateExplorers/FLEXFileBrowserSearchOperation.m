
#import "FLEXFileBrowserSearchOperation.h"

@implementation NSMutableArray (FLEXStack)

- (void)flex_push:(id)anObject
{
    [self addObject:anObject];
}

- (id)flex_pop
{
    id anObject = [self lastObject];
    [self removeLastObject];
    return anObject;
}

@end

@interface FLEXFileBrowserSearchOperation ()

@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) NSString *searchString;

@end

@implementation FLEXFileBrowserSearchOperation

#pragma mark - private

- (uint64_t)totalSizeAtPath:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *attributes = [fileManager attributesOfItemAtPath:path error:NULL];
    uint64_t totalSize = [attributes fileSize];
    
    for (NSString *fileName in [fileManager enumeratorAtPath:path]) {
        attributes = [fileManager attributesOfItemAtPath:[path stringByAppendingPathComponent:fileName] error:NULL];
        totalSize += [attributes fileSize];
    }
    return totalSize;
}

#pragma mark - instance method

- (id)initWithPath:(NSString *)currentPath searchString:(NSString *)searchString
{
    self = [super init];
    if (self) {
        self.path = currentPath;
        self.searchString = searchString;
    }
    return self;
}

#pragma mark - methods to override

- (void)main
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableArray *searchPaths = [NSMutableArray array];
    NSMutableDictionary *sizeMapping = [NSMutableDictionary dictionary];
    uint64_t totalSize = 0;
    NSMutableArray *stack = [NSMutableArray array];
    [stack flex_push:self.path];
    
    while ([stack count]) {
        NSString *currentPath = [stack flex_pop];
        NSArray *directoryPath = [fileManager contentsOfDirectoryAtPath:currentPath error:nil];
        
        for (NSString *subPath in directoryPath) {
            NSString *fullPath = [currentPath stringByAppendingPathComponent:subPath];
            
            if ([[subPath lowercaseString] rangeOfString:[self.searchString lowercaseString]].location != NSNotFound) {
                [searchPaths addObject:fullPath];
                if (!sizeMapping[fullPath]) {
                    uint64_t fullPathSize = [self totalSizeAtPath:fullPath];
                    totalSize += fullPathSize;
                    [sizeMapping setObject:@(fullPathSize) forKey:fullPath];
                }
            }
            BOOL isDirectory;
            if ([fileManager fileExistsAtPath:fullPath isDirectory:&isDirectory] && isDirectory) {
                [stack flex_push:fullPath];
            }
            
            if ([self isCancelled]) {
                return;
            }
        }
    }
    
    NSArray *sortedArray = [searchPaths sortedArrayUsingComparator:^NSComparisonResult(NSString *path1, NSString *path2) {
        uint64_t pathSize1 = [sizeMapping[path1] unsignedLongLongValue];
        uint64_t pathSize2 = [sizeMapping[path2] unsignedLongLongValue];
        if (pathSize1 < pathSize2) {
            return NSOrderedAscending;
        } else if (pathSize1 > pathSize2) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }];
    
    if ([self isCancelled]) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate fileBrowserSearchOperationResult:sortedArray size:totalSize];
    });
}

@end
