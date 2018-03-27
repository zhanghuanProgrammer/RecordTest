
#import "RTOperationQueue.h"
#import "NSArray+ZH.h"
#import "RecordTestHeader.h"
#import "ZHSaveDataToFMDB.h"
#import "ZHAlertAction.h"

@implementation RTOperationQueueModel

- (instancetype)copyNew{
    RTOperationQueueModel *copy = [RTOperationQueueModel new];
    copy.view = self.view;
    copy.viewId = self.viewId;
    copy.parameters = self.parameters;
    copy.type = self.type;
    copy.vc = self.vc;
    return copy;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.viewId forKey:@"viewId"];
    [aCoder encodeObject:self.view forKey:@"view"];
    [aCoder encodeObject:self.parameters forKey:@"parameters"];
    [aCoder encodeInteger:self.type forKey:@"type"];
    [aCoder encodeObject:self.vc forKey:@"vc"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.viewId = [aDecoder decodeObjectForKey:@"viewId"];
        self.view = [aDecoder decodeObjectForKey:@"view"];
        self.parameters = [aDecoder decodeObjectForKey:@"parameters"];
        self.type = [aDecoder decodeIntegerForKey:@"type"];
        self.vc = [aDecoder decodeObjectForKey:@"vc"];
    }
    return self;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"%@-%@-%@",self.vc,[self typeString],[self parameterString]];
}

//- (NSString *)description{
//    return [NSString stringWithFormat:@"%@-%@-%@",self.viewId,[self typeString],[self parameterString]];
//}

- (NSString *)debugDescription{
    return [NSString stringWithFormat:@"%@-%@-%@",self.view,[self typeString],[self parameterString]];
}

- (NSString *)parameterString{
    if (self.parameters) {
        NSMutableString *string = [NSMutableString string];
        for (id obj in self.parameters) {
            [string appendFormat:@"%@ ",obj];
        }
        return string;
    }
    return @"";
}

//- (NSString *)typeString{
//    switch (self.type) {
//        case RTOperationQueueTypeEvent: case RTOperationQueueTypeTableViewCellTap:
//            return @"控件点击";
//            break;
//        case RTOperationQueueTypeScroll:
//            return @"滚动";
//            break;
//        default:
//            break;
//    }
//    return @"unknow";
//}

- (NSString *)typeString{
    switch (self.type) {
        case RTOperationQueueTypeEvent: case RTOperationQueueTypeTableViewCellTap:
            return @"Click";
            break;
        case RTOperationQueueTypeScroll:
            return @"Scroll";
            break;
        default:
            break;
    }
    return @"unknow";
}

@end

@implementation RTIdentify

- (instancetype)initWithIdentify:(NSString *)identify forVC:(NSString *)forVC{
    self = [super init];
    if (self) {
        self.identify = identify;
        self.forVC = forVC;
    }
    return self;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"%@_&^_^&_%@",self.identify,self.forVC];
}

- (NSString *)debugDescription{
    return [NSString stringWithFormat:@"%@ : %@",self.identify,self.forVC];
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

- (void)setIsRecord:(BOOL)isRecord{
    _isRecord = isRecord;
    if (!isRecord) {
        [[SuspendBall shareInstance]setImage:@"SuspendBall_startrecord" index:3];
        [self.operationQueue removeAllObjects];
        [[RTCommandList shareInstance] initData];
    }else{
        [[SuspendBall shareInstance]setImage:@"SuspendBall_stoprecord" index:3];
        [self.operationQueue removeAllObjects];
    }
}

+ (void)startOrStopRecord{
    if (![RTOperationQueue shareInstance].isRecord) {//开始录制
        [RTOperationQueue shareInstance].isRecord = YES;
        [JohnAlertManager showAlertWithType:JohnTopAlertTypeError title:@"开始录制!"];
        [RTOperationQueue shareInstance].forVC = [NSString stringWithFormat:@"%@",[RTTopVC shareInstance].topVC];
    }else{//结束录制
        [ZHAlertAction alertWithTitle:@"是否保存?" withMsg:nil addToViewController:[UIViewController getCurrentVC] ActionSheet:NO otherButtonBlocks:@[^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [ZHAlertAction showOneTextEntryAlertTitle:@"请命名" withMsg:@"唯一标识符" addToViewController:[UIViewController getCurrentVC] withCancleBlock:nil withOkBlock:^(NSString *str) {
                    RTIdentify *identify = [[RTIdentify alloc] initWithIdentify:str forVC:[RTOperationQueue shareInstance].forVC];
                    if ([RTOperationQueue saveOperationQueue:identify]) {
                        [RTOperationQueue shareInstance].isRecord = NO;
                    }
                } cancelButtonTitle:@"取消" OkButtonTitle:@"确定" onePlaceHold:@"唯一标识符"];
            });
        },^{
            [RTOperationQueue shareInstance].isRecord = NO;
        }] otherButtonTitles:@[@"保存",@"取消"]];
    }
}

