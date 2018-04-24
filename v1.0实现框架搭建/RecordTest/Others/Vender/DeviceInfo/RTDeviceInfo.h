
#import <Foundation/Foundation.h>

@interface RTDeviceInfo : NSObject

@property (nonatomic) float systemAvailableMemory; //系统可用内存
@property (nonatomic) float appMemory;             //app占用内存
@property (nonatomic) float systemCpu;             //系统占用cpu
@property (nonatomic) float appCpu;                //app占用cpu

+ (RTDeviceInfo *)shareInstance;
- (void)showDeviceInfo;

@end
