
#import <Foundation/Foundation.h>

@protocol FLEXDatabaseManager <NSObject>

@required
- (instancetype)initWithPath:(NSString*)path;

- (BOOL)open;
- (NSArray *)queryAllTables;
- (NSArray *)queryAllColumnsWithTableName:(NSString *)tableName;
- (NSArray *)queryAllDataWithTableName:(NSString *)tableName;

@end
