//
//  ConcreteExtensionField.m
//  Protocol Buffers for Objective C
//
//  Copyright 2014 Ed Preston
//  Copyright 2010 Booyah Inc.
//  Copyright 2008 Cyrus Najmabadi
//

#import "ExtensionField.h"


#import "Message.h"
#import "CodedInputStream.h"
#import "CodedOutputStream.h"
#import "ExtendableMessage_Builder.h"
#import "Message_Builder.h"
#import "Utilities.h"
#import "WireFormat.h"


BOOL typeIsFixedSize(PBExtensionType extentionType);
int32_t extentionTypeSize(PBExtensionType extentionType);

BOOL typeIsFixedSize(PBExtensionType extentionType) {
    switch (extentionType) {
        case PBExtensionTypeBool:
        case PBExtensionTypeFixed32:
        case PBExtensionTypeSFixed32:
        case PBExtensionTypeFloat:
        case PBExtensionTypeFixed64:
        case PBExtensionTypeSFixed64:
        case PBExtensionTypeDouble:
            return YES;
        default:
            return NO;
    }
}

int32_t extentionTypeSize(PBExtensionType extentionType) {
    switch (extentionType) {
        case PBExtensionTypeBool:
            return 1;
        case PBExtensionTypeFixed32:
        case PBExtensionTypeSFixed32:
        case PBExtensionTypeFloat:
            return 4;
        case PBExtensionTypeFixed64:
        case PBExtensionTypeSFixed64:
        case PBExtensionTypeDouble:
            return 8;
        default:
            break;
    }
    
    NSLog(@"PBExtensionType size not defined in helper function.");
    return 0;
}


#pragma mark - PBExtensionField

@implementation PBExtensionField {
    PBExtensionType _type;

    Class _extendedClass;
    int32_t _fieldNumber;
    id _defaultValue;

    Class _messageOrGroupClass;

    BOOL _isRepeated;
    BOOL _isPacked;
    BOOL _isMessageSetWireFormat;
}

- (instancetype)initWithType:(PBExtensionType)extentionType
               extendedClass:(Class)extendedClass
                 fieldNumber:(int32_t)fieldNumber
                defaultValue:(id)defaultValue
         messageOrGroupClass:(Class)messageOrGroupClass
                    repeated:(BOOL)isRepeated
                      packed:(BOOL)isPacked
        messageSetWireFormat:(BOOL)isMessageSetWireFormat
{
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    _type = extentionType;
    _extendedClass = extendedClass;
    _fieldNumber = fieldNumber;
    _defaultValue = defaultValue;
    _messageOrGroupClass = messageOrGroupClass;
    _isRepeated = isRepeated;
    _isPacked = isPacked;
    _isMessageSetWireFormat = isMessageSetWireFormat;
    
    return self;
}

+ (instancetype)extensionWithType:(PBExtensionType)type
                    extendedClass:(Class)extendedClass
                      fieldNumber:(int32_t)fieldNumber
                     defaultValue:(id)defaultValue
              messageOrGroupClass:(Class)messageOrGroupClass
                       isRepeated:(BOOL)isRepeated
                         isPacked:(BOOL)isPacked
           isMessageSetWireFormat:(BOOL)isMessageSetWireFormat
{
    return [[PBExtensionField alloc]initWithType:type
                                   extendedClass:extendedClass
                                     fieldNumber:fieldNumber
                                    defaultValue:defaultValue
                             messageOrGroupClass:messageOrGroupClass
                                        repeated:isRepeated
                                          packed:isPacked
                            messageSetWireFormat:isMessageSetWireFormat] ;
}


#pragma mark - Common Interface

-(int32_t)fieldNumber {
    return _fieldNumber;
}

- (PBWireFormat)wireType {
    if (_isPacked) {
        return PBWireFormatLengthDelimited;
    }
    
    switch (_type) {
        case PBExtensionTypeBool:     return PBWireFormatVarint;
        case PBExtensionTypeFixed32:  return PBWireFormatFixed32;
        case PBExtensionTypeSFixed32: return PBWireFormatFixed32;
        case PBExtensionTypeFloat:    return PBWireFormatFixed32;
        case PBExtensionTypeFixed64:  return PBWireFormatFixed64;
        case PBExtensionTypeSFixed64: return PBWireFormatFixed64;
        case PBExtensionTypeDouble:   return PBWireFormatFixed64;
        case PBExtensionTypeInt32:    return PBWireFormatVarint;
        case PBExtensionTypeInt64:    return PBWireFormatVarint;
        case PBExtensionTypeSInt32:   return PBWireFormatVarint;
        case PBExtensionTypeSInt64:   return PBWireFormatVarint;
        case PBExtensionTypeUInt32:   return PBWireFormatVarint;
        case PBExtensionTypeUInt64:   return PBWireFormatVarint;
        case PBExtensionTypeBytes:    return PBWireFormatLengthDelimited;
        case PBExtensionTypeString:   return PBWireFormatLengthDelimited;
        case PBExtensionTypeMessage:  return PBWireFormatLengthDelimited;
        case PBExtensionTypeGroup:    return PBWireFormatStartGroup;
        case PBExtensionTypeEnum:     return PBWireFormatVarint;
    }

    NSAssert(NO, @"PBWireFormat for PBExtensionType not defined.");
}

