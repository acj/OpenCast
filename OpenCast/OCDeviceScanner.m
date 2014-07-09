//
//  OCDeviceScanner.m
//  OpenCast
//
//  Created by Adam Jensen on 7/8/14.
//  Copyright (c) 2014 Adam Jensen. All rights reserved.
//

#import "OCDeviceScanner.h"

@interface OCDeviceScanner ()
@property (strong, nonatomic) NSMutableArray* listeners;
@end

@implementation OCDeviceScanner

- (id)init {
    _devices = [[NSMutableArray alloc] init];
    _hasDiscoveredDevices = NO;
    _scanning = NO;
    
    return self;
}

- (void)startScan {
    // TODO
}

- (void)stopScan {
    // TODO
}

- (void)addListener:(id<OCDeviceScannerListener>)listener {
    [self.listeners addObject:listener];
}

- (void)removeListener:(id<OCDeviceScannerListener>)listener {
    [self.listeners removeObject:listener];
}

@end
