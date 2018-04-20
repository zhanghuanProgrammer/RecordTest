
#import "RTVCLearn.h"
#import "RecordTestHeader.h"

@interface RTVCLearn ()

@property (nonatomic,strong)NSMutableDictionary *vcIdentity;
@property (nonatomic,strong)NSMutableArray *vcIdentityReverse;

@property (nonatomic,strong)NSMutableDictionary *vcUnion;//页面相互共存的
@property (nonatomic,strong)NSMutableString *topology;//vc路径,连续的操作路径
@property (nonatomic,strong)NSMutableString *topologyMore;//vc路径,连续的操作路径(这个可以存在相同的push)

@end

@implementation RTVCLearn

+ (RTVCLearn*)shareInstance{
    static dispatch_once_t pred = 0;
    __strong static RTVCLearn* _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[RTVCLearn alloc] init];
        _sharedObject.vcIdentityReverse = [NSMutableArray array];
        _sharedObject.vcIdentity = [NSMutableDictionary dictionary];
        _sharedObject.vcUnion = [NSMutableDictionary dictionary];
        _sharedObject.topology = [NSMutableString string];
        _sharedObject.topologyMore = [NSMutableString string];
    });
    return _sharedObject;
}

- (NSString *)getVcIdentity:(NSString *)vc{
    if (!vc) {
        return @"";
    }
    NSString *vcIdentity = self.vcIdentity[vc];
    if (!vcIdentity) {
        vcIdentity = [NSString stringWithFormat:@"%lu",(unsigned long)self.vcIdentity.count];
        self.vcIdentity[vc] = vcIdentity;
        [self.vcIdentityReverse addObject:vc];
    }
    return vcIdentity;
}

- (NSString *)getVcWithIdentity:(NSString *)identity{
    NSInteger index = [identity integerValue];
    if (self.vcIdentityReverse.count>index) {
        return self.vcIdentityReverse[index];
    }
    return nil;
}

- (void)setUnionVC:(NSArray *)vcs{
    NSMutableString *identitys = [NSMutableString string];
    for (NSString *vc in vcs) {
        NSString *vcIdentity = [self getVcIdentity:vc];
        [identitys appendFormat:@"%@,",vcIdentity];
    }
    if (identitys.length>0) {
        static NSString *lastIdentitys = nil;
        NSString *temp = [identitys substringToIndex:identitys.length-1];
        if (!self.vcUnion[temp]) {
            self.vcUnion[temp] = @"";
//            NSLog(@"%@",self.vcUnion);
            [self setTopologyVC:vcs unionVC:temp];
        }else{
            if (temp.length != lastIdentitys.length ||![temp isEqualToString:lastIdentitys]) {
                [self setTopologyVC:vcs unionVC:temp];
            }
        }
        lastIdentitys = temp;
    }
}

- (void)setTopologyVC:(NSArray *)vcStack unionVC:(NSString *)unionVC{
    static NSString *lastVC = nil;
    if (vcStack.count > 0) {
        NSString *curVC = [vcStack lastObject];
        if (!lastVC) {
            [self.topology appendString:[self getVcIdentity:curVC]];
        }
//        NSLog(@"😄%@",unionVC);
        if (lastVC && lastVC.length > 0 && ![lastVC isEqualToString:curVC]) {
            [self.topology appendFormat:@",%@",[self getVcIdentity:curVC]];
            NSString *unionSuffix = [self unionSuffix:unionVC topology:self.topology];
            NSString *appendString = @"";
            NSRange range = [unionSuffix rangeOfString:@","];
            if (range.location != NSNotFound) {
                appendString = [unionSuffix substringFromIndex:range.location+1];
            }else{
                appendString = unionSuffix;
            }
            [self.topology replaceCharactersInRange:NSMakeRange(self.topology.length - unionSuffix.length , unionSuffix.length) withString:appendString];
//            NSLog(@"💣:%@",appendString);
        }
        lastVC = curVC;
    }
//    NSLog(@"当前最顶部的控制器%@",[RTTopVC shareInstance].topVC);
//    NSLog(@"👌%@",self.topology);
}

- (void)setTopologyVCMore:(NSArray *)vcStack{
//    NSLog(@"%@",vcStack);
    static NSString *lastVCMore = nil;
    if (vcStack.count > 0) {
        NSString *curVC = [vcStack lastObject];
        if (!lastVCMore) {
            [self.topologyMore appendString:[self getVcIdentity:curVC]];
        }
        if (lastVCMore && lastVCMore.length > 0 && ![lastVCMore isEqualToString:curVC]) {
            [self.topologyMore appendFormat:@",%@",[self getVcIdentity:curVC]];
        }
        lastVCMore = curVC;
    }
//    NSLog(@"👌%@",self.topologyMore);
}

- (NSString *)unionSuffix:(NSString *)unionVC topology:(NSString *)topology{
    if (unionVC.length <= 0 || topology.length <= 0) {
        return unionVC;
    }
    if (unionVC.length == topology.length) {
        if ([topology hasSuffix:unionVC]) {
            return unionVC;
        }
    }else{
        if ([topology hasSuffix:[@"," stringByAppendingString:unionVC]]) {
            return unionVC;
        }
    }
    
    NSRange range = [unionVC rangeOfString:@","];
    if (range.location != NSNotFound) {
        return [self unionSuffix:[unionVC substringFromIndex:range.location+1] topology:topology];
    }
    return unionVC;
}

@end
