//
//  ExtendableMessage.h
//  Protocol Buffers for Objective C
//
//  Copyright 2014 Ed Preston
//  Copyright 2010 Booyah Inc.
//  Copyright 2008 Cyrus Najmabadi
//

#import "GeneratedMessage.h"


@class PBExtensionField;
@class PBCodedOutputStream;


@interface PBExtendableMessage : PBGeneratedMessage 

@property (strong) NSMutableDictionary* extensionMap;
@property (strong) NSMutableDictionary* extensionRegistry;

- (BOOL)hasExtension:(PBExtensionField *)extension;
- (id)getExtension:(PBExtensionField *)extension;

//@protected
- (BOOL) extensionsAreInitialized;

- (int32_t) extensionsSerializedSize;

- (void) writeExtensionsToCodedOutputStream:(PBCodedOutputStream *)output
                                       from:(int32_t) startInclusive
                                         to:(int32_t) endExclusive;

- (void) writeExtensionDescriptionToMutableString:(NSMutableString *)output
                                             from:(int32_t)startInclusive
                                               to:(int32_t)endExclusive
                                       withIndent:(NSString *)indent;

- (BOOL) isEqualExtensionsInOther:(PBExtendableMessage*)otherMessage
                             from:(int32_t)startInclusive
                               to:(int32_t)endExclusive;

- (NSUInteger) hashExtensionsFrom:(int32_t)startInclusive
                               to:(int32_t)endExclusive;

/* @internal */
- (void) ensureExtensionIsRegistered:(PBExtensionField *) extension;

@end
