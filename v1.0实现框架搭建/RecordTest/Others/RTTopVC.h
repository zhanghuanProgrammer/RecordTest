//
//  RTTopVC.h
//  CJOL
//
//  Created by mac on 2018/3/25.
//  Copyright © 2018年 SuDream. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RTTopVC : NSObject

+ (RTTopVC *)shareInstance;
- (void)hookTopVC;

@property (nonatomic,copy)NSString *topVC;

@end
