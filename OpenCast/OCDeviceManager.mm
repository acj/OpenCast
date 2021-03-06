//
//  OCDeviceManager.m
//  OpenCast

#import "cast_channel.pb.h"
#import "coded_stream.h"
#import "JSONKit.h"
#import "OCCastChannel.h"
#import "OCConstants.h"
#import "OCDevice.h"
#import "OCDeviceManager.h"
#import "OCHeartbeatChannel.h"

using namespace google::protobuf::io;
using namespace extensions::api::cast_channel;

NSString* const TextMessageConnect = @"{\"type\":\"CONNECT\"}";
NSString* const TextMessageClose = @"{\"type\":\"CLOSE\"}";

@interface OCDeviceManager () <NSStreamDelegate>
@property (strong, nonatomic) NSMutableDictionary* channels;

@property (strong, nonatomic) NSInputStream* rawInputStream;
@property (strong, nonatomic) NSOutputStream* rawOutputStream;

@property (assign, nonatomic) BOOL readStreamIsConnected;
@property (assign, nonatomic) BOOL writeStreamIsConnected;

- (BOOL)sendTextMessage:(NSString*)message namespace:(NSString*)protocolNamespace;
@end

// Friend access to OCCastChannel
@interface OCCastChannel ()
@property (weak, nonatomic) OCDeviceManager* deviceManager;
@end

@implementation OCDeviceManager

- (id)initWithDevice:(OCDevice *)device clientPackageName:(NSString *)clientPackageName {
    self = [super init];
    
    if (self) {
        _device = device;
        _channels = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

#pragma mark Device connection

- (void)connect {
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL,
                                       (__bridge CFStringRef)self.device.ipAddress,
                                       self.device.servicePort,
                                       &readStream,
                                       &writeStream);
    
    NSDictionary *sslSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                 (id)kCFBooleanFalse, kCFStreamSSLValidatesCertificateChain,
                                 NSStreamSocketSecurityLevelSSLv3, NSStreamSocketSecurityLevelKey,
                                 nil];
    
    CFReadStreamSetProperty(readStream,
                            kCFStreamPropertySSLSettings,
                            (__bridge CFTypeRef)(sslSettings));
    
    self.rawInputStream = (__bridge_transfer NSInputStream *)readStream;
    self.rawOutputStream = (__bridge_transfer NSOutputStream *)writeStream;
    
    [self.rawInputStream setDelegate:self];
    [self.rawOutputStream setDelegate:self];
    [self.rawInputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.rawOutputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.rawInputStream open];
    [self.rawOutputStream open];
}

- (void)disconnect {
    [self.rawInputStream close];
    [self.rawOutputStream close];
    
    [self.delegate deviceManager:self didDisconnectWithError:nil];
}

- (BOOL)sendTextMessage:(NSString*)textMessage namespace:(NSString*)protocolNamespace {
    return [self sendTextMessage:textMessage namespace:protocolNamespace sourceId:SourceIdDefault destinationId:DestinationIdDefault];
}

- (BOOL)sendTextMessage:(NSString*)textMessage
              namespace:(NSString*)protocolNamespace
               sourceId:(NSString*)sourceId
          destinationId:(NSString*)destinationId {
    // TODO: Ensure that send buffer has available space
    if (self.isConnected) {
        CastMessage* message = new CastMessage();
        message->set_protocol_version(CastMessage_ProtocolVersion_CASTV2_1_0);
        message->set_source_id([sourceId cStringUsingEncoding:[NSString defaultCStringEncoding]]);
        message->set_destination_id([destinationId cStringUsingEncoding:[NSString defaultCStringEncoding]]);
        message->set_namespace_([protocolNamespace cStringUsingEncoding:[NSString defaultCStringEncoding]]);
        message->set_payload_type(CastMessage_PayloadType_STRING);
        message->set_payload_utf8([textMessage cStringUsingEncoding:NSUTF8StringEncoding]);
        
        std::string messageText = message->SerializeAsString();
        
        NSData* messageData = [NSData dataWithBytes:messageText.c_str() length:messageText.length()];
        
        uint32_t length = CFSwapInt32HostToBig((uint32_t)[messageData length]);
        [self.rawOutputStream write:(const uint8_t*)&length maxLength:sizeof(length)];
        [self.rawOutputStream write:(const unsigned char*)[messageData bytes] maxLength:[messageData length]];
        
        NSLog(@"Send [%@:%@:%@]: %@", [NSString stringWithCString:message->source_id().c_str() encoding:NSUTF8StringEncoding], [NSString stringWithCString:message->destination_id().c_str() encoding:NSUTF8StringEncoding], [NSString stringWithCString:message->namespace_().c_str() encoding:NSUTF8StringEncoding], [NSString stringWithCString:message->payload_utf8().c_str() encoding:NSUTF8StringEncoding]);
        
        return YES;
    } else {
        return NO;
    }
}

