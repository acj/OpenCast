//
//  OCMediaInformation.h
//  OpenCast

#import <Foundation/Foundation.h>

@class OCMediaMetadata;

typedef NS_ENUM(NSInteger, OCMediaStreamType) {
    /** A stream type of "none". */
    OCMediaStreamTypeNone = 0,
    /** A buffered stream type. */
    OCMediaStreamTypeBuffered = 1,
    /** A live stream type. */
    OCMediaStreamTypeLive = 2,
    /** An unknown stream type. */
    OCMediaStreamTypeUnknown = 99,
};

/**
 * A class that aggregates information about a media item.
 */
@interface OCMediaInformation : NSObject

/**
 * The stream type.
 */
@property(nonatomic, readonly) OCMediaStreamType streamType;

/**
 * The content (MIME) type.
 */
@property(nonatomic, copy, readonly) NSString *contentType;

/**
 * The media item metadata.
 */
@property(nonatomic, strong, readonly) OCMediaMetadata *metadata;

/**
 * The length of time for the stream, in seconds.
 */
@property(nonatomic, readonly) NSTimeInterval streamDuration;

/**
 * The custom data, if any.
 */
@property(nonatomic, strong, readonly) id customData;

/**
 * Designated initializer.
 *
 * @param contentID The content ID.
 * @param streamType The stream type.
 * @param contentType The content (MIME) type.
 * @param metadata The media item metadata.
 * @param streamDuration The stream duration.
 * @param customData The custom application-specific data.
 */
- (id)initWithContentID:(NSString *)contentID
             streamType:(OCMediaStreamType)streamType
            contentType:(NSString *)contentType
               metadata:(OCMediaMetadata *)metadata
         streamDuration:(NSTimeInterval)streamDuration
             customData:(id)customData;

@end
