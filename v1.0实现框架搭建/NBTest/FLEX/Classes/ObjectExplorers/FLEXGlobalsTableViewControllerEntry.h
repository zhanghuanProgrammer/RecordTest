
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NSString *(^FLEXGlobalsTableViewControllerEntryNameFuture)(void);
typedef UIViewController *(^FLEXGlobalsTableViewControllerViewControllerFuture)(void);

@interface FLEXGlobalsTableViewControllerEntry : NSObject

@property (nonatomic, readonly, copy) FLEXGlobalsTableViewControllerEntryNameFuture entryNameFuture;
@property (nonatomic, readonly, copy) FLEXGlobalsTableViewControllerViewControllerFuture viewControllerFuture;

+ (instancetype)entryWithNameFuture:(FLEXGlobalsTableViewControllerEntryNameFuture)nameFuture viewControllerFuture:(FLEXGlobalsTableViewControllerViewControllerFuture)viewControllerFuture;

@end