-(BOOL)isRepeated {
    return _isRepeated;
}

-(Class)extendedClass {
    return _extendedClass;
}

-(id)defaultValue {
    return _defaultValue;
}

- (void)mergeFromCodedInputStream:(PBCodedInputStream *)input
                    unknownFields:(PBUnknownFieldSet_Builder *)unknownFields
                extensionRegistry:(PBExtensionRegistry *)extensionRegistry
                          builder:(PBExtendableMessage_Builder *)builder
                              tag:(int32_t)tag {
    
    NSParameterAssert(input);
    NSParameterAssert(unknownFields);
    NSParameterAssert(extensionRegistry);
    NSParameterAssert(builder);
    
    if (_isPacked) {
        
        int32_t length = [input readRawVarint32];
        int32_t limit = [input pushLimit:length];
        
        while ([input bytesUntilLimit] > 0) {
            id value = [self readSingleValueFromCodedInputStream:input
                                               extensionRegistry:extensionRegistry];
            [builder addExtension:self value:value];
        }
        
        [input popLimit:limit];
        
    } else if (_isMessageSetWireFormat) {
        
        [self mergeMessageSetExtentionFromCodedInputStream:input
                                             unknownFields:unknownFields];
        
    } else {
        
        id value = [self readSingleValueFromCodedInputStream:input
                                           extensionRegistry:extensionRegistry];
        if (_isRepeated) {
            [builder addExtension:self value:value];
        } else {
            [builder setExtension:self value:value];
        }
    }
}

- (void)writeValue:(id)value includingTagToCodedOutputStream:(PBCodedOutputStream*)output
{
    NSParameterAssert(output);
    
    if (_isRepeated) {
        [self writeRepeatedValues:value includingTagsToCodedOutputStream:output];
    } else {
        [self writeSingleValue:value includingTagToCodedOutputStream:output];
    }
}

- (int32_t)computeSerializedSizeIncludingTag:(id)value {
    if (_isRepeated) {
        return [self computeRepeatedSerializedSizeIncludingTags:value];
    } else {
        return [self computeSingleSerializedSizeIncludingTag:value];
    }
}

- (void)writeDescriptionOf:(id)value
                        to:(NSMutableString *)output
                withIndent:(NSString *)indent
{
    NSParameterAssert(output);
    
    if (_isRepeated) {
        NSArray* values = value;
        for (id singleValue in values) {
            [self writeDescriptionOfSingleValue:singleValue to:output withIndent:indent];
        }
    } else {
        [self writeDescriptionOfSingleValue:value to:output withIndent:indent];
    }
}


#pragma mark - Implementation (work in progress)

- (void) mergeMessageSetExtentionFromCodedInputStream:(PBCodedInputStream*)input
                                        unknownFields:(PBUnknownFieldSet_Builder*)unknownFields {
    
    NSParameterAssert(input);
    NSParameterAssert(unknownFields);
    
    NSAssert(NO, @"mergeMessageSetExtentionFromCodedInputStream not implemented.");
    
    // The wire format for MessageSet is:
    //   message MessageSet {
    //     repeated group Item = 1 {
    //       required int32 typeId = 2;
    //       required bytes message = 3;
    //     }
    //   }
    // "typeId" is the extension's field number.  The extension can only be
    // a message type, where "message" contains the encoded bytes of that
    // message.
    //
    // In practice, we will probably never see a MessageSet item in which
    // the message appears before the type ID, or where either field does not
    // appear exactly once.  However, in theory such cases are valid, so we
    // should be prepared to accept them.
    
}


#pragma mark - Implementation (description)

