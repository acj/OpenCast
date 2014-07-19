//
//  OCMediaControlChannel.h
//  OpenCast

#import <OpenCast/OpenCast.h>

@class OCMediaInformation;
@class OCMediaStatus;

@protocol OCMediaControlChannelDelegate;

/**
 * The receiver application ID for the Default Media Receiver.
 *
 * Any operations which apply to a currently active stream (play, pause, seek, stop, etc) require
 * a valid (that is, non-nil) media status, or they will return |kOCInvalidRequestID| and will
 * not send the request. A media status is requested automatically when the channel connects, is
 * included with a successful load completed respose, and can also be updated at any time.
 * The media status can also become nil at any time; this will happen if the channel is
 * temporarily disconnected, for example.
 *
 * In general when using this channel, media status changes should be monitored with
 * |mediaControlChannelDidUpdateStatus:|, and methods which act on streams should be called only
 * while the media status is non-nil.
 */
extern NSString *const kOCMediaDefaultReceiverApplicationID;

typedef NS_ENUM(NSInteger, OCMediaControlChannelResumeState) {
    /** A resume state indicating that the player state should be left unchanged. */
    OCMediaControlChannelResumeStateUnchanged = 0,
    
    /**
     * A resume state indicating that the player should be playing, regardless of its current
     * state.
     */
    OCMediaControlChannelResumeStatePlay = 1,
    
    /**
     * A resume state indicating that the player should be paused, regardless of its current
     * state.
     */
    OCMediaControlChannelResumeStatePause = 2,
};

/**
 * A CastChannel for media control operations.
 *
 * @ingroup MediaControl
 */
@interface OCMediaControlChannel : OCCastChannel

/**
 * The current media status, if any.
 */
@property(nonatomic, strong, readonly) OCMediaStatus *mediaStatus;

@property(nonatomic, weak) id<OCMediaControlChannelDelegate> delegate;

/**
 * Designated initializer.
 */
- (id)init;

/**
 * Loads and starts playback of a new media item.
 *
 * @param mediaInfo An object describing the media item to load.
 * @return The request ID, or kOCInvalidRequestID if the message could not be sent.
 */
- (NSInteger)loadMedia:(OCMediaInformation *)mediaInfo;

/**
 * Loads and optionally starts playback of a new media item.
 *
 * @param mediaInfo An object describing the media item to load.
 * @param autoplay Whether playback should start immediately.
 * @return The request ID, or kOCInvalidRequestID if the message could not be sent.
 */
- (NSInteger)loadMedia:(OCMediaInformation *)mediaInfo autoplay:(BOOL)autoplay;

/**
 * Loads and optionally starts playback of a new media item.
 *
 * @param mediaInfo An object describing the media item to load.
 * @param autoplay Whether playback should start immediately.
 * @param playPosition The initial playback position.
 * @return The request ID, or kOCInvalidRequestID if the message could not be sent.
 */
- (NSInteger)loadMedia:(OCMediaInformation *)mediaInfo
              autoplay:(BOOL)autoplay
          playPosition:(NSTimeInterval)playPosition;

/**
 * Loads and optionally starts playback of a new media item.
 *
 * @param mediaInfo An object describing the media item to load.
 * @param autoplay Whether playback should start immediately.
 * @param playPosition The initial playback position.
 * @param customData Custom application-specific data to pass along with the request.
 * @return The request ID, or kOCInvalidRequestID if the message could not be sent.
 */
- (NSInteger)loadMedia:(OCMediaInformation *)mediaInfo
              autoplay:(BOOL)autoplay
          playPosition:(NSTimeInterval)playPosition
            customData:(id)customData;

/**
 * Pauses playback of the current media item. Request will fail if there is no current media status.
 *
 * @return The request ID, or kOCInvalidRequestID if the message could not be sent.
 */
- (NSInteger)pause;

/**
 * Pauses playback of the current media item. Request will fail if there is no current media status.
 *
 * @param customData Custom application-specific data to pass along with the request.
 * @return The request ID, or kOCInvalidRequestID if the message could not be sent.
 */
- (NSInteger)pauseWithCustomData:(id)customData;

/**
 * Stops playback of the current media item. Request will fail if there is no current media status.
 *
 * @return The request ID, or kOCInvalidRequestID if the message could not be sent.
 */
- (NSInteger)stop;

/**
 * Stops playback of the current media item. Request will fail if there is no current media status.
 *
 * @param customData Custom application-specific data to pass along with the request.
 * @return The request ID, or kOCInvalidRequestID if the message could not be sent.
 */
- (NSInteger)stopWithCustomData:(id)customData;

/**
 * Begins (or resumes) playback of the current media item. Playback always begins at the
 * beginning of the stream. Request will fail if there is no current media status.
 * @return The request ID, or kOCInvalidRequestID if the message could not be sent.
 */
- (NSInteger)play;

