//
//  GeneratedMessage.h
//  Protocol Buffers for Objective C
//
//  Copyright 2014 Ed Preston
//  Copyright 2010 Booyah Inc.
//  Copyright 2008 Cyrus Najmabadi
//

#import "GeneratedMessage.h"


#import "GeneratedMessage_Builder.h"
#import "UnknownFieldSet.h"
#import "CodedOutputStream.h"


@interface PBGeneratedMessage ()
@property (strong) PBUnknownFieldSet* unknownFields;
@end


@implementation PBGeneratedMessage

- (instancetype) init {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    _unknownFields = [PBUnknownFieldSet defaultInstance];
    _cachedSerializedSize = -1;
    
    return self;
}

- (instancetype)defaultInstance {
    // defined here for autocomplete / type checking rather than id<PBMessage>
    return [[self class] defaultInstance];
}

+ (instancetype)defaultInstance {
    return nil;
}


#pragma mark - State

- (BOOL)isInitialized {
    return NO;
}

- (int32_t)serializedSize {
    NSAssert(NO, @"serializedSize not implemented in subclass.");
    return -1;
}

- (NSData*)data {
    NSMutableData* data = [NSMutableData dataWithLength:self.serializedSize];
    PBCodedOutputStream* stream = [PBCodedOutputStream streamWithData:data];
    [self writeToCodedOutputStream:stream];
    return data;
}


#pragma mark - Access to Corresponding Builder

- (id<PBMessage_Builder>)builder {
    return nil;
}

+ (id<PBMessage_Builder>)builder {
    // required so the parseFromData methods can be moved down into the library
    return nil;
}

- (id<PBMessage_Builder>)toBuilder {
    return nil;
}


#pragma mark - Writing

- (void)writeToOutputStream:(NSOutputStream*)output {
    NSParameterAssert(output);
    
    PBCodedOutputStream* codedOutput = [PBCodedOutputStream streamWithOutputStream:output];
    [self writeToCodedOutputStream:codedOutput];
    [codedOutput flush];
}

- (void) writeToCodedOutputStream:(PBCodedOutputStream*)output {
    // not implemented in this base class
}


#pragma mark - Parsing

+ (instancetype)parseFromData:(NSData *)data {
    NSParameterAssert(data);
    
    return [[[self builder] mergeFromData:data] build];
}

+ (instancetype)parseFromData:(NSData *)data
            extensionRegistry:(PBExtensionRegistry*)extensionRegistry
{
    NSParameterAssert(data);
    
    return [[[self builder] mergeFromData:data
                        extensionRegistry:extensionRegistry] build];
}

+ (instancetype)parseFromInputStream:(NSInputStream *)input {
    NSParameterAssert(input);
    
    return [[[self builder] mergeFromInputStream:input] build];
}

+ (instancetype)parseFromInputStream:(NSInputStream *)input
                   extensionRegistry:(PBExtensionRegistry*)extensionRegistry
{
    NSParameterAssert(input);
    
    return [[[self builder] mergeFromInputStream:input
                               extensionRegistry:extensionRegistry] build];
}

+ (instancetype)parseFromCodedInputStream:(PBCodedInputStream*)input {
    NSParameterAssert(input);
    
    return [[[self builder] mergeFromCodedInputStream:input] build];
}

+ (instancetype)parseFromCodedInputStream:(PBCodedInputStream*)input
                        extensionRegistry:(PBExtensionRegistry*)extensionRegistry
{
    NSParameterAssert(input);
    
    return [[[self builder] mergeFromCodedInputStream:input
                                    extensionRegistry:extensionRegistry] build];
}


#pragma mark - Debug Descriptions

- (NSString*)description {
    NSMutableString* output = [NSMutableString string];
    [self writeDescriptionTo:output withIndent:@""];
    return output;
}

- (void)writeDescriptionTo:(NSMutableString *) output
                withIndent:(NSString*) indent {
    // not implemented in this base class
}


@end