- (void)writeDescriptionOfSingleValue:(id)value
                                   to:(NSMutableString*)output
                           withIndent:(NSString*)indent
{
    NSParameterAssert(output);
    
    switch (_type) {
        case PBExtensionTypeBool:
        case PBExtensionTypeFixed32:
        case PBExtensionTypeSFixed32:
        case PBExtensionTypeFloat:
        case PBExtensionTypeFixed64:
        case PBExtensionTypeSFixed64:
        case PBExtensionTypeDouble:
        case PBExtensionTypeInt32:
        case PBExtensionTypeInt64:
        case PBExtensionTypeSInt32:
        case PBExtensionTypeSInt64:
        case PBExtensionTypeUInt32:
        case PBExtensionTypeUInt64:
        case PBExtensionTypeBytes:
        case PBExtensionTypeString:
        case PBExtensionTypeEnum:
            [output appendFormat:@"%@%@\n", indent, value];
            return;
        case PBExtensionTypeGroup:
        case PBExtensionTypeMessage:
            [(id<PBMessage>)value writeDescriptionTo:output withIndent:indent];
            return;
    }
    
    NSAssert(NO, @"Descriptiong not defined for PBExtensionType: %lu", _type);
}


#pragma mark - Implementation (computing size)

- (int32_t)computeRepeatedSerializedSizeIncludingTags:(NSArray*)values {
    
    NSParameterAssert(values);
    
    if (_isPacked) {
        int32_t size = 0;
        if (typeIsFixedSize(_type)) {
            size += extentionTypeSize(_type) * values.count;
        } else {
            for (id value in values) {
                size += [self computeSingleSerializedSizeNoTag:value];
            }
        }
        return size + computeTagSize(_fieldNumber) + computeRawVarint32Size(size);
    } else {
        int32_t size = 0;
        for (id value in values) {
            size += [self computeSingleSerializedSizeIncludingTag:value];
        }
        return size;
    }
}

- (int32_t)computeSingleSerializedSizeNoTag:(id)value {
    switch (_type) {
        case PBExtensionTypeBool:     return computeBoolSizeNoTag([value boolValue]);
        case PBExtensionTypeFixed32:  return computeFixed32SizeNoTag([value intValue]);
        case PBExtensionTypeSFixed32: return computeSFixed32SizeNoTag([value intValue]);
        case PBExtensionTypeFloat:    return computeFloatSizeNoTag([value floatValue]);
        case PBExtensionTypeFixed64:  return computeFixed64SizeNoTag([value longLongValue]);
        case PBExtensionTypeSFixed64: return computeSFixed64SizeNoTag([value longLongValue]);
        case PBExtensionTypeDouble:   return computeDoubleSizeNoTag([value doubleValue]);
        case PBExtensionTypeInt32:    return computeInt32SizeNoTag([value intValue]);
        case PBExtensionTypeInt64:    return computeInt64SizeNoTag([value longLongValue]);
        case PBExtensionTypeSInt32:   return computeSInt32SizeNoTag([value intValue]);
        case PBExtensionTypeSInt64:   return computeSInt64SizeNoTag([value longLongValue]);
        case PBExtensionTypeUInt32:   return computeUInt32SizeNoTag([value intValue]);
        case PBExtensionTypeUInt64:   return computeUInt64SizeNoTag([value longLongValue]);
        case PBExtensionTypeBytes:    return computeDataSizeNoTag(value);
        case PBExtensionTypeString:   return computeStringSizeNoTag(value);
        case PBExtensionTypeGroup:    return computeGroupSizeNoTag(value);
        case PBExtensionTypeEnum:     return computeEnumSizeNoTag([value intValue]);
        case PBExtensionTypeMessage:  return computeMessageSizeNoTag(value);
    }
    
    NSAssert(NO, @"Unable to compute size for PBExtensionType: %lu", _type);
}

