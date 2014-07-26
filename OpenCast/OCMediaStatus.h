//
//  OCMediaStatus.h
//  OpenCast

#import <Foundation/Foundation.h>

@class OCMediaInformation;

/** A flag (bitmask) indicating that a media item can be paused. */
extern const NSInteger kOCMediaCommandPause;

/** A flag (bitmask) indicating that a media item supports seeking. */
extern const NSInteger kOCMediaCommandSeek;

/** A flag (bitmask) indicating that a media item's audio volume can be changed. */
extern const NSInteger kOCMediaCommandSetVolume;

/** A flag (bitmask) indicating that a media item's audio can be muted. */
extern const NSInteger kOCMediaCommandToggleMute;

/** A flag (bitmask) indicating that a media item supports skipping forward. */
extern const NSInteger kOCMediaCommandSkipForward;

/** A flag (bitmask) indicating that a media item supports skipping backward. */
extern const NSInteger kOCMediaCommandSkipBackward;

typedef NS_ENUM(NSInteger, OCMediaPlayerState) {
    /** Constant indicating unknown player state. */
    OCMediaPlayerStateUnknown = 0,
    /** Constant indicating that the media player is idle. */
    OCMediaPlayerStateIdle = 1,
    /** Constant indicating that the media player is playing. */
    OCMediaPlayerStatePlaying = 2,
    /** Constant indicating that the media player is paused. */
    OCMediaPlayerStatePaused = 3,
    /** Constant indicating that the media player is buffering. */
    OCMediaPlayerStateBuffering = 4,
};

typedef NS_ENUM(NSInteger, OCMediaPlayerIdleReason) {
    /** Constant indicating that the player currently has no idle reason. */
    OCMediaPlayerIdleReasonNone = 0,
    
    /** Constant indicating that the player is idle because playback has finished. */
    OCMediaPlayerIdleReasonFinished = 1,
    
    /**
     * Constant indicating that the player is idle because playback has been cancelled in
     * response to a STOP command.
     */
    OCMediaPlayerIdleReasonCancelled = 2,
    
    /**
     * Constant indicating that the player is idle because playback has been interrupted by
     * a LOAD command.
     */
    OCMediaPlayerIdleReasonInterrupted = 3,
    
    /** Constant indicating that the player is idle because a playback error has occurred. */
    OCMediaPlayerIdleReasonError = 4,
};

/**
 * A class that holds status information about some media.
 */
@interface OCMediaStatus : NSObject

/**
 * The media session ID for this item.
 */
@property(nonatomic, readonly) NSInteger mediaSessionID;

/**
 * The current player state.
 */
@property(nonatomic, readonly) OCMediaPlayerState playerState;

/**
 * The current idle reason. This value is only meaningful if the player state is
 * OCMediaPlayerStateIdle.
 */
@property(nonatomic, readonly) OCMediaPlayerIdleReason idleReason;

/**
 * Gets the current stream playback rate. This will be negative if the stream is seeking
 * backwards, 0 if the stream is paused, 1 if the stream is playing normally, and some other
 * postive value if the stream is seeking forwards.
 */
@property(nonatomic, readonly) float playbackRate;

/**
 * The OCMediaInformation for this item.
 */
@property(nonatomic, strong, readonly) OCMediaInformation *mediaInformation;

/**
 * The current stream position, as an NSTimeInterval from the start of the stream.
 */
@property(nonatomic, readonly) NSTimeInterval streamPosition;

/**
 * The stream's volume.
 */
@property(nonatomic, readonly) float volume;

/**
 * The stream's mute state.
 */
@property(nonatomic, readonly) BOOL isMuted;

/**
 * Any custom data that is associated with the media item.
 */
@property(nonatomic, strong, readonly) id customData;

/**
 * Designated initializer.
 *
 * @param mediaSessionID The media session ID.
 * @param mediaInformation The media information.
 */
- (id)initWithSessionID:(NSInteger)mediaSessionID
       mediaInformation:(OCMediaInformation *)mediaInformation;

/**
 * Checks if the stream supports a given control command.
 */
- (BOOL)isMediaCommandSupported:(NSInteger)command;

@end
