//
//  OCReceiverController.h
//  OpenCast

#import <OpenCast/OpenCast.h>

@protocol OCDefaultMediaReceiverControllerDelegate;

@interface OCDefaultMediaReceiverController : OCCastChannel

@property (weak, nonatomic) id<OCDefaultMediaReceiverControllerDelegate> delegate;

+ (id)init;

@end

@protocol OCDefaultMediaReceiverControllerDelegate
- (void)applicationDidLaunchSuccessfully;
- (void)applicationFailedToLaunchWithError:(NSString*)reason;
- (void)mediaDidLoadSuccessfully;
- (void)mediaReceiverController:(OCDefaultMediaReceiverController*)controller mediaStatusDidUpdate:(OCMediaStatus*)mediaStatus;
@end