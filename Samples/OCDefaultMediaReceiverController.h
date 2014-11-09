//
//  OCReceiverController.h
//  OpenCast

#import <OpenCast/OpenCast.h>

@protocol OCDefaultMediaReceiverControllerDelegate;

@interface OCMediaReceiverApplication : NSObject
@property (strong, nonatomic) NSString* appId;
@property (strong, nonatomic) NSString* displayName;
@property (strong, nonatomic) NSArray* namespaces;
@property (strong, nonatomic) NSString* sessionId;
@property (strong, nonatomic) NSString* statusText;
@property (strong, nonatomic) NSString* transportId;
@end

@interface OCMediaReceiverStatus : NSObject
@property (assign, nonatomic) int lastRequestId;
@property (strong, nonatomic) NSMutableArray* applications;
@property (assign, nonatomic) BOOL isActiveInput;
@property (assign, nonatomic) BOOL isStandBy;
@property (assign, nonatomic) float volumeLevel;
@property (assign, nonatomic) BOOL volumeMuted;
@end

@interface OCDefaultMediaReceiverController : OCCastChannel

@property (weak, nonatomic) id<OCDefaultMediaReceiverControllerDelegate> delegate;
@property (strong, nonatomic, readonly) OCMediaReceiverStatus* status;
@property (strong, nonatomic, readonly) OCMediaStatus* mediaStatus;

+ (id)init;

- (void)play;
- (void)pause;
- (void)stop;
- (void)seekToPosition:(double)position;
- (void)loadMediaFromURL:(NSString*)url;
- (void)setVolume:(double)volumeLevel;
- (void)mute:(BOOL)mute;
    
@end

@protocol OCDefaultMediaReceiverControllerDelegate
- (void)applicationDidLaunchSuccessfully;
- (void)applicationFailedToLaunchWithError:(NSString*)reason;
- (void)mediaDidLoadSuccessfully;
- (void)mediaReceiverController:(OCDefaultMediaReceiverController*)controller statusDidUpdate:(OCMediaReceiverStatus*)receiverStatus;
- (void)mediaReceiverController:(OCDefaultMediaReceiverController*)controller mediaStatusDidUpdate:(OCMediaStatus*)mediaStatus;
@end