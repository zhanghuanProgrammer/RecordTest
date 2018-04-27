
#import "RTCrashModel.h"

@implementation RTCrashModel

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.crashStack forKey:@"crashStack"];
    [aCoder encodeObject:self.imagePath forKey:@"imagePath"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.crashStack = [aDecoder decodeObjectForKey:@"crashStack"];
        self.imagePath = [aDecoder decodeObjectForKey:@"imagePath"];
    }
    return self;
}

@end
