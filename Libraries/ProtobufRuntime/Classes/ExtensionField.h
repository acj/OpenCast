//
//  ConcreteExtensionField.h
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


// Identifies a field type.  0 is reserved for errors.  The order is weird
// for historical reasons.  Types 12 and up are new in proto2.

typedef NS_ENUM(NSUInteger, PBExtensionType) {
    
    PBExtensionTypeDouble   = 1,    // double, exactly eight bytes on the wire.
    
    PBExtensionTypeFloat    = 2,    // float, exactly four bytes on the wire.

    PBExtensionTypeInt64    = 3,    // int64, varint on the wire.  Negative numbers
                                    // take 10 bytes.  Use TYPE_SINT64 if negative
                                    // values are likely.
    
    PBExtensionTypeUInt64   = 4,    // uint64, varint on the wire.
    
    PBExtensionTypeInt32    = 5,    // int32, varint on the wire.  Negative numbers
                                    // take 10 bytes.  Use TYPE_SINT32 if negative
                                    // values are likely.
    
    PBExtensionTypeFixed64  = 6,    // uint64, exactly eight bytes on the wire.
    
    PBExtensionTypeFixed32  = 7,    // uint32, exactly four bytes on the wire.
    
    PBExtensionTypeBool     = 8,    // bool, varint on the wire.
    
    PBExtensionTypeString   = 9,    // UTF-8 text.
    
    PBExtensionTypeGroup    = 10,   // Tag-delimited message.  Deprecated.
    
    PBExtensionTypeMessage  = 11,   // Length-delimited message.
    
    PBExtensionTypeBytes    = 12,   // Arbitrary byte array.
    
    PBExtensionTypeUInt32   = 13,   // uint32, varint on the wire
    
    PBExtensionTypeEnum     = 14,   // Enum, varint on the wire
    
    PBExtensionTypeSFixed32 = 15,   // int32, exactly four bytes on the wire
    
    PBExtensionTypeSFixed64 = 16,   // int64, exactly eight bytes on the wire
    
    PBExtensionTypeSInt32   = 17,   // int32, ZigZag-encoded varint on the wire
    
    PBExtensionTypeSInt64   = 18,   // int64, ZigZag-encoded varint on the wire
    
    PBExtensionTypeMAX_TYPE = 18,   // Constant useful for defining lookup tables
                                    // indexed by Type.
    
};


@interface PBExtensionField : NSObject


+ (instancetype)extensionWithType:(PBExtensionType) type
                    extendedClass:(Class) extendedClass
                      fieldNumber:(int32_t) fieldNumber
                     defaultValue:(id) defaultValue
              messageOrGroupClass:(Class) messageOrGroupClass
                       isRepeated:(BOOL) isRepeated
                         isPacked:(BOOL) isPacked
           isMessageSetWireFormat:(BOOL) isMessageSetWireFormat;


- (int32_t)fieldNumber;

- (PBWireFormat)wireType;

- (BOOL)isRepeated;

- (Class)extendedClass;

- (id)defaultValue;

- (void)mergeFromCodedInputStream:(PBCodedInputStream *) input
                    unknownFields:(PBUnknownFieldSet_Builder *)unknownFields
                extensionRegistry:(PBExtensionRegistry *) extensionRegistry
                          builder:(PBExtendableMessage_Builder *)builder
                              tag:(int32_t)tag;

- (void) writeValue:(id) value includingTagToCodedOutputStream:(PBCodedOutputStream*) output;

- (int32_t) computeSerializedSizeIncludingTag:(id) value;

- (void) writeDescriptionOf:(id) value
                         to:(NSMutableString*) output
                 withIndent:(NSString*) indent;

@end
