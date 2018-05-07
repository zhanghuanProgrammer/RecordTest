
#import "FLEXFieldEditorViewController.h"
#import <objc/runtime.h>

@interface FLEXIvarEditorViewController : FLEXFieldEditorViewController

- (id)initWithTarget:(id)target ivar:(Ivar)ivar;

+ (BOOL)canEditIvar:(Ivar)ivar currentValue:(id)value;

@end
