
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, FLEXObjectExplorerSection) {
    FLEXObjectExplorerSectionDescription,
    FLEXObjectExplorerSectionCustom,
    FLEXObjectExplorerSectionProperties,
    FLEXObjectExplorerSectionIvars,
    FLEXObjectExplorerSectionMethods,
    FLEXObjectExplorerSectionClassMethods,
    FLEXObjectExplorerSectionSuperclasses,
    FLEXObjectExplorerSectionReferencingInstances
};

@interface FLEXObjectExplorerViewController : UITableViewController

@property (nonatomic, strong) id object;

- (NSString *)customSectionTitle;
- (NSArray *)customSectionRowCookies;
- (NSString *)customSectionTitleForRowCookie:(id)rowCookie;
- (NSString *)customSectionSubtitleForRowCookie:(id)rowCookie;
- (BOOL)customSectionCanDrillIntoRowWithCookie:(id)rowCookie;
- (UIViewController *)customSectionDrillInViewControllerForRowCookie:(id)rowCookie;

- (BOOL)canHaveInstanceState;
- (BOOL)canCallInstanceMethods;
- (BOOL)shouldShowDescription;
- (NSArray *)possibleExplorerSections;

@end
