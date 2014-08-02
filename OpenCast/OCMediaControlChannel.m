//
//  OCMediaControlChannel.m
//  OpenCast

#import "JSONKit.h"
#import "OCMediaControlChannel.h"
#import "OCMediaInformation.h"
#import "OCMediaMetadata.h"
#import "OCMediaStatus.h"

// Friend access to OCMediaInformation
@interface OCMediaInformation ()
@property (strong, nonatomic) NSString* contentID;
@end

// Friend access to OCCastChannel
@interface OCCastChannel ()
@property (strong, nonatomic) NSString* sourceId;
@property (strong, nonatomic) NSString* destinationId;
@property (weak, nonatomic) OCDeviceManager* deviceManager;
@end

// Friend access to OCDeviceManager
@interface OCDeviceManager ()
- (BOOL)sendTextMessage:(NSString*)message
              namespace:(NSString*)protocolNamespace
               sourceId:(NSString*)sourceId
          destinationId:(NSString*)destinationId;
@end

@interface OCMediaControlChannel ()
@property (strong, nonatomic) NSMutableDictionary* pendingRequests;
@property (strong, nonatomic) OCMediaStatus* mediaStatus;
@property (strong, nonatomic) OCMediaInformation* mediaInformation;
@property (assign, nonatomic) double currentStreamPosition;
@property (assign, nonatomic) int supportedMediaCommands;

@property (strong, nonatomic) NSString* contentID;
@property (assign, nonatomic) int streamType;
@property (strong, nonatomic) NSString* contentType;
@property (strong, nonatomic) OCMediaMetadata* metadata;
@property (assign, nonatomic) double streamDuration;
@property (strong, nonatomic) id customData;
@end

@implementation OCMediaControlChannel

NSString* const kOCMediaDefaultReceiverApplicationID = @"CC1AD845";

