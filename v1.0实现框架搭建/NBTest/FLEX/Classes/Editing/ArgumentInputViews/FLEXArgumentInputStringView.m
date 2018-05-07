#import "FLEXArgumentInputStringView.h"
#import "FLEXRuntimeUtility.h"

@implementation FLEXArgumentInputStringView

- (instancetype)initWithArgumentTypeEncoding:(const char *)typeEncoding
{
    self = [super initWithArgumentTypeEncoding:typeEncoding];
    if (self) {
        self.targetSize = FLEXArgumentInputViewSizeLarge;
    }
    return self;
}

- (void)setInputValue:(id)inputValue
{
    self.inputTextView.text = inputValue;
}

- (id)inputValue
{
    return [self.inputTextView.text length] > 0 ? [self.inputTextView.text copy] : nil;
}


#pragma mark -

+ (BOOL)supportsObjCType:(const char *)type withCurrentValue:(id)value
{
    BOOL supported = type && strcmp(type, FLEXEncodeClass(NSString)) == 0;
    supported = supported || (value && [value isKindOfClass:[NSString class]]);
    return supported;
}

@end
