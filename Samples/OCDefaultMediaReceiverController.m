//
//  OCReceiverControlChannel.m
//  OpenCast

#import "JSONKit.h"
#import "OCDefaultMediaReceiverController.h"

@interface OCDefaultMediaReceiverController () <OCMediaControlChannelDelegate>
@property (strong, nonatomic) OCMediaControlChannel* mediaChannel;
@property (assign, nonatomic) BOOL applicationHasLaunched;
@property (strong, nonatomic) NSString* senderId;
@property (strong, nonatomic) NSString* transportId;
@end

@interface OCCastChannel ()
@property (strong, nonatomic) NSString* sourceId;
@property (strong, nonatomic) NSString* destinationId;
@property (strong, nonatomic) OCDeviceManager* deviceManager;
@end

@interface OCDeviceManager ()
- (BOOL)sendTextMessage:(NSString*)textMessage
              namespace:(NSString*)protocolNamespace
             sourceId:(NSString*)sourceId
               destinationId:(NSString*)destinationId;
@end

@implementation OCMediaReceiverApplication
@end

@implementation OCMediaReceiverStatus
@end

@implementation OCDefaultMediaReceiverController

+ (id)init {
    return [[OCDefaultMediaReceiverController alloc] initWithNamespace:OpenCastNamespaceReceiver];
}

- (id)initWithNamespace:(NSString *)protocolNamespace {
    self = [super initWithNamespace:protocolNamespace];
    
    if (self) {
        _status = [[OCMediaReceiverStatus alloc] init];
        _senderId = [self generateSenderId];
        
        _mediaChannel = [[OCMediaControlChannel alloc] init];
        _mediaChannel.delegate = self;
    }
    
    return self;
}

- (void)play {
    [self.mediaChannel play];
}

- (void)pause {
    [self.mediaChannel pause];
}

- (void)stop {
    [self.mediaChannel stop];
}

- (void)seekToPosition:(double)position {
    [self.mediaChannel seekToTimeInterval:position];
}

- (void)loadMediaFromURL:(NSString*)url {
    OCMediaInformation* media = [[OCMediaInformation alloc] initWithContentID:url
                                                                   streamType:OCMediaStreamTypeBuffered
                                                                  contentType:@"video/mp4"
                                                                     metadata:nil
                                                               streamDuration:0.f
                                                                   customData:nil];
    
    [self.mediaChannel loadMedia:media autoplay:NO];
}

- (void)setVolume:(double)volumeLevel {
    [self.mediaChannel setStreamVolume:volumeLevel];
}

- (void)mute:(BOOL)mute {
    [self.mediaChannel setStreamMuted:mute];
}

- (void)didReceiveTextMessage:(NSString *)message {
    NSDictionary* messageJson = [message objectFromJSONString];
    BOOL readyToCast = NO;
    
    if ([messageJson[@"type"] isEqualToString:@"RECEIVER_STATUS"]) {
        NSDictionary* const statusDict = messageJson[@"status"];
        
        self.status.isActiveInput = statusDict[@"isActiveInput"]    ? [statusDict[@"isActiveInput"] boolValue]     : self.status.isActiveInput;
        self.status.isStandBy     = statusDict[@"isStandBy"]        ? [statusDict[@"isStandBy"] boolValue]         : self.status.isStandBy;
        self.status.volumeLevel   = statusDict[@"volume"][@"level"] ? [statusDict[@"volume"][@"level"] floatValue] : self.status.volumeLevel;
        self.status.volumeMuted   = statusDict[@"volume"][@"muted"] ? [statusDict[@"volume"][@"muted"] boolValue]  : self.status.volumeMuted;
        
        NSArray* runningApplications = [[messageJson objectForKey:@"status"] objectForKey:@"applications"];
        
        if (runningApplications) {
            self.status.applications = [[NSMutableArray alloc] init];
            
            for (NSDictionary* appDict in runningApplications) {
                OCMediaReceiverApplication* app = [[OCMediaReceiverApplication alloc] init];
                
                app.appId = appDict[@"appId"];
                app.displayName = appDict[@"displayName"];
                app.namespaces = appDict[@"namespaces"];
                app.statusText = appDict[@"statusText"];
                app.transportId = appDict[@"transportId"];
                
                [self.status.applications addObject:app];
            }
        }
        
        
        OCMediaReceiverApplication* receiverApp = [self mediaReceiverApplication];
        if (receiverApp) {
            readyToCast = [receiverApp.statusText isEqualToString:@"Ready To Cast"];
            
            if (!self.status.isStandBy) {
                self.transportId = receiverApp.transportId;
            }
            
            [self.delegate mediaReceiverController:self statusDidUpdate:self.status];
        }
    } else if ([messageJson[@"type"] isEqualToString:@"LAUNCH_ERROR"]) {
        [self.delegate applicationFailedToLaunchWithError:messageJson[@"reason"]];
    }
    
    if (!self.applicationHasLaunched && self.transportId && readyToCast) {
        self.applicationHasLaunched = YES;
        
        // Connect to the application
        [self.deviceManager sendTextMessage:@"{\"type\":\"CONNECT\"}" namespace:OpenCastNamespaceConnection sourceId:self.senderId destinationId:self.transportId];
        
        [self.mediaChannel setSourceId:self.senderId];
        [self.mediaChannel setDestinationId:self.transportId];
        [self.deviceManager addChannel:self.mediaChannel];
        
        [self.delegate applicationDidLaunchSuccessfully];
    }
}

#pragma mark - OCMediaControlChannelDelegate

- (void)mediaControlChannel:(OCMediaControlChannel *)mediaControlChannel didCompleteLoadWithSessionID:(NSInteger)sessionID {
    [self.delegate mediaDidLoadSuccessfully];
}

- (void)mediaControlChannel:(OCMediaControlChannel *)mediaControlChannel didFailToLoadMediaWithError:(NSError *)error {
    // TODO
}

- (void)mediaControlChannel:(OCMediaControlChannel *)mediaControlChannel requestDidCompleteWithID:(NSInteger)requestID {
    // Ignore
}

- (void)mediaControlChannel:(OCMediaControlChannel *)mediaControlChannel requestDidFailWithID:(NSInteger)requestID error:(NSError *)error {
    // Ignore
}

- (void)mediaControlChannelDidUpdateMetadata:(OCMediaControlChannel *)mediaControlChannel {
    // Ignore
}

- (void)mediaControlChannelDidUpdateStatus:(OCMediaControlChannel *)mediaControlChannel {
    if (mediaControlChannel) {
        [self.delegate mediaReceiverController:self mediaStatusDidUpdate:mediaControlChannel.mediaStatus];
    }
}

#pragma mark - Private

- (NSString*)generateSenderId {
    return [NSString stringWithFormat:@"sender-%d", arc4random() % 99999];
}

- (OCMediaReceiverApplication*)mediaReceiverApplication {
    for (OCMediaReceiverApplication* app in self.status.applications) {
        if ( [app.appId isEqualToString:kOCMediaDefaultReceiverApplicationID]) {
            return app;
        }
    }
    
    return nil;
}

@end
