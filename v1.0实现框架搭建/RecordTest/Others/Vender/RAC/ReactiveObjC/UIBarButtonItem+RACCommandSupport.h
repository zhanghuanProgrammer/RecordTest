
#import <UIKit/UIKit.h>

@class RACCommand<__contravariant InputType, __covariant ValueType>;

NS_ASSUME_NONNULL_BEGIN

@interface UIBarButtonItem (RACCommandSupport)

/// Sets the control's command. When the control is clicked, the command is
/// executed with the sender of the event. The control's enabledness is bound
/// to the command's `canExecute`.
///
/// Note: this will reset the control's target and action.
@property (nonatomic, strong, nullable) RACCommand<__kindof UIBarButtonItem *, id> *rac_command;

@end

NS_ASSUME_NONNULL_END
