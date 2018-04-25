
typedef enum {
    MMLanScannerStatusFinished,
    MMLanScannerStatusCancelled
} MMLanScannerStatus;

#import <Foundation/Foundation.h>

@class Device;

@protocol MMLANScannerDelegate;

#pragma mark - MMLANScanner Protocol
@protocol MMLANScannerDelegate <NSObject>
@required

- (void)lanScanDidFindNewDevice:(Device*)device;

- (void)lanScanDidFinishScanningWithStatus:(MMLanScannerStatus)status;

- (void)lanScanDidFailedToScan;

@optional

- (void)lanScanProgressPinged:(float)pingedHosts from:(NSInteger)overallHosts;

@end

#pragma mark - Public methods
@interface MMLANScanner : NSObject

@property (nonatomic, weak) id<MMLANScannerDelegate> delegate;

- (instancetype)initWithDelegate:(id<MMLANScannerDelegate>)delegate;

@property (nonatomic, assign, readonly) BOOL isScanning;

- (void)start;

- (void)stop;

@end
