
#import "RTTextPreVC.h"
#import "RTCrashLag.h"

@implementation RTTextPreVC

- (void)viewDidLoad{
    [super viewDidLoad];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-64)];
    textView.text = self.text;
    textView.editable = NO;
    [self.view addSubview:textView];
}

@end
