
#import "FLEXArgumentInputDateView.h"
#import "FLEXRuntimeUtility.h"

@interface FLEXArgumentInputDateView ()

@property (nonatomic, strong) UIDatePicker *datePicker;

@end

@implementation FLEXArgumentInputDateView

- (instancetype)initWithArgumentTypeEncoding:(const char *)typeEncoding
{
    self = [super initWithArgumentTypeEncoding:typeEncoding];
    if (self) {
        self.datePicker = [[UIDatePicker alloc] init];
        self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        self.datePicker.calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
        self.datePicker.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
        [self addSubview:self.datePicker];
    }
    return self;
}

- (void)setInputValue:(id)inputValue
{
    if ([inputValue isKindOfClass:[NSDate class]]) {
        self.datePicker.date = inputValue;
    }
}

- (id)inputValue
{
    return self.datePicker.date;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.datePicker.frame = self.bounds;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGFloat height = [self.datePicker sizeThatFits:size].height;
    return CGSizeMake(size.width, height);
}

+ (BOOL)supportsObjCType:(const char *)type withCurrentValue:(id)value
{
    return (type && (strcmp(type, FLEXEncodeClass(NSDate)) == 0)) || [value isKindOfClass:[NSDate class]];
}

@end
