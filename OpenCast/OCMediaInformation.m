//
//  OCMediaInformation.m
//  OpenCast

#import "OCMediaInformation.h"

@interface OCMediaInformation ()
@property (strong, nonatomic) NSString* contentID;
@end

@implementation OCMediaInformation

- (id)initWithContentID:(NSString *)contentID
             streamType:(OCMediaStreamType)streamType
            contentType:(NSString *)contentType
               metadata:(OCMediaMetadata *)metadata
         streamDuration:(NSTimeInterval)streamDuration
             customData:(id)customData {
    _contentID = contentID;
    _streamType = streamType;
    _contentType = contentType;
    _metadata = metadata;
    _streamDuration = streamDuration;
    
    return self;
}

@end
