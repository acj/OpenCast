//
//  OCConstants.m
//  OpenCast
//
//  Created by Adam Jensen on 7/12/14.
//  Copyright (c) 2014 Adam Jensen. All rights reserved.
//

#import "OCConstants.h"

@implementation OCConstants

NSString* const OpenCastNamespaceConnection = @"urn:x-cast:com.google.cast.tp.connection";
NSString* const OpenCastNamespaceHeartbeat = @"urn:x-cast:com.google.cast.tp.heartbeat";
NSString* const OpenCastNamespaceReceiver = @"urn:x-cast:com.google.cast.receiver";
NSString* const OpenCastNamespaceMedia = @"urn:x-cast:com.google.cast.media";
NSString* const OpenCastNamespaceDeviceAuth = @"urn:x-cast:com.google.cast.tp.deviceauth";

NSString* const SourceIdDefault = @"sender-0";
NSString* const DestinationIdDefault = @"receiver-0";

NSString* const CastAppIdDefaultMediaReceiver = @"CC1AD845";

@end
