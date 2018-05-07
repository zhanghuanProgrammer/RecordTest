
#import "FLEXFieldEditorViewController.h"

@interface FLEXDefaultEditorViewController : FLEXFieldEditorViewController

- (id)initWithDefaults:(NSUserDefaults *)defaults key:(NSString *)key;

+ (BOOL)canEditDefaultWithValue:(id)currentValue;

@end
