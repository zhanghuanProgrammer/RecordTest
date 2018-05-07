
#import <UIKit/UIKit.h>

extern NSString *const kFLEXNetworkTransactionCellIdentifier;

@class FLEXNetworkTransaction;

@interface FLEXNetworkTransactionTableViewCell : UITableViewCell

@property (nonatomic, strong) FLEXNetworkTransaction *transaction;

+ (CGFloat)preferredCellHeight;

@end
