
#import "RTRunOperationQueue.h"

@implementation RTRunOperationQueue

- (instancetype)init{
    self = [super init];
    if (self) {
        self.curRow = -1;
    }
    return self;
}

- (void)nextStep{
    if (self.curRow < self.operationQueue.count) {
        self.curRow ++;
    }
}

- (void)nextSteps{
    
}

@end
