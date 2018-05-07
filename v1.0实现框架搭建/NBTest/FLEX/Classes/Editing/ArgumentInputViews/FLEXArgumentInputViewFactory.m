
#import "FLEXArgumentInputViewFactory.h"
#import "FLEXArgumentInputView.h"
#import "FLEXArgumentInputJSONObjectView.h"
#import "FLEXArgumentInputNumberView.h"
#import "FLEXArgumentInputSwitchView.h"
#import "FLEXArgumentInputStructView.h"
#import "FLEXArgumentInputNotSupportedView.h"
#import "FLEXArgumentInputStringView.h"
#import "FLEXArgumentInputFontView.h"
#import "FLEXArgumentInputColorView.h"
#import "FLEXArgumentInputDateView.h"

@implementation FLEXArgumentInputViewFactory

+ (FLEXArgumentInputView *)argumentInputViewForTypeEncoding:(const char *)typeEncoding
{
    return [self argumentInputViewForTypeEncoding:typeEncoding currentValue:nil];
}

+ (FLEXArgumentInputView *)argumentInputViewForTypeEncoding:(const char *)typeEncoding currentValue:(id)currentValue
{
    Class subclass = [self argumentInputViewSubclassForTypeEncoding:typeEncoding currentValue:currentValue];
    if (!subclass) {
        subclass = [FLEXArgumentInputNotSupportedView class];
    }
    return [[subclass alloc] initWithArgumentTypeEncoding:typeEncoding];
}

+ (Class)argumentInputViewSubclassForTypeEncoding:(const char *)typeEncoding currentValue:(id)currentValue
{
    Class argumentInputViewSubclass = nil;
    if ([FLEXArgumentInputColorView supportsObjCType:typeEncoding withCurrentValue:currentValue]) {
        argumentInputViewSubclass = [FLEXArgumentInputColorView class];
    } else if ([FLEXArgumentInputFontView supportsObjCType:typeEncoding withCurrentValue:currentValue]) {
        argumentInputViewSubclass = [FLEXArgumentInputFontView class];
    } else if ([FLEXArgumentInputStringView supportsObjCType:typeEncoding withCurrentValue:currentValue]) {
        argumentInputViewSubclass = [FLEXArgumentInputStringView class];
    } else if ([FLEXArgumentInputStructView supportsObjCType:typeEncoding withCurrentValue:currentValue]) {
        argumentInputViewSubclass = [FLEXArgumentInputStructView class];
    } else if ([FLEXArgumentInputSwitchView supportsObjCType:typeEncoding withCurrentValue:currentValue]) {
        argumentInputViewSubclass = [FLEXArgumentInputSwitchView class];
    } else if ([FLEXArgumentInputDateView supportsObjCType:typeEncoding withCurrentValue:currentValue]) {
        argumentInputViewSubclass = [FLEXArgumentInputDateView class];
    } else if ([FLEXArgumentInputNumberView supportsObjCType:typeEncoding withCurrentValue:currentValue]) {
        argumentInputViewSubclass = [FLEXArgumentInputNumberView class];
    } else if ([FLEXArgumentInputJSONObjectView supportsObjCType:typeEncoding withCurrentValue:currentValue]) {
        argumentInputViewSubclass = [FLEXArgumentInputJSONObjectView class];
    }
    
    return argumentInputViewSubclass;
}

+ (BOOL)canEditFieldWithTypeEncoding:(const char *)typeEncoding currentValue:(id)currentValue
{
    return [self argumentInputViewSubclassForTypeEncoding:typeEncoding currentValue:currentValue] != nil;
}

@end
