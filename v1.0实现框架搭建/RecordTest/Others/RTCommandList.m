
#import "RTCommandList.h"


#define RC_WAITING_KEYWINDOW_AVAILABLE 0.f
#define RC_AUTODOCKING_ANIMATE_DURATION 0.2f
#define RC_DOUBLE_TAP_TIME_INTERVAL 0.16f

@implementation RTCommandList

@synthesize draggable = _draggable;
@synthesize autoDocking = _autoDocking;

@synthesize longPressBlock = _longPressBlock;
@synthesize tapBlock = _tapBlock;
@synthesize doubleTapBlock = _doubleTapBlock;

@synthesize draggingBlock = _draggingBlock;
@synthesize dragDoneBlock = _dragDoneBlock;

@synthesize autoDockingBlock = _autoDockingBlock;
@synthesize autoDockingDoneBlock = _autoDockingDoneBlock;

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

+ (RTCommandList *)shareInstance{
    static dispatch_once_t pred = 0;
    __strong static RTCommandList *_sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[RTCommandList alloc] init];
        [_sharedObject defaultSetting];
    });
    return _sharedObject;
}

- (id)initInKeyWindowWithFrame:(CGRect)frame {
    self = [RTCommandList shareInstance];
    self.frame = frame;
    if (self) {
        [self performSelector:@selector(addButtonToKeyWindow) withObject:nil afterDelay:RC_WAITING_KEYWINDOW_AVAILABLE];
        [self defaultSetting];
        
        UILabel *curCommand = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 12)];
        curCommand.textColor = [UIColor redColor];
        curCommand.font = [UIFont systemFontOfSize:12];
        [self addSubview:curCommand];
        curCommand.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        self.curCommand = curCommand;
        
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 12, frame.size.width, frame.size.height-12)];
        [self addSubview:tableView];
        tableView.tableFooterView = [UIView new];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.delegate = self;
        tableView.dataSource = self;
        self.tableView = tableView;
        self.tableView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    }
    return self;
}

- (void)defaultSetting {
    _draggable = YES;
    _autoDocking = YES;
    _singleTapBeenCanceled = NO;
    
    _longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] init];
    [_longPressGestureRecognizer addTarget:self action:@selector(gestureRecognizerHandle:)];
    [_longPressGestureRecognizer setAllowableMovement:0];
    [self addGestureRecognizer:_longPressGestureRecognizer];
}

