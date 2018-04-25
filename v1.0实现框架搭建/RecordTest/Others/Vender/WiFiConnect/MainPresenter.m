
#import "Device.h"
#import "LANProperties.h"
#import "MMLANScanner.h"
#import "MainPresenter.h"

@interface MainPresenter () <MMLANScannerDelegate>

@property (nonatomic, weak) id<MainPresenterDelegate> delegate;
@property (nonatomic, strong) MMLANScanner* lanScanner;
@property (nonatomic, assign, readwrite) BOOL isScanRunning;
@property (nonatomic, assign, readwrite) float progressValue;
@end

@implementation MainPresenter {
    NSMutableArray* connectedDevicesMutable;
}

#pragma mark - Init method
- (instancetype)initWithDelegate:(id<MainPresenterDelegate>)delegate{
    self = [super init];
    if (self) {
        self.isScanRunning = NO;
        self.delegate = delegate;
        self.lanScanner = [[MMLANScanner alloc] initWithDelegate:self];
    }
    return self;
}

#pragma mark - Button Actions
- (void)scanButtonClicked{
    if (self.isScanRunning) {
        [self stopNetworkScan];
    } else {
        [self startNetworkScan];
    }
}
- (void)startNetworkScan{
    self.isScanRunning = YES;
    connectedDevicesMutable = [[NSMutableArray alloc] init];
    [self.lanScanner start];
};

- (void)stopNetworkScan{
    [self.lanScanner stop];
    self.isScanRunning = NO;
}

#pragma mark - SSID
- (NSString*)ssidName{
    return [NSString stringWithFormat:@"%@", [LANProperties fetchSSIDInfo]];
}

#pragma mark - MMLANScannerDelegate methods
- (void)lanScanDidFindNewDevice:(Device*)device{
    if (![connectedDevicesMutable containsObject:device]) {
        [connectedDevicesMutable addObject:device];
    }
    self.connectedDevices = [NSArray arrayWithArray:connectedDevicesMutable];
}

- (void)lanScanDidFinishScanningWithStatus:(MMLanScannerStatus)status{
    self.isScanRunning = NO;
    if (status == MMLanScannerStatusFinished) {
        [self.delegate mainPresenterIPSearchFinished];
    } else if (status == MMLanScannerStatusCancelled) {
        [self.delegate mainPresenterIPSearchCancelled];
    }
}

- (void)lanScanProgressPinged:(float)pingedHosts from:(NSInteger)overallHosts{
    self.progressValue = pingedHosts / overallHosts;
}

- (void)lanScanDidFailedToScan{
    self.isScanRunning = NO;
    [self.delegate mainPresenterIPSearchFailed];
}

@end
