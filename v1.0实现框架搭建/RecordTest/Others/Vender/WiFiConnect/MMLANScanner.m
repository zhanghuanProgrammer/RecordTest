
#import "Device.h"
#import "LANProperties.h"
#import "MACOperation.h"
#import "MMLANScanner.h"
#import "MacFinder.h"
#import "PingOperation.h"

@interface MMLANScanner ()
@property (nonatomic, strong) Device* device;
@property (nonatomic, strong) NSArray* ipsToPing;
@property (nonatomic, assign) float currentHost;
@property (nonatomic, strong) NSDictionary* brandDictionary;
@property (nonatomic, strong) NSOperationQueue* queue;
@property (nonatomic, assign, readwrite) BOOL isScanning;
@end

@implementation MMLANScanner {
    BOOL isFinished;
    BOOL isCancelled;
}

#pragma mark - Initialization method
- (instancetype)initWithDelegate:(id<MMLANScannerDelegate>)delegate{

    self = [super init];

    if (self) {
        self.delegate = delegate;

        self.brandDictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"data" ofType:@"plist"]];

        self.queue = [[NSOperationQueue alloc] init];
        [self.queue setMaxConcurrentOperationCount:50];

        [self.queue addObserver:self forKeyPath:@"operations" options:0 context:nil];

        isFinished = NO;
        isCancelled = NO;
        self.isScanning = NO;
    }

    return self;
}

#pragma mark - Start/Stop ping
- (void)start{

    if (self.queue.operationCount != 0) {
        [self stop];
    }

    isFinished = NO;
    isCancelled = NO;
    self.isScanning = YES;

    self.device = [LANProperties localIPAddress];

    if (!self.device) {
        [self.delegate lanScanDidFailedToScan];
        return;
    }

    self.ipsToPing = [LANProperties getAllHostsForIP:self.device.ipAddress andSubnet:self.device.subnetMask];

    self.currentHost = 0;

    MMLANScanner* __weak weakSelf = self;

    for (NSString* ipStr in self.ipsToPing) {

        PingOperation* pingOperation = [[PingOperation alloc] initWithIPToPing:ipStr
                                                          andCompletionHandler:^(NSError* _Nullable error, NSString* _Nonnull ip) {
                                                              if (!weakSelf) {
                                                                  return;
                                                              }
                                                              weakSelf.currentHost = weakSelf.currentHost + 0.5;

                                                          }];

        MACOperation* macOperation = [[MACOperation alloc] initWithIPToRetrieveMAC:ipStr
                                                                andBrandDictionary:self.brandDictionary
                                                              andCompletionHandler:^(NSError* _Nullable error, NSString* _Nonnull ip, Device* _Nonnull device) {

                                                                  if (!weakSelf) {
                                                                      return;
                                                                  }

                                                                  weakSelf.currentHost = weakSelf.currentHost + 0.5;

                                                                  if (!error) {

                                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                                          if ([weakSelf.delegate respondsToSelector:@selector(lanScanDidFindNewDevice:)]) {
                                                                              [weakSelf.delegate lanScanDidFindNewDevice:device];
                                                                          }
                                                                      });
                                                                  }

                                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                                      if ([weakSelf.delegate respondsToSelector:@selector(lanScanProgressPinged:from:)]) {
                                                                          [weakSelf.delegate lanScanProgressPinged:self.currentHost from:[self.ipsToPing count]];
                                                                      }
                                                                  });
                                                              }];

        [macOperation addDependency:pingOperation];
        [self.queue addOperation:pingOperation];
        [self.queue addOperation:macOperation];
    }
}

- (void)stop{

    isCancelled = YES;
    [self.queue cancelAllOperations];
    [self.queue waitUntilAllOperationsAreFinished];
    self.isScanning = NO;
}

#pragma mark - NSOperationQueue Observer
- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context{

    if ([keyPath isEqualToString:@"operations"]) {

        if (self.queue.operationCount == 0 && isFinished == NO) {

            isFinished = YES;
            self.isScanning = NO;
            MMLanScannerStatus currentStatus = isCancelled ? MMLanScannerStatusCancelled : MMLanScannerStatusFinished;

            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.delegate respondsToSelector:@selector(lanScanDidFinishScanningWithStatus:)]) {
                    [self.delegate lanScanDidFinishScanningWithStatus:currentStatus];
                }
            });
        }
    }
}

#pragma mark - Dealloc
- (void)dealloc{
    [self.queue removeObserver:self forKeyPath:@"operations"];
}

@end
