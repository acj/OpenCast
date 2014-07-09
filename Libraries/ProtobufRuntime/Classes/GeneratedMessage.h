//
//  GeneratedMessage.h
//  Protocol Buffers for Objective C
//
//  Copyright 2014 Ed Preston
//  Copyright 2010 Booyah Inc.
//  Copyright 2008 Cyrus Najmabadi
//

#import "Message.h"


@class PBExtensionRegistry;
@class PBCodedInputStream;

@protocol PBMessage_Builder;

/**
 * All generated protocol message classes extend this class.  This class
 * implements most of the Message and Builder interfaces using Java reflection.
 * Users can ignore this class and pretend that generated messages implement
 * the Message interface directly.
 *
 * @author Cyrus Najmabadi
 */

@interface PBGeneratedMessage : NSObject <PBMessage> {

@protected
    int32_t _cachedSerializedSize;
}

+ (instancetype)defaultInstance;
- (instancetype)defaultInstance;    // defined here for autocomplete / type checking

+ (id<PBMessage_Builder>)builder;

+ (instancetype)parseFromData:(NSData*)data;

+ (instancetype)parseFromData:(NSData*)data
            extensionRegistry:(PBExtensionRegistry*)extensionRegistry;

+ (instancetype)parseFromInputStream:(NSInputStream*)input;

+ (instancetype)parseFromInputStream:(NSInputStream*)input
                   extensionRegistry:(PBExtensionRegistry*)extensionRegistry;

+ (instancetype)parseFromCodedInputStream:(PBCodedInputStream*)input;

+ (instancetype)parseFromCodedInputStream:(PBCodedInputStream*)input
                        extensionRegistry:(PBExtensionRegistry*)extensionRegistry;

@end
