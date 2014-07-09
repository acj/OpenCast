//
//  OCDevice.m
//  OpenCast
//
//  Created by Adam Jensen on 7/8/14.
//  Copyright (c) 2014 Adam Jensen. All rights reserved.
//

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