- (void)addButtonToKeyWindow {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

#pragma mark - Ges
- (void)gestureRecognizerHandle:(UILongPressGestureRecognizer *)gestureRecognizer {
    switch ([gestureRecognizer state]) {
        case UIGestureRecognizerStateBegan: {
            if (_longPressBlock) {
                _longPressBlock(self);
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - Blocks
#pragma mark Touch Blocks
- (void)setTapBlock:(void (^)(RTCommandList *))tapBlock {
    _tapBlock = tapBlock;
    
    if (_tapBlock) {
        [self addUITapGestureRecognizerWithTarget:self withAction:@selector(buttonTouched)];
    }
}

#pragma mark - Touch
- (void)buttonTouched {
    [self performSelector:@selector(executeButtonTouchedBlock) withObject:nil afterDelay:(_doubleTapBlock ? RC_DOUBLE_TAP_TIME_INTERVAL : 0)];
}

- (void)executeButtonTouchedBlock {
    if (!_singleTapBeenCanceled && _tapBlock && !_isDragging) {
        _tapBlock(self);
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    _isDragging = NO;
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    if (touch.tapCount == 2) {
        if (_doubleTapBlock) {
            _singleTapBeenCanceled = YES;
            _doubleTapBlock(self);
        }
    } else {
        _singleTapBeenCanceled = NO;
    }
    _beginLocation = [[touches anyObject] locationInView:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if (_draggable) {
        _isDragging = YES;
        
        UITouch *touch = [touches anyObject];
        CGPoint currentLocation = [touch locationInView:self];
        
        //设置自身的位置
        float offsetX = currentLocation.x - _beginLocation.x;
        float offsetY = currentLocation.y - _beginLocation.y;
        
        self.center = CGPointMake(self.center.x + offsetX, self.center.y + offsetY);
        
        
        //设置自身移动不超过边界
        CGRect superviewFrame = self.superview.frame;
        CGRect frame = self.frame;
        CGFloat leftLimitX = frame.size.width / 2;
        CGFloat rightLimitX = superviewFrame.size.width - leftLimitX;
        CGFloat topLimitY = frame.size.height / 2;
        CGFloat bottomLimitY = superviewFrame.size.height - topLimitY;
        
        if (self.center.x > rightLimitX) {
            self.center = CGPointMake(rightLimitX, self.center.y);
        }else if (self.center.x <= leftLimitX) {
            self.center = CGPointMake(leftLimitX, self.center.y);
        }
        
        if (self.center.y > bottomLimitY) {
            self.center = CGPointMake(self.center.x, bottomLimitY);
        }else if (self.center.y <= topLimitY){
            self.center = CGPointMake(self.center.x, topLimitY);
        }
        
        if (_draggingBlock) {
            _draggingBlock(self);
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded: touches withEvent: event];
    
    if (_isDragging && _dragDoneBlock) {
        _dragDoneBlock(self);
        _singleTapBeenCanceled = YES;
    }
    
    if (_isDragging && _autoDocking) {
        CGRect superviewFrame = self.superview.frame;
        CGRect frame = self.frame;
        CGFloat middleX = superviewFrame.size.width / 2;
        
        if (self.center.x >= middleX) {
            [UIView animateWithDuration:RC_AUTODOCKING_ANIMATE_DURATION animations:^{
                self.center = CGPointMake(superviewFrame.size.width - frame.size.width / 2, self.center.y);
                if (_autoDockingBlock) {
                    _autoDockingBlock(self);
                }
            } completion:^(BOOL finished) {
                if (_autoDockingDoneBlock) {
                    _autoDockingDoneBlock(self);
                }
            }];
        } else {
            [UIView animateWithDuration:RC_AUTODOCKING_ANIMATE_DURATION animations:^{
                self.center = CGPointMake(frame.size.width / 2, self.center.y);
                if (_autoDockingBlock) {
                    _autoDockingBlock(self);
                }
            } completion:^(BOOL finished) {
                if (_autoDockingDoneBlock) {
                    _autoDockingDoneBlock(self);
                }
            }];
        }
    }
    
    _isDragging = NO;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    _isDragging = NO;
    [super touchesCancelled:touches withEvent:event];
}

- (BOOL)isDragging {
    return _isDragging;
}

#pragma mark - version
+ (NSString *)version {
    return RC_DB_VERSION;
}

#pragma mark - remove
+ (void)removeAllFromKeyWindow {
    for (id view in [[UIApplication sharedApplication].keyWindow subviews]) {
        if ([view isKindOfClass:[RTCommandList class]]) {
            [view removeFromSuperview];
        }
    }
}

+ (void)removeAllFromView:(id)superView {
    for (id view in [superView subviews]) {
        if ([view isKindOfClass:[RTCommandList class]]) {
            [view removeFromSuperview];
        }
    }
}

#pragma mark TableViewDelegate

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static  NSString *cellIdtifier=@"RTCommandListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdtifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdtifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell.imageView cornerRadius];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:10];
        cell.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    }
    NSString *text = self.dataArr[indexPath.row];
    cell.textLabel.text = text;
    cell.imageView.backgroundColor = (indexPath.row == self.curRow) ? [UIColor greenColor] : [UIColor clearColor];
    cell.textLabel.textColor = (indexPath.row == self.curRow) ? [UIColor greenColor] : [UIColor whiteColor];
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 12;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView  deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)reloadData{
    [self.tableView reloadData];
}

- (void)setCurRow:(NSInteger)row{
    _curRow = row;
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:(UITableViewScrollPositionTop) animated:YES];
}

@end
