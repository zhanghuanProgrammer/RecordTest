
#import "ReactiveObjC.h"
#import "UIView+RT.h"
#import "UIView+KVO.h"
#import "KVOAllView.h"
#import "AutoRecordTest.h"
#import "Aspects.h"
#import "UIView+RTLayerIndex.h"
#import "RTOperationQueue.h"

#define Run 0

#define IsRecord 1
#define IsRunRecord !IsRecord

#define KVO_Tap 1
#define KVO_Event 1
#define KVO_Scroll 1
#define KVO_TextView 1
#define KVO_TextField 1
#define KVO_tableView_didSelectRowAtIndexPath 1

#define KVO_Super 1
