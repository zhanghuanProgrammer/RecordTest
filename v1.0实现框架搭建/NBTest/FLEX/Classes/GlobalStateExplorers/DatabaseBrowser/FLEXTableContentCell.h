
#import <UIKit/UIKit.h>

@class FLEXTableContentCell;
@protocol FLEXTableContentCellDelegate <NSObject>

@optional
- (void)tableContentCell:(FLEXTableContentCell *)tableView labelDidTapWithText:(NSString *)text;

@end

@interface FLEXTableContentCell : UITableViewCell

@property (nonatomic, strong)NSArray *labels;

@property (nonatomic, weak) id<FLEXTableContentCellDelegate>delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView columnNumber:(NSInteger)number;

@end
