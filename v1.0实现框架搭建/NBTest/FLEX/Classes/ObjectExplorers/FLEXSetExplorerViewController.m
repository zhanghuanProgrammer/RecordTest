
#import "FLEXSetExplorerViewController.h"
#import "FLEXRuntimeUtility.h"
#import "FLEXObjectExplorerFactory.h"

@interface FLEXSetExplorerViewController ()

@property (nonatomic, readonly) NSSet *set;

@end

@implementation FLEXSetExplorerViewController

- (NSSet *)set
{
    return [self.object isKindOfClass:[NSSet class]] ? self.object : nil;
}


#pragma mark - Superclass Overrides

- (NSString *)customSectionTitle
{
    return @"Set Objects";
}

- (NSArray *)customSectionRowCookies
{
    return [self.set allObjects];
}

- (NSString *)customSectionTitleForRowCookie:(id)rowCookie
{
    return [FLEXRuntimeUtility descriptionForIvarOrPropertyValue:rowCookie];
}

- (NSString *)customSectionSubtitleForRowCookie:(id)rowCookie
{
    return nil;
}

- (BOOL)customSectionCanDrillIntoRowWithCookie:(id)rowCookie
{
    return YES;
}

- (UIViewController *)customSectionDrillInViewControllerForRowCookie:(id)rowCookie
{
    return [FLEXObjectExplorerFactory explorerViewControllerForObject:rowCookie];
}

- (BOOL)shouldShowDescription
{
    return NO;
}

@end
