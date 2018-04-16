
#import "RTSystemClass.h"
#import <objc/runtime.h>

@interface RTSystemClass ()
@property (nonatomic,strong)NSMutableArray *defineClass;
@end

@implementation RTSystemClass

+ (RTSystemClass*)shareInstance{
    static dispatch_once_t pred = 0;
    __strong static RTSystemClass* _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[RTSystemClass alloc] init];
        _sharedObject.defineClass = [NSMutableArray array];
    });
    return _sharedObject;
}

- (NSArray *)getNoSystemClass{
    
    if (self.defineClass.count>0) {
        return self.defineClass;
    }
    
    //获取所有的已注册的类
    int count=objc_getClassList(NULL, 0);
    if (!count) return nil;
    [self.defineClass removeAllObjects];
    
    //分配存储内存
    Class objc=nil;
    Class *classes=(Class*)malloc(sizeof(Class)*count);
    
    //将已注册的类定义复制到classes的内存中
    objc_getClassList(classes, count);
    for (int i=0; i<count; i++) {
        objc=classes[i];
        if (objc == NULL) {
            continue;
        }
        if (![self isSystemClass:objc]) {
            [self.defineClass addObject:objc];
        }
    }
    //筛选自定义类
    free(classes);
    NSLog(@"%@",@"检查工程里面的所有自定义类--完成");
    
    return self.defineClass;
}

- (BOOL)isSystemClass:(Class)cls{
    return [NSBundle bundleForClass:cls] != [NSBundle mainBundle];
}

@end
