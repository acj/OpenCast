//
//  OCCastChannel.m
//  OpenCast

#import "OCCastChannel.h"
#import "OCConstants.h"
#import "OCDeviceManager.h"

const NSInteger kOCInvalidRequestID = -1;

@interface OCCastChannel ()
@property (strong, nonatomic) NSString* sourceId;
@property (strong, nonatomic) NSString* destinationId;
@property (weak, nonatomic) OCDeviceManager* deviceManager;
@property (assign, nonatomic) NSInteger nextRequestID;
@end

@interface OCDeviceManager ()
- (BOOL)sendTextMessage:(NSString*)message
              namespace:(NSString*)protocolNamespace
               sourceId:(NSString*)sourceId
          destinationId:(NSString*)destinationId;
@end

@implementation OCCastChannel

- (id)initWithNamespace:(NSString*)protocolNamespace {
    _protocolNamespace = protocolNamespace;
    _sourceId = SourceIdDefault;
    _destinationId = DestinationIdDefault;
    _nextRequestID = 1;
    
    return self;
}

- (void)didReceiveTextMessage:(NSString*)message {
    // Should be implemented by subclasses
}

- (BOOL)sendTextMessage:(NSString *)message {
    return [self.deviceManager sendTextMessage:message namespace:self.protocolNamespace sourceId:self.sourceId destinationId:self.destinationId];
}

- (NSInteger)generateRequestID {
    return self.nextRequestID++;
}

- (NSNumber *)generateRequestNumber {
    return @([self generateRequestID]);
}

- (void)didConnect {
    // Should be implemented by subclasses
}

- (void)didDisconnect {
    // Should be implemented by subclasses
}

@end
