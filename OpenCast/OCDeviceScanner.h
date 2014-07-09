// Copyright 2013 Google Inc.

#import <Foundation/Foundation.h>

@class OCDevice;
@protocol OCDeviceScannerListener;

/**
 * A class that (asynchronously) scans for available devices and sends corresponding notifications
 * to its listener(s). This class is implicitly a singleton; since it does a network scan, it isn't
 * useful to have more than one instance of it in use.
 *
 * @ingroup Discovery
 */
@interface OCDeviceScanner : NSObject

/** The array of discovered devices. */
@property(nonatomic, readonly, copy) NSArray *devices;

/** Whether the current/latest scan has discovered any devices. */
@property(nonatomic, readonly) BOOL hasDiscoveredDevices;

/** Whether a scan is currently in progress. */
@property(nonatomic, readonly) BOOL scanning;

/**
 * Designated initializer. Constructs a new OCDeviceScanner.
 */
- (id)init;

/**
 * Starts a new device scan. The scan must eventually be stopped by calling
 * @link #stopScan @endlink.
 */
- (void)startScan;

/**
 * Stops any in-progress device scan. This method <b>must</b> be called at some point after
 * @link #startScan @endlink was called and before this object is released by its owner.
 */
- (void)stopScan;

/**
 * Adds a listener for receiving notifications.
 *
 * @param listener The listener to add.
 */
- (void)addListener:(id<OCDeviceScannerListener>)listener;

/**
 * Removes a listener that was previously added with @link #addListener: @endlink.
 *
 * @param listener The listener to remove.
 */
- (void)removeListener:(id<OCDeviceScannerListener>)listener;

@end

/**
 * The listener interface for OCDeviceScanner notifications.
 *
 * @ingroup Discovery
 */
@protocol OCDeviceScannerListener <NSObject>

@optional

/**
 * Called when a device has been discovered or has come online.
 *
 * @param device The device.
 */
- (void)deviceDidComeOnline:(OCDevice *)device;

/**
 * Called when a device has gone offline.
 *
 * @param device The device.
 */
- (void)deviceDidGoOffline:(OCDevice *)device;

@end