#pragma mark NSStreamDelegate

- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)eventCode {
    switch (eventCode) {
        case NSStreamEventNone:
        {
            break;
        }
        case NSStreamEventEndEncountered:
        {
            [self.rawInputStream close];
            [self.rawOutputStream close];
            break;
        }
        case NSStreamEventErrorOccurred:
        {
            NSMutableDictionary* details = [NSMutableDictionary dictionary];
            [details setValue:@"Failed to open stream" forKey:NSLocalizedDescriptionKey];
            NSError* error = [NSError errorWithDomain:@"stream" code:eventCode userInfo:details];
            [self.delegate deviceManager:self didFailToConnectWithError:error];
            break;
        }
        case NSStreamEventHasBytesAvailable:
        {
            const int WAITING_FOR_HEADER = 0;
            const int WAITING_FOR_MESSAGE = 1;

            const int HEADER_SIZE = 4;
            const int BUFFER_SIZE = 1024 * 4;
            
            static int readState = WAITING_FOR_HEADER;
            static int bytesInBuffer = 0;
            static uint32 messageLength = 0;
            static uint8_t* buffer = (uint8_t*)malloc(BUFFER_SIZE);

            if (readState == WAITING_FOR_HEADER) {
                while ([self.rawInputStream hasBytesAvailable] && bytesInBuffer < HEADER_SIZE) {
                    bytesInBuffer += [self.rawInputStream read:(buffer + bytesInBuffer) maxLength:HEADER_SIZE];
                }
                
                if (bytesInBuffer == HEADER_SIZE) {
                    readState = WAITING_FOR_MESSAGE;
                    
                    CodedInputStream* headerInputStream = new CodedInputStream(buffer, HEADER_SIZE);
                    headerInputStream->ReadRaw(&messageLength, HEADER_SIZE);
                    messageLength = CFSwapInt32BigToHost(messageLength);
                }
            }
            
            if (readState == WAITING_FOR_MESSAGE) {
                if ([self.rawInputStream hasBytesAvailable]) {
                    bytesInBuffer += [self.rawInputStream read:(buffer + bytesInBuffer)
                                                     maxLength:(messageLength - (bytesInBuffer - HEADER_SIZE))];
                }
            }
            
            if (bytesInBuffer == HEADER_SIZE + messageLength) {
                NSData* readData = [NSData dataWithBytes:buffer+HEADER_SIZE length:messageLength];

                CastMessage* readMessage = new CastMessage();
                readMessage->ParseFromArray([readData bytes], bytesInBuffer - HEADER_SIZE);
                
                if ([self.rawInputStream hasBytesAvailable]) {
                    NSLog(@"Warning: bytes available after message read");
                }
                
                NSString* namespaceString = [NSString stringWithCString:readMessage->namespace_().c_str() encoding:[NSString defaultCStringEncoding]];
                
                NSLog(@"Recv [%@]: %@", namespaceString, [NSString stringWithCString:readMessage->payload_utf8().c_str() encoding:NSUTF8StringEncoding]);
                if (namespaceString && self.channels[namespaceString]) {
                    [(OCCastChannel*)self.channels[namespaceString] didReceiveTextMessage:[NSString stringWithCString:readMessage->payload_utf8().c_str() encoding:[NSString defaultCStringEncoding]]];
                }
                
                readState = WAITING_FOR_HEADER;
                bytesInBuffer = 0;
                memset(buffer, 0, BUFFER_SIZE);
            }
            
            break;
        }
        case NSStreamEventHasSpaceAvailable:
        {
            if (!self.isConnected && self.readStreamIsConnected && self.writeStreamIsConnected) {
                _isConnected = YES;
                [self prepareBaseChannels];
                [self sendTextMessage:TextMessageConnect namespace:OpenCastNamespaceConnection];
                [self.delegate deviceManagerDidConnect:self];
            }
            
            break;
        }
        case NSStreamEventOpenCompleted:
        {
            if ([stream isKindOfClass:[NSInputStream class]]) {
                self.readStreamIsConnected = YES;
            } else if ([stream isKindOfClass:[NSOutputStream class]]) {
                self.writeStreamIsConnected = YES;
            }
            
            break;
        }
    }
}

