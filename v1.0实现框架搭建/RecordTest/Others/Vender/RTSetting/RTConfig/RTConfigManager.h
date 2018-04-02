//
//  RTConfigManager.h
//  CJOL
//
//  Created by mac on 2018/4/1.
//  Copyright © 2018年 SuDream. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RTConfigManager : NSObject

@property (nonatomic,assign)NSInteger autoDeleteDay;//录制截图多少天后自动清除
@property (nonatomic,assign)BOOL isAutoDelete;
@property (nonatomic,assign)CGFloat compressionQuality;//录制过程屏幕截图的压缩率

+ (RTConfigManager *)shareInstance;

@end
