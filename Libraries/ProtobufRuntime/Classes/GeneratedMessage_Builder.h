//
//  GeneratedMessage_Builder.h
//  Protocol Buffers for Objective C
//
//  Copyright 2014 Ed Preston
//  Copyright 2010 Booyah Inc.
//  Copyright 2008 Cyrus Najmabadi
//

#import "Message_Builder.h"


@class PBCodedInputStream;
@class PBExtensionRegistry;
@class PBUnknownFieldSet_Builder;


@interface PBGeneratedMessage_Builder : NSObject <PBMessage_Builder>


// override the protocol definitions for autocomplete, type checking
- (instancetype)clear;
- (instancetype)clone;

- (instancetype)mergeFromCodedInputStream:(PBCodedInputStream *)input;

- (instancetype)mergeFromCodedInputStream:(PBCodedInputStream *)input
                        extensionRegistry:(PBExtensionRegistry *)extensionRegistry;


/* @protected */
- (BOOL) parseUnknownField:(PBCodedInputStream *)input
             unknownFields:(PBUnknownFieldSet_Builder *)unknownFields
         extensionRegistry:(PBExtensionRegistry *)extensionRegistry
                       tag:(int32_t)tag;

- (void) checkInitialized;

@end
