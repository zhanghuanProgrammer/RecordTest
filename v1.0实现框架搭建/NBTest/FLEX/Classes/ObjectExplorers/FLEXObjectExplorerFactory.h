
#import <Foundation/Foundation.h>

@class FLEXObjectExplorerViewController;

@interface FLEXObjectExplorerFactory : NSObject

+ (FLEXObjectExplorerViewController *)explorerViewControllerForObject:(id)object;

@end
