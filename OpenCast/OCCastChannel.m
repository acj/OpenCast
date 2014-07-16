//
//  OCCastChannel.m
//  OpenCast
//
//  Created by Adam Jensen on 7/11/14.
//  Copyright (c) 2014 Adam Jensen. All rights reserved.
//

#import "OCCastChannel.h"
#import "OCDeviceManager.h"

@interface OCCastChannel ()
@property (weak, nonatomic) OCDeviceManager* deviceManager;
@property (assign, nonatomic) NSInteger nextRequestID;
@end

@interface OCDeviceManager ()
- (BOOL)sendTextMessage:(NSString*)message namespace:(NSString*)protocolNamespace;
@end

@implementation OCCastChannel

- (id)initWithNamespace:(NSString*)protocolNamespace {
    _protocolNamespace = protocolNamespace;
    
    return self;
}

- (void)didReceiveTextMessage:(NSString*)message {
    // Should be implemented by subclasses
}

- (BOOL)sendTextMessage:(NSString *)message {
    return [self.deviceManager sendTextMessage:message namespace:self.protocolNamespace];
}

- (NSInteger)generateRequestID {
    return self.nextRequestID++;
}

- (NSNumber *)generateRequestNumber {
    return @([self generateRequestID]);
}

- (void)didConnect {
    // Should be implemented by subclasses
}

- (void)didDisconnect {
    // Should be implemented by subclasses
}

@end
