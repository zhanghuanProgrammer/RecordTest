
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, FLEXArgumentInputViewSize) {
    FLEXArgumentInputViewSizeDefault = 0,
    FLEXArgumentInputViewSizeSmall,
    FLEXArgumentInputViewSizeLarge
};

@protocol FLEXArgumentInputViewDelegate;

@interface FLEXArgumentInputView : UIView

- (instancetype)initWithArgumentTypeEncoding:(const char *)typeEncoding;

@property (nonatomic, copy) NSString *title;
@property (nonatomic) id inputValue;
@property (nonatomic, assign) FLEXArgumentInputViewSize targetSize;
@property (nonatomic, weak) id <FLEXArgumentInputViewDelegate> delegate;
@property (nonatomic, readonly) BOOL inputViewIsFirstResponder;
+ (BOOL)supportsObjCType:(const char *)type withCurrentValue:(id)value;

@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) NSString *typeEncoding;
@property (nonatomic, readonly) CGFloat topInputFieldVerticalLayoutGuide;

@end

@protocol FLEXArgumentInputViewDelegate <NSObject>

- (void)argumentInputViewValueDidChange:(FLEXArgumentInputView *)argumentInputView;

@end
