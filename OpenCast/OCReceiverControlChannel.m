//
//  OCReceiverControlChannel.m
//  OpenCast

#import "OCReceiverControlChannel.h"

@implementation OCReceiverControlChannel

+ (id)init {
    return [[OCReceiverControlChannel alloc] initWithNamespace:OpenCastNamespaceReceiver];
}

- (void)didReceiveTextMessage:(NSString *)message
{
    // TODO: Keep track of receiver state
}

- (void)didConnect {
    [self sendTextMessage:@"{\"type\":\"GET_STATUS\",\"requestId\":1}"];
}

@end
