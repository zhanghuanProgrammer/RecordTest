
#import <UIKit/UIKit.h>

@interface FLEXHierarchyTableViewCell : UITableViewCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic, assign) NSInteger viewDepth;
@property (nonatomic, strong) UIColor *viewColor;

@end
