
#import <UIKit/UIKit.h>

@class FLEXToolbarItem;

@interface FLEXExplorerToolbar : UIView

@property (nonatomic, strong, readonly) FLEXToolbarItem *selectItem;
@property (nonatomic, strong, readonly) FLEXToolbarItem *hierarchyItem;
@property (nonatomic, strong, readonly) FLEXToolbarItem *moveItem;
@property (nonatomic, strong, readonly) FLEXToolbarItem *globalsItem;
@property (nonatomic, strong, readonly) FLEXToolbarItem *closeItem;
@property (nonatomic, strong, readonly) UIView *dragHandle;
@property (nonatomic, strong) UIColor *selectedViewOverlayColor;
@property (nonatomic, copy) NSString *selectedViewDescription;
@property (nonatomic, strong, readonly) UIView *selectedViewDescriptionContainer;

@end
