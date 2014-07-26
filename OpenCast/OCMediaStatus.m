//
//  OCMediaStatus.m
//  OpenCast

#import "OCMediaStatus.h"

@implementation OCMediaStatus

- (id)initWithSessionID:(NSInteger)mediaSessionID mediaInformation:(OCMediaInformation *)mediaInformation
{
    _mediaSessionID = mediaSessionID;
    _mediaInformation = mediaInformation;
    
    return self;
}

- (BOOL)isMediaCommandSupported:(NSInteger)command
{
    // TODO
    return YES;
}

@end
