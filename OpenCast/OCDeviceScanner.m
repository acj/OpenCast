//
//  OCDeviceScanner.m
//  OpenCast
//
//  Created by Adam Jensen on 7/8/14.
//  Copyright (c) 2014 Adam Jensen. All rights reserved.
//

#include <arpa/inet.h>

#import "OCDevice.h"
#import "OCDeviceScanner.h"

static OCDevice* _ocDeviceFromNsNetService(NSNetService* service) {
    char addressBuffer[INET6_ADDRSTRLEN];
    
    for (NSData* data in service.addresses)
    {
        memset(addressBuffer, 0, INET6_ADDRSTRLEN);
        
        typedef union {
            struct sockaddr sa;
            struct sockaddr_in ipv4;
            struct sockaddr_in6 ipv6;
        } ip_socket_address;
        
        ip_socket_address *socketAddress = (ip_socket_address *)[data bytes];
        
        if (socketAddress && (socketAddress->sa.sa_family == AF_INET || socketAddress->sa.sa_family == AF_INET6)) {
            const char* addressStr = inet_ntop(
                                               socketAddress->sa.sa_family,
                                               (socketAddress->sa.sa_family == AF_INET ? (void *)&(socketAddress->ipv4.sin_addr) : (void *)&(socketAddress->ipv6.sin6_addr)),
                                               addressBuffer,
                                               sizeof(addressBuffer));
            
            int port = ntohs(socketAddress->sa.sa_family == AF_INET ? socketAddress->ipv4.sin_port : socketAddress->ipv6.sin6_port);
            
            if (addressStr && port) {
                NSString* const host = [NSString stringWithCString:addressStr encoding:NSASCIIStringEncoding];
                OCDevice* device = [[OCDevice alloc] initWithIPAddress:host servicePort:port];
                device.friendlyName = service.name;
                return device;
            }
        }
    }
    
    return nil;
}

@interface OCDeviceScanner ()<NSNetServiceBrowserDelegate, NSNetServiceDelegate>
@property (strong, nonatomic) NSMutableArray* listeners;
@property (strong, nonatomic) NSNetServiceBrowser* browser;
@property (strong, nonatomic) NSMutableArray* pendingServices;
@end

@implementation OCDeviceScanner

- (id)init {
    _devices = [[NSMutableArray alloc] init];
    _hasDiscoveredDevices = NO;
    _scanning = NO;
    
    _listeners = [[NSMutableArray alloc] init];
    _pendingServices = [[NSMutableArray alloc] init];
    
    return self;
}

- (void)startScan {
    self.browser = [[NSNetServiceBrowser alloc] init];
    [self.browser setDelegate:self];
    [self.browser searchForServicesOfType:@"_googlecast._tcp." inDomain:@""];
}

- (void)stopScan {
    [self.browser stop];
}

- (void)addListener:(id<OCDeviceScannerListener>)listener {
    [self.listeners addObject:listener];
}

- (void)removeListener:(id<OCDeviceScannerListener>)listener {
    [self.listeners removeObject:listener];
}

#pragma mark - NSNetServiceDelegate

- (void)netServiceDidResolveAddress:(NSNetService *)service {
    OCDevice* const discoveredDevice = _ocDeviceFromNsNetService(service);
    NSParameterAssert(discoveredDevice);
    
    for (OCDevice* existingDevice in self.devices) {
        if ([existingDevice.ipAddress isEqualToString:discoveredDevice.ipAddress] &&
            existingDevice.servicePort == discoveredDevice.servicePort) {
            
            NSLog(@"Warning: Skipping discovered service that is already being tracked");
            return;
        }
    }
    
    [(NSMutableArray*)self.devices addObject:discoveredDevice];
    
    for (id<OCDeviceScannerListener> listener in self.listeners) {
        [listener deviceDidComeOnline:discoveredDevice];
    }
}

#pragma mark - NSNetServiceBrowserDelegate

- (void)netServiceBrowser:(NSNetServiceBrowser *)browser
           didFindService:(NSNetService *)service
               moreComing:(BOOL)moreComing {
    [service setDelegate:self];
    [service resolveWithTimeout:5.f];
    
    [self.pendingServices addObject:service];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)browser
         didRemoveService:(NSNetService *)service
               moreComing:(BOOL)moreComing {
    OCDevice* const deviceToRemove = _ocDeviceFromNsNetService(service);
    
    for (OCDevice* existingDevice in self.devices) {
        if ([existingDevice.ipAddress isEqualToString:deviceToRemove.ipAddress] &&
            existingDevice.servicePort == deviceToRemove.servicePort) {
            
            [(NSMutableArray*)self.devices removeObject:deviceToRemove];
            return;
        }
    }
    
    for (id<OCDeviceScannerListener> listener in self.listeners) {
        [listener deviceDidGoOffline:deviceToRemove];
    }
}

- (void)netServiceBrowserWillSearch:(NSNetServiceBrowser *)aNetServiceBrowser {
    NSLog(@"netServiceBrowserWillSearch");
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didNotSearch:(NSDictionary *)errorDict {
    NSLog(@"netServiceBrowser:didNotSearch: Error: %@", errorDict);
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didFindDomain:(NSString *)domainString moreComing:(BOOL)moreComing {
    NSLog(@"didFindDomain");
}

@end
