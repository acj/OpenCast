//
//  UnknownFieldSet_Builder.m
//  Protocol Buffers for Objective C
//
//  Copyright 2014 Ed Preston
//  Copyright 2010 Booyah Inc.
//  Copyright 2008 Cyrus Najmabadi
//

#import "UnknownFieldSet_Builder.h"

#import "CodedInputStream.h"
#import "Field.h"
#import "MutableField.h"
#import "UnknownFieldSet.h"
#import "WireFormat.h"


#pragma mark - PBUnknownFieldSet_Builder

@implementation PBUnknownFieldSet_Builder {
    NSMutableDictionary* _fields;

    // Optimization:  We keep around a builder for the last field that was
    //   modified so that we can efficiently add to it multiple times in a
    //   row (important when parsing an unknown repeated field).
    int32_t _lastFieldNumber;

    PBMutableField* _lastField;
}

- (instancetype)init {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    _fields = [NSMutableDictionary dictionary];
    
    return self;
}

+ (instancetype)createBuilder:(PBUnknownFieldSet*)unknownFields {
    PBUnknownFieldSet_Builder* builder = [[PBUnknownFieldSet_Builder alloc] init];
    [builder mergeUnknownFields:unknownFields];
    return builder;
}

/**
 * Add a field to the {@code PBUnknownFieldSet}.  If a field with the same
 * number already exists, it is removed.
 */
- (instancetype)addField:(PBField*)field forNumber:(int32_t)number {
    NSParameterAssert(field);
    NSParameterAssert(number != 0);

    if (_lastField != nil && _lastFieldNumber == number) {
        // Discard this.
        _lastField = nil;
        _lastFieldNumber = 0;
    }
    _fields[@(number)] = field;
    return self;
}

/**
 * Get a field builder for the given field number which includes any
 * values that already exist.
 */
- (PBMutableField*)getFieldBuilder:(int32_t)number {
    if (_lastField != nil) {
        if (number == _lastFieldNumber) {
            return _lastField;
        }
        // Note:  addField() will reset lastField and lastFieldNumber.
        [self addField:_lastField forNumber:_lastFieldNumber];
    }
    if (number == 0) {
        return nil;
    } else {
        PBField* existing = _fields[@(number)];
        _lastFieldNumber = number;
        _lastField = [PBMutableField field];
        if (existing != nil) {
            [_lastField mergeFromField:existing];
        }
        return _lastField;
    }
}

/** Check if the given field number is present in the set. */
- (BOOL)hasField:(int32_t)number {
    NSParameterAssert(number != 0);
    
    return number == _lastFieldNumber || (_fields[@(number)] != nil);
}

/**
 * Add a field to the {@code PBUnknownFieldSet}.  If a field with the same
 * number already exists, the two are merged.
 */
- (instancetype)mergeField:(PBField*)field forNumber:(int32_t)number {
    NSParameterAssert(field);
    
    if (number == 0) {
        return nil;
    }
    if ([self hasField:number]) {
        [[self getFieldBuilder:number] mergeFromField:field];
    } else {
        // Optimization:  We could call getFieldBuilder(number).mergeFrom(field)
        // in this case, but that would create a copy of the PBField object.
        // We'd rather reuse the one passed to us, so call addField() instead.
        [self addField:field forNumber:number];
    }
    
    return self;
}

- (instancetype)mergeVarintField:(int32_t)number value:(int32_t)value {
    NSParameterAssert(number != 0);
    
    [[self getFieldBuilder:number] addVarint:value];
    return self;
}

/**
 * Parse a single field from {@code input} and merge it into this set.
 * @param tag The field's tag number, which was already parsed.
 * @return {@code NO} if the tag is an engroup tag.
 */