- (int32_t)computeSingleSerializedSizeIncludingTag:(id)value {
    switch (_type) {
        case PBExtensionTypeBool:     return computeBoolSize(_fieldNumber, [value boolValue]);
        case PBExtensionTypeFixed32:  return computeFixed32Size(_fieldNumber, [value intValue]);
        case PBExtensionTypeSFixed32: return computeSFixed32Size(_fieldNumber, [value intValue]);
        case PBExtensionTypeFloat:    return computeFloatSize(_fieldNumber, [value floatValue]);
        case PBExtensionTypeFixed64:  return computeFixed64Size(_fieldNumber, [value longLongValue]);
        case PBExtensionTypeSFixed64: return computeSFixed64Size(_fieldNumber, [value longLongValue]);
        case PBExtensionTypeDouble:   return computeDoubleSize(_fieldNumber, [value doubleValue]);
        case PBExtensionTypeInt32:    return computeInt32Size(_fieldNumber, [value intValue]);
        case PBExtensionTypeInt64:    return computeInt64Size(_fieldNumber, [value longLongValue]);
        case PBExtensionTypeSInt32:   return computeSInt32Size(_fieldNumber, [value intValue]);
        case PBExtensionTypeSInt64:   return computeSInt64Size(_fieldNumber, [value longLongValue]);
        case PBExtensionTypeUInt32:   return computeUInt32Size(_fieldNumber, [value intValue]);
        case PBExtensionTypeUInt64:   return computeUInt64Size(_fieldNumber, [value longLongValue]);
        case PBExtensionTypeBytes:    return computeDataSize(_fieldNumber, value);
        case PBExtensionTypeString:   return computeStringSize(_fieldNumber, value);
        case PBExtensionTypeGroup:    return computeGroupSize(_fieldNumber, value);
        case PBExtensionTypeEnum:     return computeEnumSize(_fieldNumber, [value intValue]);
        case PBExtensionTypeMessage:
            if (_isMessageSetWireFormat) {
                return computeMessageSetExtensionSize(_fieldNumber, value);
            } else {
                return computeMessageSize(_fieldNumber, value);
            }
    }
    
    NSAssert(NO, @"Unable to compute size for PBExtensionType: %lu", _type);
}


#pragma mark - Implementation (reading)

- (id)readSingleValueFromCodedInputStream:(PBCodedInputStream*)input
                        extensionRegistry:(PBExtensionRegistry*)extensionRegistry
{
    NSParameterAssert(input);
    NSParameterAssert(extensionRegistry);
    
    switch (_type) {
        case PBExtensionTypeBool:     return @([input readBool]);
        case PBExtensionTypeFixed32:  return @([input readFixed32]);
        case PBExtensionTypeSFixed32: return @([input readSFixed32]);
        case PBExtensionTypeFloat:    return @([input readFloat]);
        case PBExtensionTypeFixed64:  return @([input readFixed64]);
        case PBExtensionTypeSFixed64: return @([input readSFixed64]);
        case PBExtensionTypeDouble:   return @([input readDouble]);
        case PBExtensionTypeInt32:    return @([input readInt32]);
        case PBExtensionTypeInt64:    return @([input readInt64]);
        case PBExtensionTypeSInt32:   return @([input readSInt32]);
        case PBExtensionTypeSInt64:   return @([input readSInt64]);
        case PBExtensionTypeUInt32:   return [NSNumber numberWithInt:[input readUInt32]];
        case PBExtensionTypeUInt64:   return [NSNumber numberWithLongLong:[input readUInt64]];
        case PBExtensionTypeBytes:    return [input readData];
        case PBExtensionTypeString:   return [input readString];
        case PBExtensionTypeEnum:     return @([input readEnum]);
        case PBExtensionTypeGroup:
        {
            id<PBMessage_Builder> builder = [_messageOrGroupClass builder];
            [input readGroup:_fieldNumber builder:builder extensionRegistry:extensionRegistry];
            return [builder build];
        }
            
        case PBExtensionTypeMessage:
        {
            id<PBMessage_Builder> builder = [_messageOrGroupClass builder];
            [input readMessage:builder extensionRegistry:extensionRegistry];
            return [builder build];
        }
    }
    
    NSAssert(NO, @"Unable to read value for PBExtensionType: %lu", _type);
}


#pragma mark - Implementation (writing)

- (void)         writeRepeatedValues:(NSArray*)values
    includingTagsToCodedOutputStream:(PBCodedOutputStream*)output
{
    NSParameterAssert(values);
    NSParameterAssert(output);
    
    if (_isPacked) {
        [output writeTag:_fieldNumber format:PBWireFormatLengthDelimited];
        int32_t dataSize = 0;
        if (typeIsFixedSize(_type)) {
            dataSize += extentionTypeSize(_type) * values.count;
        } else {
            for (id value in values) {
                dataSize += [self computeSingleSerializedSizeNoTag:value];
            }
        }
        [output writeRawVarint32:dataSize];
        for (id value in values) {
            [self writeSingleValue:value noTagToCodedOutputStream:output];
        }
    } else {
        for (id value in values) {
            [self writeSingleValue:value includingTagToCodedOutputStream:output];
        }
    }
}

