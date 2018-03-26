#import "RTCommandListVCTableViewCell.h"
#import "RecordTestHeader.h"

@interface RTCommandListVCTableViewCell ()

@property (nonatomic,strong)UIImageView *hintImg;
@property (nonatomic,strong)UILabel *hintLabel;

@property (nonatomic,weak)RTCommandListVCCellModel *dataModel;

@end

@implementation RTCommandListVCTableViewCell

- (void)refreshUI:(RTCommandListVCCellModel *)dataModel{
    _dataModel = dataModel;
    if (dataModel.identify) {
        self.hintLabel.text = [dataModel.identify debugDescription];
    }else if (dataModel.operationModel){
        self.hintLabel.text = [dataModel.operationModel debugDescription];
    }
    self.hintImg.backgroundColor = (dataModel.indexPath.row == [RTCommandList shareInstance].curRow) ? [UIColor greenColor] : [UIColor clearColor];
    self.hintLabel.textColor = (dataModel.indexPath.row == [RTCommandList shareInstance].curRow) ? [UIColor greenColor] : [UIColor whiteColor];
    self.hintImg.image = [UIImage imageNamed:(dataModel.indexPath.row < [RTCommandList shareInstance].curRow) ? @"SuspendBall_stoprecord" : @"SuspendBall_startrecord"];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.hintImg = [[UIImageView alloc]initWithFrame:CGRectMake(5, 12, 15, 15)];
        [self.contentView addSubview:self.hintImg];
        [self.hintImg cornerRadius];
        self.hintLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, [UIScreen mainScreen].bounds.size.width - 35, 44)];
        self.hintLabel.textColor = [UIColor whiteColor];
        self.hintLabel.font = [UIFont systemFontOfSize:14];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        [self.contentView addSubview:self.hintLabel];
    }
    return self;
}

@end
