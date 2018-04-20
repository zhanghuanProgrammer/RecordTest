
#import <Foundation/Foundation.h>
#import "ZHRepearDictionary.h"

@interface RTVertex : NSObject

+ (RTVertex *)shareInstance;
@property (nonatomic,strong)ZHRepearDictionary *repearDictionary;

+ (NSArray *)shortestPath:(NSArray *)paths from:(NSString *)from to:(NSString *)to;

@end