- (void)writeSingleValue:(id)value includingTagToCodedOutputStream:(PBCodedOutputStream*)output
{
    NSParameterAssert(output);
    
    switch (_type) {
        case PBExtensionTypeBool:
            [output writeBool:_fieldNumber value:[value boolValue]];
            return;
        case PBExtensionTypeFixed32:
            [output writeFixed32:_fieldNumber value:[value intValue]];
            return;
        case PBExtensionTypeSFixed32:
            [output writeSFixed32:_fieldNumber value:[value intValue]];
            return;
        case PBExtensionTypeFloat:
            [output writeFloat:_fieldNumber value:[value floatValue]];
            return;
        case PBExtensionTypeFixed64:
            [output writeFixed64:_fieldNumber value:[value longLongValue]];
            return;
        case PBExtensionTypeSFixed64:
            [output writeSFixed64:_fieldNumber value:[value longLongValue]];
            return;
        case PBExtensionTypeDouble:
            [output writeDouble:_fieldNumber value:[value doubleValue]];
            return;
        case PBExtensionTypeInt32:
            [output writeInt32:_fieldNumber value:[value intValue]];
            return;
        case PBExtensionTypeInt64:
            [output writeInt64:_fieldNumber value:[value longLongValue]];
            return;
        case PBExtensionTypeSInt32:
            [output writeSInt32:_fieldNumber value:[value intValue]];
            return;
        case PBExtensionTypeSInt64:
            [output writeSInt64:_fieldNumber value:[value longLongValue]];
            return;
        case PBExtensionTypeUInt32:
            [output writeUInt32:_fieldNumber value:[value intValue]];
            return;
        case PBExtensionTypeUInt64:
            [output writeUInt64:_fieldNumber value:[value longLongValue]];
            return;
        case PBExtensionTypeBytes:
            [output writeData:_fieldNumber value:value];
            return;
        case PBExtensionTypeString:
            [output writeString:_fieldNumber value:value];
            return;
        case PBExtensionTypeGroup:
            [output writeGroup:_fieldNumber value:value];
            return;
        case PBExtensionTypeEnum:
            [output writeEnum:_fieldNumber value:[value intValue]];
            return;
        case PBExtensionTypeMessage:
            if (_isMessageSetWireFormat) {
                [output writeMessageSetExtension:_fieldNumber value:value];
            } else {
                [output writeMessage:_fieldNumber value:value];
            }
            return;
    }
    
    NSAssert(NO, @"Unable to write value for PBExtensionType: %lu", _type);
}

- (void)writeSingleValue:(id)value noTagToCodedOutputStream:(PBCodedOutputStream*)output
{
    NSParameterAssert(output);
    
    switch (_type) {
        case PBExtensionTypeBool:
            [output writeBoolNoTag:[value boolValue]];
            return;
        case PBExtensionTypeFixed32:
            [output writeFixed32NoTag:[value intValue]];
            return;
        case PBExtensionTypeSFixed32:
            [output writeSFixed32NoTag:[value intValue]];
            return;
        case PBExtensionTypeFloat:
            [output writeFloatNoTag:[value floatValue]];
            return;
        case PBExtensionTypeFixed64:
            [output writeFixed64NoTag:[value longLongValue]];
            return;
        case PBExtensionTypeSFixed64:
            [output writeSFixed64NoTag:[value longLongValue]];
            return;
        case PBExtensionTypeDouble:
            [output writeDoubleNoTag:[value doubleValue]];
            return;
        case PBExtensionTypeInt32:
            [output writeInt32NoTag:[value intValue]];
            return;
        case PBExtensionTypeInt64:
            [output writeInt64NoTag:[value longLongValue]];
            return;
        case PBExtensionTypeSInt32:
            [output writeSInt32NoTag:[value intValue]];
            return;
        case PBExtensionTypeSInt64:
            [output writeSInt64NoTag:[value longLongValue]];
            return;
        case PBExtensionTypeUInt32:
            [output writeUInt32NoTag:[value intValue]];
            return;
        case PBExtensionTypeUInt64:
            [output writeUInt64NoTag:[value longLongValue]];
            return;
        case PBExtensionTypeBytes:
            [output writeDataNoTag:value];
            return;
        case PBExtensionTypeString:
            [output writeStringNoTag:value];
            return;
        case PBExtensionTypeGroup:
            [output writeGroupNoTag:_fieldNumber value:value];
            return;
        case PBExtensionTypeEnum:
            [output writeEnumNoTag:[value intValue]];
            return;
        case PBExtensionTypeMessage:
            [output writeMessageNoTag:value];
            return;
    }
    
    NSAssert(NO, @"PBExtensionType not valid, no data written.");
}


@end