+ (void)addOperation:(UIView *)view type:(RTOperationQueueType)type parameters:(NSArray *)parameters repeat:(BOOL)repeat{
    if (!IsRecord && [RTOperationQueue shareInstance].isRecord) {
        return;
    }
    if(view.layerDirector.length <= 0) return;
    if (repeat == NO) {
        NSArray *operationQueue = [RTOperationQueue shareInstance].operationQueue;
        for (NSInteger i = operationQueue.count - 1; i >= 0; i--) {
            RTOperationQueueModel *model = operationQueue[i];
            if (model.type != type) {
                continue;
            }
            if ([model.viewId isEqualToString:view.layerDirector] && model.type == type) {
//                if (model.type == RTOperationQueueTypeScroll){
//                    CGPoint point1 = [[model.parameters firstObject] CGPointValue];
//                    CGPoint point2 = [[parameters firstObject] CGPointValue];
//                    if (CGPointEqualToPoint(point1, point2)) {
//                        return;//不添加了,一模一样
//                    }
//                }
                model.parameters = parameters;
                NSLog(@"%@",[RTOperationQueue shareInstance].operationQueue);
                if (model.type != RTOperationQueueTypeScroll && [RTOperationQueue shareInstance].isRecord) {
                    [ZHStatusBarNotification showWithStatus:[NSString stringWithFormat:@"%@",[model debugDescription]] dismissAfter:1 styleName:JDStatusBarStyleSuccess];
                }
                return;
            }
        }
    }
    RTOperationQueueModel *model = [RTOperationQueueModel new];
    model.type = type;
    model.viewId = view.layerDirector;
    model.parameters = parameters;
    model.view = NSStringFromClass(view.class);
    model.vc = [view curViewController];
    [[RTOperationQueue shareInstance].operationQueue addObject:model];
    if (model.type != RTOperationQueueTypeScroll && [RTOperationQueue shareInstance].isRecord) {
        [ZHStatusBarNotification showWithStatus:[NSString stringWithFormat:@"%@",[model debugDescription]] dismissAfter:1 styleName:JDStatusBarStyleSuccess];
    }
    NSLog(@"%@",[RTOperationQueue shareInstance].operationQueue);
}

+ (NSMutableDictionary *)operationQueues{
    NSMutableDictionary *operationQueues = [ZHSaveDataToFMDB selectDataWithIdentity:@"operationQueue"];
    if (!operationQueues) {
        operationQueues = [NSMutableDictionary dictionary];
    }
    return operationQueues;
}

+ (BOOL)saveOperationQueue:(RTIdentify *)identify{
    NSMutableDictionary *operationQueues = [self operationQueues];
    if (operationQueues[[identify description]]) {
        [JohnAlertManager showAlertWithType:JohnTopAlertTypeError title:@"已经存在!"];
        return NO;
    }
    [operationQueues setValue:[RTOperationQueue shareInstance].operationQueue forKey:[identify description]];
    [ZHSaveDataToFMDB insertDataWithData:operationQueues WithIdentity:@"operationQueue"];
    [JohnAlertManager showAlertWithType:JohnTopAlertTypeSuccess title:@"保存成功!"];
    [RTOperationQueue shareInstance].isRecord = NO;
    return YES;
}

+ (NSMutableArray *)getOperationQueue:(RTIdentify *)identify{
    NSMutableDictionary *operationQueues = [self operationQueues];
    return operationQueues[[identify description]];
}

+ (void)deleteOperationQueue:(RTIdentify *)identify{
    NSMutableDictionary *operationQueues = [self operationQueues];
    if (operationQueues[[identify description]]) {
        [operationQueues removeObjectForKey:[identify description]];
        [JohnAlertManager showAlertWithType:JohnTopAlertTypeSuccess title:@"保存成功!"];
    }else{
        [JohnAlertManager showAlertWithType:JohnTopAlertTypeError title:@"删除对象不存在!"];
    }
}

+ (BOOL)reChanggeOperationQueue:(RTIdentify *)identify{
    NSMutableDictionary *operationQueues = [self operationQueues];
    [operationQueues setValue:[RTOperationQueue shareInstance].operationQueue forKey:[identify description]];
    [ZHSaveDataToFMDB insertDataWithData:operationQueues WithIdentity:@"operationQueue"];
    [JohnAlertManager showAlertWithType:JohnTopAlertTypeSuccess title:@"保存成功!"];
    return YES;
}

+ (BOOL)isExsitOperationQueue:(RTIdentify *)identify{
    NSMutableDictionary *operationQueues = [self operationQueues];
    if (operationQueues[[identify description]]) {
        return YES;
    }else{
        return NO;
    }
}

+ (NSArray *)allIdentifyModels{
    NSMutableDictionary *operationQueues = [self operationQueues];
    NSArray *allKyes = [operationQueues allKeys];
    NSMutableArray *allIdentifyModels = [NSMutableArray arrayWithCapacity:allKyes.count];
    for (NSString *key in allKyes) {
        NSArray *splits = [key componentsSeparatedByString:@"_&^_^&_"];
        if (splits.count >= 2) {
            RTIdentify *identifyModel = [RTIdentify new];
            identifyModel.identify = splits[0];
            identifyModel.forVC = splits[1];
            [allIdentifyModels addObject:identifyModel];
        }
    }
    return allIdentifyModels;
}

+ (NSArray *)allIdentifyModelsForVC:(NSString *)vc{
    if(vc.length <= 0)return nil;
    NSArray *allIdentifyModels = [self allIdentifyModels];
    NSMutableArray *filters = [NSMutableArray arrayWithCapacity:allIdentifyModels.count];
    for (RTIdentify *identify in allIdentifyModels) {
        if ([identify.forVC isEqualToString:vc]) {
            [filters addObject:identify];
        }
    }
    return filters;
}

@end
