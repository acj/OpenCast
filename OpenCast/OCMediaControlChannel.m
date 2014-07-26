//
//  OCMediaControlChannel.m
//  OpenCast

#import "JSONKit.h"
#import "OCMediaControlChannel.h"
#import "OCMediaInformation.h"
#import "OCMediaMetadata.h"

// Friend access to OCMediaInformation
@interface OCMediaInformation ()
@property (strong, nonatomic) NSString* contentID;
@end

@interface OCCastChannel ()
@property (strong, nonatomic) NSString* sourceId;
@property (strong, nonatomic) NSString* destinationId;
@property (weak, nonatomic) OCDeviceManager* deviceManager;
@end

@interface OCDeviceManager ()
- (BOOL)sendTextMessage:(NSString*)message namespace:(NSString*)protocolNamespace sourceId:(NSString*)sourceId destinationId:(NSString*)destinationId;
@end

@implementation OCMediaControlChannel

NSString* const kOCMediaDefaultReceiverApplicationID = @"CC1AD845";

- (id)init {
    return [super initWithNamespace:OpenCastNamespaceMedia];
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
    const NSInteger requestId = [self generateRequestID];
    
    NSString* mediaJson = [[self dictionaryFromMediaInformation:mediaInfo] JSONString];
    NSLog(@"Media: %@", mediaJson);
    
    NSDictionary* messageDict = @{ @"type" : @"LOAD",
                                   @"media" : [self dictionaryFromMediaInformation:mediaInfo],
                                   @"autoplay" : @(autoplay),
                                   @"currentTime" : @(playPosition),
                                   @"requestId" : @(requestId) };
    
    // TODO: Use customData somehow
    [self sendTextMessage:[messageDict JSONString]];
    
    return requestId;
}
    
- (NSDictionary*)dictionaryFromMediaInformation:(OCMediaInformation*)media {
    return @{ @"contentId" : media.contentID ?: @"",
              @"streamType" : @(media.streamType) ?: @"",
              @"contentType" : media.contentType ?: @"",
              @"metadata" : @{ }, //media.metadata ?: [[OCMediaMetadata alloc] init],
              @"streamDuration" : @(media.streamDuration),
              @"customData" : media.customData ?: @{}
              };
}

- (NSInteger)pause {
    const NSInteger requestId = [self generateRequestID];
    
    return requestId;
}

- (NSInteger)pauseWithCustomData:(id)customData {
    const NSInteger requestId = [self generateRequestID];
    
    return requestId;
}

- (NSInteger)stop {
    const NSInteger requestId = [self generateRequestID];
    
    return requestId;
}

- (NSInteger)stopWithCustomData:(id)customData {
    const NSInteger requestId = [self generateRequestID];
    
    return requestId;
}

- (NSInteger)play {
    const NSInteger requestId = [self generateRequestID];
    
    [self sendTextMessage:[@{ @"type" : @"PLAY" } JSONString]];
    
    return requestId;
}

- (NSInteger)playWithCustomData:(id)customData {
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
    const NSInteger requestId = [self generateRequestID];
    
    // TODO
    
    return requestId;
}

- (NSInteger)setStreamVolume:(float)volume {
    return [self setStreamVolume:volume customData:nil];
}

- (NSInteger)setStreamVolume:(float)volume customData:(id)customData {
    // TODO: Use customData somehow
    const NSInteger requestId = [self generateRequestID];
    
    NSDictionary* volumeDict = @{@"type" : @"SET_VOLUME",
                                 @"volume" : @{ @"level" : @(volume) } };
    
    [self.deviceManager sendTextMessage:[volumeDict JSONString]
                              namespace:OpenCastNamespaceReceiver
                               sourceId:self.sourceId
                          destinationId:DestinationIdDefault];
    
    return requestId;
}

- (NSInteger)setStreamMuted:(BOOL)muted {
    return [self setStreamMuted:muted customData:nil];
}

- (NSInteger)setStreamMuted:(BOOL)muted customData:(id)customData {
    // TODO: Use customData somehow
    const NSInteger requestId = [self generateRequestID];
    
    NSDictionary* volumeDict = @{@"type" : @"SET_VOLUME",
                                 @"volume" : @{ @"muted" : @(muted) } };
    
    [self.deviceManager sendTextMessage:[volumeDict JSONString]
                              namespace:OpenCastNamespaceReceiver
                               sourceId:self.sourceId
                          destinationId:DestinationIdDefault];
    
    return requestId;
}

- (NSInteger)requestStatus {
    const NSInteger requestId = [self generateRequestID];
    
    return requestId;
}

- (NSTimeInterval)approximateStreamPosition {
    const NSInteger requestId = [self generateRequestID];
    
    return requestId;
}

@end
