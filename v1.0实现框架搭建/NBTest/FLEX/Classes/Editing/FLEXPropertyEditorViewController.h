
#import "FLEXFieldEditorViewController.h"
#import <objc/runtime.h>

@interface FLEXPropertyEditorViewController : FLEXFieldEditorViewController

- (id)initWithTarget:(id)target property:(objc_property_t)property;

+ (BOOL)canEditProperty:(objc_property_t)property currentValue:(id)value;

@end
