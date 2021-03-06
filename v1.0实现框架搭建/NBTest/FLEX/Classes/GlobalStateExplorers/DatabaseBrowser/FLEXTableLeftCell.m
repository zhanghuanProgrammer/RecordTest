
#import "FLEXTableLeftCell.h"

@implementation FLEXTableLeftCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"FLEXTableLeftCell";
    FLEXTableLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[FLEXTableLeftCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        UILabel *textLabel               = [[UILabel alloc] initWithFrame:CGRectZero];
        textLabel.textAlignment          = NSTextAlignmentCenter;
        textLabel.font                   = [UIFont systemFontOfSize:13.0];
        textLabel.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:textLabel];
        cell.titlelabel = textLabel;
    }
    return cell;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titlelabel.frame = self.contentView.frame;
}
@end
