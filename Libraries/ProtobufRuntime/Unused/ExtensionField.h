//
//  ExtensionField.h
//  Protocol Buffers for Objective C
//
//  Copyright 2014 Ed Preston
//  Copyright 2010 Booyah Inc.
//  Copyright 2008 Cyrus Najmabadi
//

#import "WireFormat.h"


@class PBCodedInputStream;
@class PBCodedOutputStream;
@class PBExtendableMessage_Builder;
@class PBExtensionRegistry;
@class PBUnknownFieldSet_Builder;


@protocol PBExtensionField

@required

- (int32_t)fieldNumber;

- (PBWireFormat)wireType;

- (BOOL)isRepeated;

- (Class)extendedClass;

- (id)defaultValue;

- (void)mergeFromCodedInputStream:(PBCodedInputStream*) input
                    unknownFields:(PBUnknownFieldSet_Builder*) unknownFields
                extensionRegistry:(PBExtensionRegistry*) extensionRegistry
                          builder:(PBExtendableMessage_Builder*) builder
                              tag:(int32_t) tag;

- (void) writeValue:(id) value includingTagToCodedOutputStream:(PBCodedOutputStream*) output;

- (int32_t) computeSerializedSizeIncludingTag:(id) value;

- (void) writeDescriptionOf:(id) value
                         to:(NSMutableString*) output
                 withIndent:(NSString*) indent;

@end