- (id)init {
    self = [super initWithNamespace:OpenCastNamespaceMedia];
    
    if (self) {
        self.pendingRequests = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)didReceiveTextMessage:(NSString *)message
{
    NSDictionary* const dict = [message objectFromJSONString];
    NSArray* const statusArray = dict[@"status"];
    const NSInteger requestId = [dict[@"requestId"] integerValue];
    const BOOL isMediaStatus = [dict[@"type"] isEqualToString:@"MEDIA_STATUS"];
    const BOOL isMediaFailure = [dict[@"type"] isEqualToString:@"LOAD_FAILED"];
    
    if ([dict count]) {
        NSDictionary* statusDict = statusArray.firstObject; // TODO: Handle multiple media sessions
        
        NSDictionary* const mediaDict = statusDict[@"media"];
        
        self.contentID      = mediaDict[@"contentId"]              ?: self.contentID;
        self.streamType     = [mediaDict[@"streamType"] intValue]  ?: self.streamType;
        self.contentType    = mediaDict[@"contentType"]            ?: self.contentType;
        self.metadata       = mediaDict[@"metadata"]               ?: self.metadata;
        self.streamDuration = [mediaDict[@"duration"] doubleValue] ?: self.streamDuration;
        
        self.mediaInformation = [[OCMediaInformation alloc] initWithContentID:self.contentID
                                                                   streamType:self.streamType
                                                                  contentType:self.contentType
                                                                     metadata:self.metadata
                                                               streamDuration:self.streamDuration
                                                                   customData:self.customData];
        
        self.mediaStatus = [[OCMediaStatus alloc] initWithSessionID:[statusDict[@"mediaSessionId"] intValue]
                                                   mediaInformation:self.mediaInformation];
        
        [self.mediaStatus setValue:@([statusDict[@"currentTime"] floatValue]) forKey:@"streamPosition"];
        [self.mediaStatus setValue:@([statusDict[@"playbackRate"] floatValue]) forKey:@"playbackRate"];
        [self.mediaStatus setValue:@([statusDict[@"playerState"] integerValue]) forKey:@"playerState"];
        [self.mediaStatus setValue:@([statusDict[@"volume"][@"level"] integerValue]) forKey:@"volume"];
        [self.mediaStatus setValue:@([statusDict[@"volume"][@"muted"] boolValue]) forKey:@"isMuted"];
        
        self.currentStreamPosition = [statusDict[@"currentTime"] doubleValue];
        self.supportedMediaCommands = [statusDict[@"supportedMediaCommands"] intValue];
        
        NSString* const requestType = self.pendingRequests[[NSNumber numberWithLong:requestId]];
        if (isMediaStatus && [requestType isEqualToString:@"LOAD"]) {
            [self.delegate mediaControlChannel:self didCompleteLoadWithSessionID:self.mediaStatus.mediaSessionID];
        } else if (isMediaFailure && [requestType isEqualToString:@"LOAD"]) {
            NSMutableDictionary* details = [NSMutableDictionary dictionary];
            [details setValue:@"Failed to load media" forKey:NSLocalizedDescriptionKey];
            
            NSError* error = [[NSError alloc] initWithDomain:@"load_failed" code:-1 userInfo:details];
            [self.delegate mediaControlChannel:self didFailToLoadMediaWithError:error];
        }
    }
    
    if (isMediaStatus) {
        [self.delegate mediaControlChannelDidUpdateStatus:self];
        [self.delegate mediaControlChannel:self requestDidCompleteWithID:requestId];
    }
}

- (NSInteger)loadMedia:(OCMediaInformation *)mediaInfo {
    return [self loadMedia:mediaInfo autoplay:NO playPosition:0.f customData:nil];
}

- (NSInteger)loadMedia:(OCMediaInformation *)mediaInfo autoplay:(BOOL)autoplay {
    return [self loadMedia:mediaInfo autoplay:autoplay playPosition:0.f customData:nil];
}

- (NSInteger)loadMedia:(OCMediaInformation *)mediaInfo
              autoplay:(BOOL)autoplay
          playPosition:(NSTimeInterval)playPosition {
    return [self loadMedia:mediaInfo autoplay:autoplay playPosition:playPosition customData:nil];
}

- (NSInteger)loadMedia:(OCMediaInformation *)mediaInfo
              autoplay:(BOOL)autoplay
          playPosition:(NSTimeInterval)playPosition
            customData:(id)customData {
    if (self.mediaStatus == nil) {
        return kOCInvalidRequestID;
    }
    
    const NSInteger requestId = [self generateRequestID];
    
    NSDictionary* messageDict = @{ @"type" : @"LOAD",
                                   @"media" : [self dictionaryFromMediaInformation:mediaInfo],
                                   @"autoplay" : @(autoplay),
                                   @"currentTime" : @(playPosition),
                                   @"requestId" : @(requestId) };
    
    [self addPendingRequest:@"LOAD" forRequestId:requestId];
    
    // TODO: Use customData somehow
    [self sendTextMessage:[messageDict JSONString]];
    
    return requestId;
}
    
- (NSDictionary*)dictionaryFromMediaInformation:(OCMediaInformation*)media {
    return @{ @"contentId" : media.contentID ?: @"",
              @"streamType" : @(media.streamType) ?: @"",
              @"contentType" : media.contentType ?: @"",
              @"metadata" : @{ }, // TODO media.metadata ?: [[OCMediaMetadata alloc] init],
              @"streamDuration" : @(media.streamDuration),
              @"customData" : media.customData ?: @{}
              };
}

- (NSInteger)pause {
    return [self pauseWithCustomData:nil];
}

- (NSInteger)pauseWithCustomData:(id)customData {
    if (self.mediaStatus == nil) {
        return kOCInvalidRequestID;
    }
    
    const NSInteger requestId = [self generateRequestID];
    
    NSDictionary* requestDict = @{ @"type" : @"PAUSE",
                                   @"mediaSessionId" : @(self.mediaStatus.mediaSessionID),
                                   @"requestId" : [self generateRequestNumber] };
    
    [self sendTextMessage:[requestDict JSONString]];
    
    return requestId;
}

- (NSInteger)stop {
    return [self stopWithCustomData:nil];
}

- (NSInteger)stopWithCustomData:(id)customData {
    if (self.mediaStatus == nil) {
        return kOCInvalidRequestID;
    }
    
    const NSInteger requestId = [self generateRequestID];
    
    // TODO: Use custom data somehow
    NSDictionary* requestDict = @{ @"type" : @"STOP",
                                   @"mediaSessionId" : @(self.mediaStatus.mediaSessionID),
                                   @"requestId" : [self generateRequestNumber] };
    
    [self sendTextMessage:[requestDict JSONString]];
    
    return requestId;
}

- (NSInteger)play {
    if (self.mediaStatus == nil) {
        return kOCInvalidRequestID;
    }
    
    const NSInteger requestId = [self generateRequestID];
    
    NSDictionary* requestDict = @{ @"type" : @"PLAY",
                                   @"mediaSessionId" : @(self.mediaStatus.mediaSessionID),
                                   @"requestId" : [self generateRequestNumber] };
    
    [self sendTextMessage:[requestDict JSONString]];
    
    return requestId;
}

- (NSInteger)playWithCustomData:(id)customData {
    if (self.mediaStatus == nil) {
        return kOCInvalidRequestID;
    }
    
    const NSInteger requestId = [self generateRequestID];
    
    return requestId;
}

- (NSInteger)seekToTimeInterval:(NSTimeInterval)timeInterval {
    return [self seekToTimeInterval:timeInterval resumeState:OCMediaControlChannelResumeStatePause customData:nil];
}

- (NSInteger)seekToTimeInterval:(NSTimeInterval)position
                    resumeState:(OCMediaControlChannelResumeState)resumeState {
    return [self seekToTimeInterval:position resumeState:resumeState customData:nil];
}

- (NSInteger)seekToTimeInterval:(NSTimeInterval)position
                    resumeState:(OCMediaControlChannelResumeState)resumeState
                     customData:(id)customData {
    if (self.mediaStatus == nil) {
        return kOCInvalidRequestID;
    }
    
    const NSInteger requestId = [self generateRequestID];
    
    // TODO
    NSDictionary* volumeDict = @{@"type" : @"SEEK",
                                 @"mediaSessionId" : @(self.mediaStatus.mediaSessionID),
                                 @"currentTime" : @(position),
                                 @"requestId" : [self generateRequestNumber] };
    
    [self.deviceManager sendTextMessage:[volumeDict JSONString]
                              namespace:OpenCastNamespaceMedia
                               sourceId:self.sourceId
                          destinationId:self.destinationId];
    
    return requestId;
}

- (NSInteger)setStreamVolume:(float)volume {
    return [self setStreamVolume:volume customData:nil];
}

- (NSInteger)setStreamVolume:(float)volume customData:(id)customData {
    // TODO: Use customData somehow
    if (self.mediaStatus == nil) {
        return kOCInvalidRequestID;
    }
    
    const NSInteger requestId = [self generateRequestID];
    
    NSDictionary* volumeDict = @{@"type" : @"SET_VOLUME",
                                 @"volume" : @{ @"level" : @(volume) },
                                 @"requestId" : @(requestId),
                                 @"mediaSessionId" : @(self.mediaStatus.mediaSessionID)};
    
    [self.deviceManager sendTextMessage:[volumeDict JSONString]
                              namespace:OpenCastNamespaceReceiver
                               sourceId:SourceIdDefault
                          destinationId:DestinationIdDefault];
    
    return requestId;
}

- (NSInteger)setStreamMuted:(BOOL)muted {
    return [self setStreamMuted:muted customData:nil];
}

- (NSInteger)setStreamMuted:(BOOL)muted customData:(id)customData {
    // TODO: Use customData somehow
    if (self.mediaStatus == nil) {
        return kOCInvalidRequestID;
    }
    
    const NSInteger requestId = [self generateRequestID];
    
    NSDictionary* volumeDict = @{@"type" : @"SET_VOLUME",
                                 @"volume" : @{ @"muted" : @(muted) },
                                 @"requestId" : @(requestId),
                                 @"mediaSessionId" : @(self.mediaStatus.mediaSessionID)};
    
    [self.deviceManager sendTextMessage:[volumeDict JSONString]
                              namespace:OpenCastNamespaceReceiver
                               sourceId:SourceIdDefault
                          destinationId:DestinationIdDefault];
    
    return requestId;
}

- (NSInteger)requestStatus {
    const NSInteger requestId = [self generateRequestID];
    
    NSDictionary* requestDict = @{@"type" : @"GET_STATUS",
                                  @"requestId" : @(requestId),
                                  @"mediaSessionId" : @(self.mediaStatus.mediaSessionID)};
    
    [self sendTextMessage:[requestDict JSONString]];
    
    return requestId;
}

- (NSTimeInterval)approximateStreamPosition {
    return self.currentStreamPosition;
}

#pragma mark - Private

- (void)addPendingRequest:(NSString*)requestType forRequestId:(NSInteger)requestId {
    self.pendingRequests[[NSNumber numberWithLong:requestId]] = requestType;
}

- (void)removePendingRequest:(NSString*)requestType forRequestId:(NSInteger)requestId {
    [self.pendingRequests removeObjectForKey:[NSNumber numberWithLong:requestId]];
}

- (void)didConnect {
    [self requestStatus];
}

@end
