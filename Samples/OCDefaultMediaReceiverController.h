//
//  OCReceiverController.h
//  OpenCast

#import <OpenCast/OpenCast.h>

@protocol OCDefaultMediaReceiverControllerDelegate;

@interface OCDefaultMediaReceiverController : OCCastChannel

@property (weak, nonatomic) id<OCDefaultMediaReceiverControllerDelegate> delegate;

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
- (void)mediaReceiverController:(OCDefaultMediaReceiverController*)controller mediaStatusDidUpdate:(OCMediaStatus*)mediaStatus;
@end