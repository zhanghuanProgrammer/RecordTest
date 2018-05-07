
#import <Foundation/Foundation.h>

@class FLEXArgumentInputView;

@interface FLEXArgumentInputViewFactory : NSObject

+ (FLEXArgumentInputView *)argumentInputViewForTypeEncoding:(const char *)typeEncoding;
+ (FLEXArgumentInputView *)argumentInputViewForTypeEncoding:(const char *)typeEncoding currentValue:(id)currentValue;
+ (BOOL)canEditFieldWithTypeEncoding:(const char *)typeEncoding currentValue:(id)currentValue;

@end
