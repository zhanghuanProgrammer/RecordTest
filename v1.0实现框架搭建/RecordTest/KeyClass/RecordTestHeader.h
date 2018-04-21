
#import "ReactiveObjC.h"
#import "UIView+RT.h"
#import "UIView+KVO.h"
#import "KVOAllView.h"
#import "AutoRecordTest.h"
#import "Aspects.h"
#import "UIView+RTLayerIndex.h"
#import "RTOperationQueue.h"
#import "RTCommandList.h"
#import "JohnAlertManager.h"
#import "RTInteraction.h"
#import "UIViewController+RT.h"
#import "RTTopVC.h"
#import "ZHStatusBarNotification.h"
#import "RTGetTargetView.h"
#import "RTDisPlayAllView.h"
#import "UIScrollView+RT.h"
#import "UIView+Frame.h"
#import "RTViewHierarchy.h"
#import "RTOperationImage.h"
#import "RTAutoRun.h"
#import "RTPlayBack.h"
#import "RTConfigManager.h"
#import "SimulationView.h"
#import "RTScreenRecorder.h"
#import "RTRecordVideo.h"
#import "RTOpenDataBase.h"
#import "RTSearchVCPath.h"
#import "RTLoginViewController.h"
#import "RTRegistViewController.h"
#import "RTForgetPasswordViewController.h"
#import "RTSystemClass.h"
#import "RTVCLearn.h"
#import "RTAutoJump.h"

#define Run 1

#define IsRecord 1
#define IsRunRecord !IsRecord

#define KVO_Tap 1
#define KVO_Event 1
#define KVO_Scroll 1
#define KVO_TextView 1
#define KVO_TextField 1
#define KVO_tableView_didSelectRowAtIndexPath 1
#define KVO_collectionView_didSelectRowAtIndexPath 1

#define KVO_Super 1
#define NeedSimilationView 0

#define CurrentAppThemeColor RGB(257,127,0)