/**
 * Begins (or resumes) playback of the current media item. Playback always begins at the
 * beginning of the stream. Request will fail if there is no current media status.
 *
 * @param customData Custom application-specific data to pass along with the request.
 * @return The request ID, or kOCInvalidRequestID if the message could not be sent.
 */
- (NSInteger)playWithCustomData:(id)customData;

/**
 * Seeks to a new time within the current media item. Request will fail if there is no current
 * media status.
 *
 * @param position The new time interval from the beginning of the stream.
 * @return The request ID, or kOCInvalidRequestID if the message could not be sent.
 */
- (NSInteger)seekToTimeInterval:(NSTimeInterval)timeInterval;

/**
 * Seeks to a new position within the current media item. Request will fail if there is no current
 * media status.
 *
 * @param position The new time interval from the beginning of the stream.
 * @param resumeState The action to take after the seek operation has finished.
 * @return The request ID, or kOCInvalidRequestID if the message could not be sent.
 */
- (NSInteger)seekToTimeInterval:(NSTimeInterval)position
                    resumeState:(OCMediaControlChannelResumeState)resumeState;

/**
 * Seeks to a new position within the current media item. Request will fail if there is no current
 * media status.
 *
 * @param position The time interval from the beginning of the stream.
 * @param resumeState The action to take after the seek operation has finished.
 * @param customData Custom application-specific data to pass along with the request.
 * @return The request ID, or kOCInvalidRequestID if the message could not be sent.
 */
- (NSInteger)seekToTimeInterval:(NSTimeInterval)position
                    resumeState:(OCMediaControlChannelResumeState)resumeState
                     customData:(id)customData;

/**
 * Sets the stream volume. Request will fail if there is no current media status.
 *
 * @param volume The new volume, in the range [0.0 - 1.0].
 * @return The request ID, or kOCInvalidRequestID if the message could not be sent.
 */
- (NSInteger)setStreamVolume:(float)volume;

/**
 * Sets the stream volume. Request will fail if there is no current media status.
 *
 * @param volume The new volume, in the range [0.0 - 1.0].
 * @param customData Custom application-specific data to pass along with the request.
 * @return The request ID, or kOCInvalidRequestID if the message could not be sent.
 */
- (NSInteger)setStreamVolume:(float)volume customData:(id)customData;

/**
 * Sets whether the stream is muted. Request will fail if there is no current media status.
 *
 * @param muted Whether the stream should be muted or unmuted.
 * @return The request ID, or kOCInvalidRequestID if the message could not be sent.
 */
- (NSInteger)setStreamMuted:(BOOL)muted;

/**
 * Sets whether the stream is muted. Request will fail if there is no current media status.
 *
 * @param muted Whether the stream should be muted or unmuted.
 * @param customData Custom application-specific data to pass along with the request.
 * @return The request ID, or kOCInvalidRequestID if the message could not be sent.
 */
- (NSInteger)setStreamMuted:(BOOL)muted customData:(id)customData;


/**
 * Requests updated media status information from the receiver.
 *
 * @return The request ID, or kOCInvalidRequestID if the message could not be sent.
 */
- (NSInteger)requestStatus;

/**
 * Returns the approximate stream position as calculated from the last received stream
 * information and the elapsed wall-time since that update.
 */
- (NSTimeInterval)approximateStreamPosition;

@end

@protocol OCMediaControlChannelDelegate <NSObject>

@optional

/**
 * Called when a request to load media has completed.
 *
 * @param mediaSessionId The unique media session ID that has been assigned to this media item.
 */
- (void)mediaControlChannel:(OCMediaControlChannel *)mediaControlChannel
didCompleteLoadWithSessionID:(NSInteger)sessionID;

/**
 * Called when a request to load media has failed.
 */
- (void)mediaControlChannel:(OCMediaControlChannel *)mediaControlChannel
didFailToLoadMediaWithError:(NSError *)error;

/**
 * Called when updated player status information is received.
 */
- (void)mediaControlChannelDidUpdateStatus:(OCMediaControlChannel *)mediaControlChannel;

/**
 * Called when updated media metadata is received.
 */
- (void)mediaControlChannelDidUpdateMetadata:(OCMediaControlChannel *)mediaControlChannel;

/**
 * Called when a request succeeds.
 *
 * @param requestID The request ID that failed. This is the ID returned when the request was made.
 */
- (void)mediaControlChannel:(OCMediaControlChannel *)mediaControlChannel
   requestDidCompleteWithID:(NSInteger)requestID;

/**
 * Called when a request fails.
 *
 * @param requestID The request ID that failed. This is the ID returned when the request was made.
 * @param error The error. If any custom data was associated with the error, it will be in the
 * error's userInfo dictionary with the key {@code kOCErrorCustomDataKey}.
 */
- (void)mediaControlChannel:(OCMediaControlChannel *)mediaControlChannel
       requestDidFailWithID:(NSInteger)requestID
                      error:(NSError *)error;

@end
