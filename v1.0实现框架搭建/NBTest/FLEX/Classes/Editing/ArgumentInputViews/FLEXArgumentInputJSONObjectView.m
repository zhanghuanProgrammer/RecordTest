
#import "FLEXArgumentInputJSONObjectView.h"
#import "FLEXRuntimeUtility.h"

@implementation FLEXArgumentInputJSONObjectView

- (instancetype)initWithArgumentTypeEncoding:(const char *)typeEncoding
{
    self = [super initWithArgumentTypeEncoding:typeEncoding];
    if (self) {
        self.inputTextView.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        self.targetSize = FLEXArgumentInputViewSizeLarge;
    }
    return self;
}

- (void)setInputValue:(id)inputValue
{
    self.inputTextView.text = [FLEXRuntimeUtility editableJSONStringForObject:inputValue];
}

- (id)inputValue
{
    return [FLEXRuntimeUtility objectValueFromEditableJSONString:self.inputTextView.text];
}

+ (BOOL)supportsObjCType:(const char *)type withCurrentValue:(id)value
{
    BOOL supported = type && type[0] == '@';
    
    if (supported) {
        if (value) {
            supported = [FLEXRuntimeUtility editableJSONStringForObject:value] != nil;
        } else {
            if (strcmp(type, @encode(id)) != 0) {
                BOOL isJSONSerializableType = NO;
                isJSONSerializableType = isJSONSerializableType || strcmp(type, FLEXEncodeClass(NSString)) == 0;
                isJSONSerializableType = isJSONSerializableType || strcmp(type, FLEXEncodeClass(NSNumber)) == 0;
                isJSONSerializableType = isJSONSerializableType || strcmp(type, FLEXEncodeClass(NSArray)) == 0;
                isJSONSerializableType = isJSONSerializableType || strcmp(type, FLEXEncodeClass(NSDictionary)) == 0;
                
                supported = isJSONSerializableType;
            }
        }
    }
    
    return supported;
}

@end
