//
//  OCDevice.m
//  OpenCast

#import "OCDevice.h"

@implementation OCDevice

- (id)initWithCoder:(NSCoder *)aDecoder {
    // TODO
    return nil;
}

- (id)initWithIPAddress:(NSString *)ipAddress servicePort:(UInt32)servicePort {
    _ipAddress = ipAddress;
    _servicePort = servicePort;
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    // TODO
    return nil;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    // TODO
}

@end
