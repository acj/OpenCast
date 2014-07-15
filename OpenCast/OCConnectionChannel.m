//
//  OCConnectionChannel.m
//  OpenCast

#import "OCConnectionChannel.h"

NSString* const TextMessageConnect = @"{\"type\":\"CONNECT\"}";
NSString* const TextMessageClose = @"{\"type\":\"CLOSE\"}";

@implementation OCConnectionChannel

+ (id)init {
    return [[OCConnectionChannel alloc] initWithNamespace:OpenCastNamespaceConnection];
}

- (void)didConnect {
    [self sendTextMessage:TextMessageConnect];
}

- (void)didDisconnect {
    [self sendTextMessage:TextMessageClose];
}

@end
