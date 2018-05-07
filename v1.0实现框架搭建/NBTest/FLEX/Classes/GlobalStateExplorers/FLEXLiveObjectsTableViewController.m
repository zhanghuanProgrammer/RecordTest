
#import "FLEXLiveObjectsTableViewController.h"
#import "FLEXHeapEnumerator.h"
#import "FLEXInstancesTableViewController.h"
#import "FLEXUtility.h"
#import <objc/runtime.h>

static const NSInteger kFLEXLiveObjectsSortAlphabeticallyIndex = 0;
static const NSInteger kFLEXLiveObjectsSortByCountIndex = 1;

@interface FLEXLiveObjectsTableViewController () <UISearchBarDelegate>

@property (nonatomic, strong) NSDictionary *instanceCountsForClassNames;
@property (nonatomic, readonly) NSArray *allClassNames;
@property (nonatomic, strong) NSArray *filteredClassNames;
@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation FLEXLiveObjectsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.placeholder = [FLEXUtility searchBarPlaceholderText];
    self.searchBar.delegate = self;
    self.searchBar.showsScopeBar = YES;
    self.searchBar.scopeButtonTitles = @[@"Sort Alphabetically", @"Sort by Count"];
    [self.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchBar;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshControlDidRefresh:) forControlEvents:UIControlEventValueChanged];
    
    [self reloadTableData];
}

- (NSArray *)allClassNames
{
    return [self.instanceCountsForClassNames allKeys];
}

- (void)reloadTableData
{
    unsigned int classCount = 0;
    Class *classes = objc_copyClassList(&classCount);
    CFMutableDictionaryRef mutableCountsForClasses = CFDictionaryCreateMutable(NULL, classCount, NULL, NULL);
    for (unsigned int i = 0; i < classCount; i++) {
        CFDictionarySetValue(mutableCountsForClasses, (__bridge const void *)classes[i], (const void *)0);
    }
    
    [FLEXHeapEnumerator enumerateLiveObjectsUsingBlock:^(__unsafe_unretained id object, __unsafe_unretained Class actualClass) {
        NSUInteger instanceCount = (NSUInteger)CFDictionaryGetValue(mutableCountsForClasses, (__bridge const void *)actualClass);
        instanceCount++;
        CFDictionarySetValue(mutableCountsForClasses, (__bridge const void *)actualClass, (const void *)instanceCount);
    }];
    
    NSMutableDictionary *mutableCountsForClassNames = [NSMutableDictionary dictionary];
    for (unsigned int i = 0; i < classCount; i++) {
        Class class = classes[i];
        NSUInteger instanceCount = (NSUInteger)CFDictionaryGetValue(mutableCountsForClasses, (__bridge const void *)(class));
        if (instanceCount > 0) {
            NSString *className = @(class_getName(class));
            [mutableCountsForClassNames setObject:@(instanceCount) forKey:className];
        }
    }
    free(classes);
    
    self.instanceCountsForClassNames = mutableCountsForClassNames;
    
    [self updateTableDataForSearchFilter];
}

- (void)refreshControlDidRefresh:(id)sender
{
    [self reloadTableData];
    [self.refreshControl endRefreshing];
}

- (void)updateTitle
{
    NSString *title = @"Live Objects";
    
    NSUInteger totalCount = 0;
    for (NSString *className in self.allClassNames) {
        totalCount += [self.instanceCountsForClassNames[className] unsignedIntegerValue];
    }
    NSUInteger filteredCount = 0;
    for (NSString *className in self.filteredClassNames) {
        filteredCount += [self.instanceCountsForClassNames[className] unsignedIntegerValue];
    }
    
    if (filteredCount == totalCount) {
        title = [title stringByAppendingFormat:@" (%lu)", (unsigned long)totalCount];
    } else {
        title = [title stringByAppendingFormat:@" (filtered, %lu)", (unsigned long)filteredCount];
    }
    
    self.title = title;
}


#pragma mark - Search

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self updateTableDataForSearchFilter];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    [self updateTableDataForSearchFilter];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBar endEditing:YES];
}

- (void)updateTableDataForSearchFilter
{
    if ([self.searchBar.text length] > 0) {
        NSPredicate *searchPreidcate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", self.searchBar.text];
        self.filteredClassNames = [self.allClassNames filteredArrayUsingPredicate:searchPreidcate];
    } else {
        self.filteredClassNames = self.allClassNames;
    }
    
    if (self.searchBar.selectedScopeButtonIndex == kFLEXLiveObjectsSortAlphabeticallyIndex) {
        self.filteredClassNames = [self.filteredClassNames sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    } else if (self.searchBar.selectedScopeButtonIndex == kFLEXLiveObjectsSortByCountIndex) {
        self.filteredClassNames = [self.filteredClassNames sortedArrayUsingComparator:^NSComparisonResult(NSString *className1, NSString *className2) {
            NSNumber *count1 = self.instanceCountsForClassNames[className1];
            NSNumber *count2 = self.instanceCountsForClassNames[className2];
            return [count2 compare:count1];
        }];
    }
    
    [self updateTitle];
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.filteredClassNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [FLEXUtility defaultTableViewCellLabelFont];
    }
    
    NSString *className = self.filteredClassNames[indexPath.row];
    NSNumber *count = self.instanceCountsForClassNames[className];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%ld)", className, (long)[count integerValue]];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *className = self.filteredClassNames[indexPath.row];
    FLEXInstancesTableViewController *instancesViewController = [FLEXInstancesTableViewController instancesTableViewControllerForClassName:className];
    [self.navigationController pushViewController:instancesViewController animated:YES];
}

@end
