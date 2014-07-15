//
//  OCHeartbeatChannel.m
//  OpenCast

#import "OCHeartbeatChannel.h"

NSString* const TextMessagePing = @"{\"type\":\"PING\"}";
NSString* const TextMessagePong = @"{\"type\":\"PONG\"}";

@implementation OCHeartbeatChannel

+ (id)init {
    return [[OCHeartbeatChannel alloc] initWithNamespace:OpenCastNamespaceHeartbeat];
}

- (void)didReceiveTextMessage:(NSString *)message {
    NSLog(@"Heartbeat received message: %@", message);
    
    if ([message rangeOfString:@"PING"].location != NSNotFound) {
        [self sendTextMessage:TextMessagePong];
    }
}

- (void)didConnect {
    [self sendTextMessage:TextMessagePing];
}

@end
