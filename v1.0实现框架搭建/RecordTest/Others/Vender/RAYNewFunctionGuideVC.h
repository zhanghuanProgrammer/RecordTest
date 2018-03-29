//
//  RAYNewFunctionGuideVC.h
//  hooray
//
//  Created by wbxiaowangzi on 16/2/23.
//  Copyright © 2016年 RAY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RAYNewFunctionGuideVC : UIViewController

@property (nonatomic, copy) NSString *titleGuide;
@property (nonatomic, assign) CGRect frameGuide;
@property (nonatomic,weak)UIView *targetView;

@end
