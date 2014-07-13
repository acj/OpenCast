// Copyright 2013 Google Inc.

#import <Foundation/Foundation.h>

@class OCApplicationMetadata;
@class OCDevice;
@class OCCastChannel;
@class OCReceiverControlChannel;

@protocol OCDeviceManagerDelegate;

/**
 * Controls a Cast device. This class can send messages to, receive messages from, launch, and
 * close applications running on a Cast device.
 *
 * @ingroup DeviceControl
 */
@interface OCDeviceManager : NSObject

/**
 * True if the device manager has established a connection to the device.
 */
@property(nonatomic, readonly) BOOL isConnected;

/**
 * True if the device manager has established a connection to an application on the device.
 */
@property(nonatomic, readonly) BOOL isConnectedToApp;

/**
 * True if the device manager is disconnected due to a potentially transient event (e.g. the app is
 * backgrounded, or there was a network error which might be solved by reconnecting). Note that the
 * disconnection/connection callbacks will not be called while the device manager attemps to
 * reconnect after a potentially transient event, but the properties will always reflect the
 * actual current state and can be observed.
 */
@property(nonatomic, readonly) BOOL isReconnecting;

/**
 * Reconnection will be attempted for this long in the event that the socket disconnects with a
 * potentially transient error.
 *
 * The default timeout is 10s.
 */
@property(nonatomic) NSTimeInterval reconnectTimeout;

@property(nonatomic, readonly) OCDevice *device;

@property(nonatomic, weak) id<OCDeviceManagerDelegate> delegate;

/**
 * Designated initializer. Constructs a new OCDeviceManager with the given device.
 *
 * @param device The device to control.
 * @param clientPackageName The client package name.
 */
- (id)initWithDevice:(OCDevice *)device clientPackageName:(NSString *)clientPackageName;

#pragma mark Device connection

/**
 * Connects to the device.
 */
- (void)connect;

/**
 * Disconnects from the device.
 */
- (void)disconnect;

#pragma mark Channels

/**
 * Adds a channel which can send and receive messages for this device on a particular
 * namespace.
 *
 * @param channel The channel.
 * @return YES if the channel was added, NO if it was not added because there was already
 * a channel attached for that namespace.
 */
- (BOOL)addChannel:(OCCastChannel *)channel;

/**
 * Removes a previously added channel.
 *
 * @param channel The channel.
 * @return YES if the channel was removed, NO if it was not removed because the given
 * channel was not previously attached.
 */
- (BOOL)removeChannel:(OCCastChannel *)channel;

#pragma mark Applications

/**
 * Launches an application.
 *
 * @param applicationID The application ID.
 * @return NO if the message could not be sent.
 */
- (BOOL)launchApplication:(NSString *)applicationID;

/**
 * Launches an application, optionally relaunching it if it is already running.
 *
 * @param applicationID The application ID.
 * @param relaunchIfRunning If YES, relaunches the application if it is already running instead of
 * joining the running application.
 * @return NO if the message could not be sent.
 */
- (BOOL)launchApplication:(NSString *)applicationID
        relaunchIfRunning:(BOOL)relaunchIfRunning;

/**
 * Joins an application.
 *
 * @param applicationID The application ID.
 * @return NO if the message could not be sent.
 */
- (BOOL)joinApplication:(NSString *)applicationID;

/**
 * Joins an application with a particular session ID.
 *
 * @param applicationID The application ID.
 * @param sessionID The session ID.
 * @return NO if the message could not be sent.
 */
- (BOOL)joinApplication:(NSString *)applicationID sessionID:(NSString *)sessionID;

/**
 * Leaves the current application.
 *
 * @return NO if the message could not be sent.
 */
- (BOOL)leaveApplication;

/**
 * Stops any running application(s).
 *
 * @return NO if the message could not be sent.
 */
- (BOOL)stopApplication;

/**
 * Stops the application with the given session ID. Session ID must be non-negative.
 *
 * @param sessionID The session ID.
 * @return NO if the message could not be sent.
 */
- (BOOL)stopApplicationWithSessionID:(NSString *)sessionID;

#pragma mark Device status

/**
 * Sets the system volume.
 *
 * @param volume The new volume, in the range [0.0, 1.0]. Out of range values will be silently
 * clipped.
 * @return NO if the message could not be sent.
 */
- (BOOL)setVolume:(float)volume;

/**
 * Turns muting on or off.
 *
 * @param muted Whether audio should be muted or unmuted.
 * @return NO if the message could not be sent.
 */
- (BOOL)setMuted:(BOOL)muted;

/**
 * Requests the device's current status. This may cause an application status callback, if
 * currently connected to an application, and may cause a device volume callback, if the
 * device volume has changed.
 *
 * @return NO if the message could not be sent.
 */
- (BOOL)requestDeviceStatus;

@end

#pragma mark -

/**
 * The delegate for OCDeviceManager notifications.
 *
 * @ingroup DeviceControl
 */
@protocol OCDeviceManagerDelegate <NSObject>

@optional

#pragma mark Device connection callbacks

/**
 * Called when a connection has been established to the device.
 *
 * @param deviceManager The device manager.
 */
- (void)deviceManagerDidConnect:(OCDeviceManager *)deviceManager;

/**
 * Called when the connection to the device has failed.
 *
 * @param deviceManager The device manager.
 * @param error The error that caused the connection to fail.
 */
- (void)deviceManager:(OCDeviceManager *)deviceManager
didFailToConnectWithError:(NSError *)error;

/**
 * Called when the connection to the device has been terminated.
 *
 * @param deviceManager The device manager.
 * @param error The error that caused the disconnection; nil if there was no error (e.g. intentional
 * disconnection).
 */
- (void)deviceManager:(OCDeviceManager *)deviceManager
didDisconnectWithError:(NSError *)error;

#pragma mark Application connection callbacks

/**
 * Called when an application has been launched or joined.
 *
 * @param applicationMetadata Metadata about the application.
 * @param sessionID The session ID.
 * @param launchedApplication YES if the application was launched as part of the connection, or NO
 * if the application was already running and was joined.
 */
- (void)deviceManager:(OCDeviceManager *)deviceManager
didConnectToCastApplication:(OCApplicationMetadata *)applicationMetadata
            sessionID:(NSString *)sessionID
  launchedApplication:(BOOL)launchedApplication;

/**
 * Called when connecting to an application fails.
 *
 * @param deviceManager The device manager.
 * @param error The error that caused the failure.
 */
- (void)deviceManager:(OCDeviceManager *)deviceManager
didFailToConnectToApplicationWithError:(NSError *)error;

/**
 * Called when disconnected from the current application.
 */
- (void)deviceManager:(OCDeviceManager *)deviceManager
didDisconnectFromApplicationWithError:(NSError *)error;

/**
 * Called when a stop application request fails.
 *
 * @param deviceManager The device manager.
 * @param error The error that caused the failure.
 */
- (void)deviceManager:(OCDeviceManager *)deviceManager
didFailToStopApplicationWithError:(NSError *)error;

#pragma mark Device status callbacks

/**
 * Called whenever updated status information is received.
 *
 * @param applicationMetadata The application metadata.
 */
- (void)deviceManager:(OCDeviceManager *)deviceManager
didReceiveStatusForApplication:(OCApplicationMetadata *)applicationMetadata;

/**
 * Called whenever the volume changes.
 *
 * @param volumeLevel The current device volume level.
 * @param isMuted The current device mute state.
 */
- (void)deviceManager:(OCDeviceManager *)deviceManager
volumeDidChangeToLevel:(float)volumeLevel
              isMuted:(BOOL)isMuted;

@end
