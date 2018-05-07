
#import <Foundation/Foundation.h>

@protocol FLEXFileBrowserSearchOperationDelegate;

@interface FLEXFileBrowserSearchOperation : NSOperation

@property (nonatomic, weak) id<FLEXFileBrowserSearchOperationDelegate> delegate;

- (id)initWithPath:(NSString *)currentPath searchString:(NSString *)searchString;

@end

@protocol FLEXFileBrowserSearchOperationDelegate <NSObject>

- (void)fileBrowserSearchOperationResult:(NSArray *)searchResult size:(uint64_t)size;

@end
