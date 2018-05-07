
#import <UIKit/UIKit.h>

extern NSString *const kFLEXMultilineTableViewCellIdentifier;

@interface FLEXMultilineTableViewCell : UITableViewCell

+ (CGFloat)preferredHeightWithAttributedText:(NSAttributedString *)attributedText inTableViewWidth:(CGFloat)tableViewWidth style:(UITableViewStyle)style showsAccessory:(BOOL)showsAccessory;

@end
