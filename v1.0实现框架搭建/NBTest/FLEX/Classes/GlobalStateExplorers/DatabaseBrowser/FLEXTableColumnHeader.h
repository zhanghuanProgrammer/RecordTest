
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, FLEXTableColumnHeaderSortType) {
    FLEXTableColumnHeaderSortTypeNone = 0,
    FLEXTableColumnHeaderSortTypeAsc,
    FLEXTableColumnHeaderSortTypeDesc,
};

@interface FLEXTableColumnHeader : UIView

@property (nonatomic, strong) UILabel *label;

- (void)changeSortStatusWithType:(FLEXTableColumnHeaderSortType)type;

@end

