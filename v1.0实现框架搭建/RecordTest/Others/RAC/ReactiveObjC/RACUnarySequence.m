
#import "RACUnarySequence.h"
#import "RACEXTKeyPathCoding.h"
#import "NSObject+RACDescription.h"

@interface RACUnarySequence ()

// The single value stored in this sequence.
@property (nonatomic, strong, readwrite) id head;

@end

@implementation RACUnarySequence

#pragma mark Properties

@synthesize head = _head;

#pragma mark Lifecycle

+ (RACUnarySequence *)return:(id)value {
	RACUnarySequence *sequence = [[self alloc] init];
	sequence.head = value;
	return [sequence setNameWithFormat:@"+return: %@", RACDescription(value)];
}

#pragma mark RACSequence

- (RACSequence *)tail {
	return nil;
}

- (RACSequence *)bind:(RACSequenceBindBlock (^)(void))block {
	RACStreamBindBlock bindBlock = block();
	BOOL stop = NO;

	RACSequence *result = (id)[bindBlock(self.head, &stop) setNameWithFormat:@"[%@] -bind:", self.name];
	return result ?: self.class.empty;
}

#pragma mark NSCoding

- (Class)classForCoder {
	// Unary sequences should be encoded as themselves, not array sequences.
	return self.class;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
	id value = [coder decodeObjectForKey:@keypath(self.head)];
	return [self.class return:value];
}

- (void)encodeWithCoder:(NSCoder *)coder {
	if (self.head != nil) [coder encodeObject:self.head forKey:@keypath(self.head)];
}

#pragma mark NSObject

- (NSString *)description {
	return [NSString stringWithFormat:@"<%@: %p>{ name = %@, head = %@ }", self.class, self, self.name, self.head];
}

- (NSUInteger)hash {
	return [self.head hash];
}

- (BOOL)isEqual:(RACUnarySequence *)seq {
	if (self == seq) return YES;
	if (![seq isKindOfClass:RACUnarySequence.class]) return NO;

	return self.head == seq.head || [(NSObject *)self.head isEqual:seq.head];
}

@end
