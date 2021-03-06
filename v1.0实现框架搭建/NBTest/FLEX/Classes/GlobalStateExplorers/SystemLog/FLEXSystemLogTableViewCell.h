
#import <UIKit/UIKit.h>

@class FLEXSystemLogMessage;

extern NSString *const kFLEXSystemLogTableViewCellIdentifier;

@interface FLEXSystemLogTableViewCell : UITableViewCell

@property (nonatomic, strong) FLEXSystemLogMessage *logMessage;
@property (nonatomic, copy) NSString *highlightedText;

+ (NSString *)displayedTextForLogMessage:(FLEXSystemLogMessage *)logMessage;
+ (CGFloat)preferredHeightForLogMessage:(FLEXSystemLogMessage *)logMessage inWidth:(CGFloat)width;

@end
