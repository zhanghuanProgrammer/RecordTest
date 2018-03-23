
#import "RTOperationQueue.h"
#import "NSArray+ZH.h"
#import "RecordTestHeader.h"
#import "ZHSaveDataToFMDB.h"

@implementation RTOperationQueueModel

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.viewId forKey:@"viewId"];
    [aCoder encodeObject:self.view forKey:@"view"];
    [aCoder encodeObject:self.parameters forKey:@"parameters"];
    [aCoder encodeInteger:self.type forKey:@"type"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.viewId = [aDecoder decodeObjectForKey:@"viewId"];
        self.view = [aDecoder decodeObjectForKey:@"view"];
        self.parameters = [aDecoder decodeObjectForKey:@"parameters"];
        self.type = [aDecoder decodeIntegerForKey:@"type"];
    }
    return self;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"%@-%@-%@",self.viewId,@(self.type),self.parameters];
}

@end


@interface RTOperationQueue ()

@property (nonatomic,strong)NSMutableArray *operationQueue;

@end

@implementation RTOperationQueue

+ (RTOperationQueue *)shareInstance{
    static dispatch_once_t pred = 0;
    __strong static RTOperationQueue *_sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[RTOperationQueue alloc] init];
    });
    return _sharedObject;
}

- (NSMutableArray *)operationQueue{
    if (!_operationQueue) {
        _operationQueue = [NSMutableArray array];
    }
    return _operationQueue;
}

+ (void)addOperation:(UIView *)view type:(RTOperationQueueType)type parameters:(NSArray *)parameters repeat:(BOOL)repeat{
    if(view.layerDirector.length <= 0)return;
    if (repeat == NO) {
        NSArray *operationQueue = [RTOperationQueue shareInstance].operationQueue;
        for (NSInteger i = operationQueue.count - 1; i >= 0; i--) {
            RTOperationQueueModel *model = operationQueue[i];
            if (model.type != type) {
                break;
            }
            if ([model.viewId isEqualToString:view.layerDirector] && model.type == type) {
                model.parameters = parameters;
//                NSLog(@"%@",[RTOperationQueue shareInstance].operationQueue);
                [self saveOperationQueue];
                return;
            }
        }
    }
    RTOperationQueueModel *model = [RTOperationQueueModel new];
    model.type = type;
    model.viewId = view.layerDirector;
    model.parameters = parameters;
    model.view = NSStringFromClass(view.class);
    [[RTOperationQueue shareInstance].operationQueue addObject:model];
    [self saveOperationQueue];
//    NSLog(@"%@",[RTOperationQueue shareInstance].operationQueue);
}

+ (void)saveOperationQueue{
    if (!IsRecord) {
        return;
    }
    [ZHSaveDataToFMDB insertDataWithData:[RTOperationQueue shareInstance].operationQueue WithIdentity:@"operationQueue"];
//    NSLog(@"%@",@"保存成功!");
}

+ (void)runOperationQueue{
    if (!IsRunRecord) {
        return;
    }
    NSMutableArray *operationQueue = [NSMutableArray arrayWithArray:[ZHSaveDataToFMDB selectDataWithIdentity:@"operationQueue"]];
    if (![RTOperationQueue shareInstance].curOperationModel) {
        [RTOperationQueue shareInstance].curOperationModel = [operationQueue popFirstObject];
        [ZHSaveDataToFMDB insertDataWithData:operationQueue WithIdentity:@"operationQueue"];
    }
}

@end
