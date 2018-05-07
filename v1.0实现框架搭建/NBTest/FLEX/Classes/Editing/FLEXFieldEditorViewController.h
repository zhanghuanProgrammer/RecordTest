
#import <UIKit/UIKit.h>

@class FLEXFieldEditorView;
@class FLEXArgumentInputView;

@interface FLEXFieldEditorViewController : UIViewController

- (id)initWithTarget:(id)target;

@property (nonatomic, readonly) FLEXArgumentInputView *firstInputView;

@property (nonatomic, strong, readonly) id target;
@property (nonatomic, strong, readonly) FLEXFieldEditorView *fieldEditorView;
@property (nonatomic, strong, readonly) UIBarButtonItem *setterButton;
- (void)actionButtonPressed:(id)sender;
- (NSString *)titleForActionButton;

@end
