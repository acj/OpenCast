//
//  UnknownFieldSet.m
//  Protocol Buffers for Objective C
//
//  Copyright 2014 Ed Preston
//  Copyright 2010 Booyah Inc.
//  Copyright 2008 Cyrus Najmabadi
//

#import "UnknownFieldSet.h"

#import "CodedInputStream.h"
#import "CodedOutputStream.h"
#import "Field.h"
#import "UnknownFieldSet_Builder.h"


@implementation PBUnknownFieldSet

static PBUnknownFieldSet* defaultInstance = nil;
+ (void)initialize {
    if (self == [PBUnknownFieldSet class]) {
        defaultInstance = [PBUnknownFieldSet setWithFields:[NSMutableDictionary dictionary]];
    }
}

+ (instancetype)defaultInstance {
    return defaultInstance;
}

- (instancetype)initWithFields:(NSMutableDictionary*)fields {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    _fields = fields;
    return self;
}

+ (instancetype)setWithFields:(NSMutableDictionary*)fields {
    NSParameterAssert(fields);
    
    return [[PBUnknownFieldSet alloc] initWithFields:fields];
}

- (BOOL)hasField:(int32_t)number {
    return _fields[@(number)] != nil;
}

- (PBField*)getField:(int32_t)number {
    PBField* result = _fields[@(number)];
    return (result == nil) ? [PBField defaultInstance] : result;
}

- (void)writeToCodedOutputStream:(PBCodedOutputStream*)output {
    NSParameterAssert(output);
    
    NSArray* sortedKeys = [_fields.allKeys sortedArrayUsingSelector:@selector(compare:)];
    for (NSNumber* number in sortedKeys) {
        PBField* value = _fields[number];
        [value writeTo:number.intValue output:output];
    }
}

- (void)writeToOutputStream:(NSOutputStream*)output {
    NSParameterAssert(output);
    
    PBCodedOutputStream* codedOutput = [PBCodedOutputStream streamWithOutputStream:output];
    [self writeToCodedOutputStream:codedOutput];
    [codedOutput flush];
}

- (void)writeDescriptionTo:(NSMutableString*)output
                withIndent:(NSString *)indent
{
    NSParameterAssert(output);
    
    NSArray* sortedKeys = [_fields.allKeys sortedArrayUsingSelector:@selector(compare:)];
    for (NSNumber* number in sortedKeys) {
        PBField* value = _fields[number];
        [value writeDescriptionFor:number.intValue to:output withIndent:indent];
    }
}

+ (instancetype)parseFromCodedInputStream:(PBCodedInputStream*)input {
    NSParameterAssert(input);
    return [[[PBUnknownFieldSet builder] mergeFromCodedInputStream:input] build];
}

+ (instancetype)parseFromData:(NSData*)data {
    NSParameterAssert(data);
    return [[[PBUnknownFieldSet builder] mergeFromData:data] build];
}

+ (instancetype)parseFromInputStream:(NSInputStream*)input {
    NSParameterAssert(input);
    return [[[PBUnknownFieldSet builder] mergeFromInputStream:input] build];
}

+ (PBUnknownFieldSet_Builder*)builder {
    return [[PBUnknownFieldSet_Builder alloc] init];
}

+ (PBUnknownFieldSet_Builder*)builderWithUnknownFields:(PBUnknownFieldSet*)copyFrom {
    NSParameterAssert(copyFrom);
    return [[PBUnknownFieldSet builder] mergeUnknownFields:copyFrom];
}

/** Get the number of bytes required to encode this set. */
- (int32_t)serializedSize {
    int32_t result = 0;
    for (NSNumber* number in _fields.allKeys) {
        result += [_fields[number] getSerializedSize:number.intValue];
    }
    return result;
}

/**
 * Serializes the set and writes it to {@code output} using
 * {@code MessageSet} wire format.
 */
- (void)writeAsMessageSetTo:(PBCodedOutputStream*)output {
    NSParameterAssert(output);
    for (NSNumber* number in _fields) {
        [_fields[number] writeAsMessageSetExtensionTo:number.intValue output:output];
    }
}

/**
 * Get the number of bytes required to encode this set using
 * {@code MessageSet} wire format.
 */
- (int32_t)serializedSizeAsMessageSet {
    int32_t result = 0;
    for (NSNumber* number in _fields) {
        result += [_fields[number] getSerializedSizeAsMessageSetExtension:number.intValue];
    }
    return result;
}

/**
 * Serializes the message to a {@code ByteString} and returns it. This is
 * just a trivial wrapper around {@link #writeTo(PBCodedOutputStream)}.
 */
- (NSData*)data {
    NSMutableData* data = [NSMutableData dataWithLength:self.serializedSize];
    PBCodedOutputStream* output = [PBCodedOutputStream streamWithData:data];
    
    [self writeToCodedOutputStream:output];
    return data;
}


@end
