

#import <Foundation/Foundation.h>

#if TARGET_OS_EMBEDDED || TARGET_IPHONE_SIMULATOR
#import <CFNetwork/CFNetwork.h>
#else
#import <CoreServices/CoreServices.h>
#endif

#include <AssertMacros.h>

#pragma mark* SimplePing

@protocol SimplePingDelegate;

@interface SimplePing : NSObject

+ (SimplePing*)simplePingWithHostName:(NSString*)hostName;
+ (SimplePing*)simplePingWithHostAddress:(NSData*)hostAddress;

@property (nonatomic, weak, readwrite) id<SimplePingDelegate> delegate;

@property (nonatomic, copy, readonly) NSString* hostName;

@property (nonatomic, copy, readonly) NSData* hostAddress;

@property (nonatomic, assign, readonly) uint16_t identifier;

@property (nonatomic, assign, readonly) uint16_t nextSequenceNumber;

- (void)start;

- (void)sendPingWithData:(NSData*)data;

- (void)stop;

+ (const struct ICMPHeader*)icmpInPacket:(NSData*)packet;

@end

@protocol SimplePingDelegate <NSObject>

@optional

- (void)simplePing:(SimplePing*)pinger didStartWithAddress:(NSData*)address;

- (void)simplePing:(SimplePing*)pinger didFailWithError:(NSError*)error;

- (void)simplePing:(SimplePing*)pinger didSendPacket:(NSData*)packet;

- (void)simplePing:(SimplePing*)pinger didFailToSendPacket:(NSData*)packet error:(NSError*)error;

- (void)simplePing:(SimplePing*)pinger didReceivePingResponsePacket:(NSData*)packet;

- (void)simplePing:(SimplePing*)pinger didReceiveUnexpectedPacket:(NSData*)packet;

@end

#pragma mark* IP and ICMP On-The-Wire Format

struct IPHeader {
    uint8_t versionAndHeaderLength;

    uint8_t differentiatedServices;

    uint16_t totalLength;

    uint16_t identification;

    uint16_t flagsAndFragmentOffset;

    uint8_t timeToLive;

    uint8_t protocol;

    uint16_t headerChecksum;

    uint8_t sourceAddress[4];

    uint8_t destinationAddress[4];
};

typedef struct IPHeader IPHeader;

enum {
    kICMPTypeEchoReply = 0,
    kICMPTypeEchoRequest = 8
};

struct ICMPHeader {
    uint8_t type;

    uint8_t code;

    uint16_t checksum;

    uint16_t identifier;

    uint16_t sequenceNumber;
};

typedef struct ICMPHeader ICMPHeader;
