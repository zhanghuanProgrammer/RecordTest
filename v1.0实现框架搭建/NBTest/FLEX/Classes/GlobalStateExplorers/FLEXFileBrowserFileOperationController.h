
#import <Foundation/Foundation.h>

@protocol FLEXFileBrowserFileOperationController;

@protocol FLEXFileBrowserFileOperationControllerDelegate <NSObject>

- (void)fileOperationControllerDidDismiss:(id<FLEXFileBrowserFileOperationController>)controller;

@end

@protocol FLEXFileBrowserFileOperationController <NSObject>

@property (nonatomic, weak) id<FLEXFileBrowserFileOperationControllerDelegate> delegate;

- (instancetype)initWithPath:(NSString *)path;

- (void)show;

@end

@interface FLEXFileBrowserFileDeleteOperationController : NSObject <FLEXFileBrowserFileOperationController>
@end

@interface FLEXFileBrowserFileRenameOperationController : NSObject <FLEXFileBrowserFileOperationController>
@end
