//
//  OCReceiverControlChannel.m
//  OpenCast

#import "JSONKit.h"
#import "OCReceiverController.h"

@interface OCReceiverController ()
@property (strong, nonatomic) OCMediaControlChannel* mediaChannel;
@property (assign, nonatomic) BOOL isCasting;
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

@implementation OCReceiverController

+ (id)init {
    return [[OCReceiverController alloc] initWithNamespace:OpenCastNamespaceReceiver];
}

- (void)didReceiveTextMessage:(NSString *)message
{
    NSDictionary* messageJson = [message objectFromJSONString];
    BOOL readyToCast = NO;
    
    if ([messageJson[@"type"] isEqualToString:@"RECEIVER_STATUS"]) {
        NSArray* applications = [[messageJson objectForKey:@"status"] objectForKey:@"applications"];
        NSDictionary* appDict = applications[0];
        
        if (appDict) {
            readyToCast = [appDict[@"statusText"] isEqualToString:@"Ready To Cast"];
            
            if (!appDict[@"isStandby"]) {
                self.transportId = appDict[@"transportId"];
            }
        }
    }
    
    if (!self.isCasting && self.transportId && readyToCast) {
        // Connect to the application
        // TODO: Generate the sourceId
        [self.deviceManager sendTextMessage:@"{\"type\":\"CONNECT\"}" namespace:OpenCastNamespaceConnection sourceId:@"client-1234" destinationId:self.transportId];
        
        self.mediaChannel = [[OCMediaControlChannel alloc] init];
        [self.mediaChannel setSourceId:@"client-1234"];
        [self.mediaChannel setDestinationId:self.transportId];
        [self.deviceManager addChannel:self.mediaChannel];
        
        NSString* url = @"http://commondatastorage.googleapis.com/gtv-videos-bucket/ED_1280.mp4";
        OCMediaInformation* media = [[OCMediaInformation alloc] initWithContentID:url
                                                                       streamType:OCMediaStreamTypeBuffered
                                                                      contentType:@"video/mp4"
                                                                         metadata:nil
                                                                   streamDuration:1000.f
                                                                       customData:nil];
        
        [self.mediaChannel loadMedia:media autoplay:YES];
        
        self.isCasting = YES;
    }
}

@end