#pragma mark Channels

- (BOOL)addChannel:(OCCastChannel *)channel {
    if ([self.channels objectForKey:channel.protocolNamespace]) {
        return NO;
    } else {
        self.channels[channel.protocolNamespace] = channel;
        channel.deviceManager = self;
        [channel didConnect];
        return YES;
    }
}

- (BOOL)removeChannel:(OCCastChannel *)channel {
    if ([self.channels objectForKey:channel.protocolNamespace]) {
        [self.channels removeObjectForKey:channel.protocolNamespace];
        [channel didDisconnect];
        channel.deviceManager = nil;
        return YES;
    } else {
        return NO;
    }
}

#pragma mark Applications

- (BOOL)launchApplication:(NSString *)applicationID {
    NSDictionary* messageDict = @{ @"type" : @"LAUNCH",
                                   @"appId" : applicationID,
                                   @"requestId" : [self.channels[OpenCastNamespaceHeartbeat] generateRequestNumber] };
    
    return [self.channels[OpenCastNamespaceReceiver] sendTextMessage:[messageDict JSONString]];
}

- (BOOL)launchApplication:(NSString *)applicationID
        relaunchIfRunning:(BOOL)relaunchIfRunning {
    // TODO
    return NO;
}

- (BOOL)joinApplication:(NSString *)applicationID {
    // TODO
    return NO;
}

- (BOOL)joinApplication:(NSString *)applicationID sessionID:(NSString *)sessionID {
    // TODO
    return NO;
}

- (BOOL)leaveApplication {
    // TODO
    return NO;
}

- (BOOL)stopApplication {
    NSDictionary* messageDict = @{ @"type" : @"STOP",
                                   @"requestId" : [self.channels[OpenCastNamespaceHeartbeat] generateRequestNumber] };
    return [self.channels[OpenCastNamespaceReceiver] sendTextMessage:[messageDict JSONString]];
}

- (BOOL)stopApplicationWithSessionID:(NSString *)sessionID {
    NSDictionary* messageDict = @{ @"type" : @"STOP",
                                   @"sessionId" : sessionID,
                                   @"requestId" : [self.channels[OpenCastNamespaceHeartbeat] generateRequestNumber] };
    return [self.channels[OpenCastNamespaceReceiver] sendTextMessage:[messageDict JSONString]];
}

#pragma mark Device status

- (BOOL)setVolume:(float)volume {
    NSDictionary* messageDict = @{ @"type" : @"SET_VOLUME",
                                   @"volume" : @{ @"level" : @(volume) } };
    return [self.channels[OpenCastNamespaceReceiver] sendTextMessage:[messageDict JSONString]];
}

- (BOOL)setMuted:(BOOL)muted {
    NSDictionary* messageDict = @{ @"type" : @"SET_VOLUME",
                                   @"volume" : @{ @"muted" : @(muted) } };
    return [self.channels[OpenCastNamespaceReceiver] sendTextMessage:[messageDict JSONString]];
}

- (BOOL)requestDeviceStatus {
    NSDictionary* messageDict = @{ @"type" : @"GET_STATUS" };
    return [self.channels[OpenCastNamespaceReceiver] sendTextMessage:[messageDict JSONString]];
}

#pragma mark Private

- (void)prepareBaseChannels {
    [self addChannel:[OCHeartbeatChannel init]];
}

@end