- (BOOL)mergeFieldFrom:(int32_t)tag input:(PBCodedInputStream*)input {
    NSParameterAssert(input);
    
    int32_t number = PBWireFormatGetTagFieldNumber(tag);
    switch (PBWireFormatGetTagWireType(tag)) {
        case PBWireFormatVarint:
            [[self getFieldBuilder:number] addVarint:[input readInt64]];
            return YES;
        case PBWireFormatFixed64:
            [[self getFieldBuilder:number] addFixed64:[input readFixed64]];
            return YES;
        case PBWireFormatLengthDelimited:
            [[self getFieldBuilder:number] addLengthDelimited:[input readData]];
            return YES;
        case PBWireFormatStartGroup: {
            PBUnknownFieldSet_Builder* subBuilder = [PBUnknownFieldSet builder];
            [input readUnknownGroup:number builder:subBuilder];
            [[self getFieldBuilder:number] addGroup:[subBuilder build]];
            return YES;
        }
        case PBWireFormatEndGroup:
            return NO;
        case PBWireFormatFixed32:
            [[self getFieldBuilder:number] addFixed32:[input readFixed32]];
            return YES;
        default:
            return YES;
    }
}


#pragma mark - PBMessage_Builder Protocol

- (instancetype)clear {
    _fields = [NSMutableDictionary dictionary];
    _lastFieldNumber = 0;
    _lastField = nil;
    return self;
}

- (PBUnknownFieldSet*)build {
    [self getFieldBuilder:0];  // Force lastField to be built.
    PBUnknownFieldSet* result;
    if (_fields.count == 0) {
        result = [PBUnknownFieldSet defaultInstance];
    } else {
        result = [PBUnknownFieldSet setWithFields:_fields];
    }
    _fields = nil;
    return result;
}

- (PBUnknownFieldSet*)buildPartial {
    return nil;
}

- (PBUnknownFieldSet*)clone {
    return nil;
}

- (BOOL)isInitialized {
    return YES;
}

- (PBUnknownFieldSet*)defaultMessageInstance {
    return nil;
}

- (PBUnknownFieldSet*)unknownFields {
    return [self build];
}

- (id<PBMessage_Builder>)setUnknownFields:(PBUnknownFieldSet*)unknownFields {
    return nil;
}

- (instancetype)mergeUnknownFields:(PBUnknownFieldSet*)other {
    NSParameterAssert(other);
    
    if (other != [PBUnknownFieldSet defaultInstance]) {
        for (NSNumber* number in other.fields) {
            PBField* field = (other.fields)[number];
            [self mergeField:field forNumber:[number intValue]];
        }
    }
    return self;
}

/**
 * Parse an entire message from {@code input} and merge its fields into
 * this set.
 */
- (instancetype)mergeFromCodedInputStream:(PBCodedInputStream*)input {
    NSParameterAssert(input);
    
    while (YES) {
        int32_t tag = [input readTag];
        if (tag == 0 || ![self mergeFieldFrom:tag input:input]) {
            break;
        }
    }
    return self;
}

- (instancetype)mergeFromCodedInputStream:(PBCodedInputStream*)input
                        extensionRegistry:(PBExtensionRegistry*) extensionRegistry
{
    return nil;  // unsupported for unknown fieldsets
}

- (instancetype)mergeFromData:(NSData*)data {
    NSParameterAssert(data);
    
    PBCodedInputStream* input = [PBCodedInputStream streamWithData:data];
    [self mergeFromCodedInputStream:input];
    [input checkLastTagWas:0];
    return self;
}


- (instancetype)mergeFromData:(NSData*)data
            extensionRegistry:(PBExtensionRegistry*)extensionRegistry
{
    NSParameterAssert(data);
    
    PBCodedInputStream* input = [PBCodedInputStream streamWithData:data];
    [self mergeFromCodedInputStream:input extensionRegistry:extensionRegistry];
    [input checkLastTagWas:0];
    return self;
}

- (instancetype)mergeFromInputStream:(NSInputStream*)input {
    return nil;
}

- (instancetype)mergeFromInputStream:(NSInputStream*)input
                   extensionRegistry:(PBExtensionRegistry*)extensionRegistry
{
    return nil;
}


@end
