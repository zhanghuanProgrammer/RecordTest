
#import "RTLagModel.h"

@implementation RTLagModel

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.lagStack forKey:@"lagStack"];
    [aCoder encodeObject:self.imagePath forKey:@"imagePath"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.lagStack = [aDecoder decodeObjectForKey:@"lagStack"];
        self.imagePath = [aDecoder decodeObjectForKey:@"imagePath"];
    }
    return self;
}

@end
