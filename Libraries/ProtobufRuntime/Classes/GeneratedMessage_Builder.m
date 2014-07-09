//
//  GeneratedMessage_Builder.h
//  Protocol Buffers for Objective C
//
//  Copyright 2014 Ed Preston
//  Copyright 2010 Booyah Inc.
//  Copyright 2008 Cyrus Najmabadi
//

#import "GeneratedMessage_Builder.h"

#import "GeneratedMessage.h"
#import "Message.h"
#import "Message_Builder.h"
#import "UnknownFieldSet.h"
#import "UnknownFieldSet_Builder.h"
#import "CodedInputStream.h"
#import "ExtensionRegistry.h"



// redefine PBGeneratedMessage's unknownFields with a class extention so it is
// writable to the message builder.
@interface PBGeneratedMessage ()
@property (strong) PBUnknownFieldSet* unknownFields;
@end




#pragma mark - PBGeneratedMessage_Builder

@implementation PBGeneratedMessage_Builder

- (instancetype)clear {
    return nil;
}

- (instancetype)clone {
    return nil;
}


#pragma mark - Message Creation

- (id<PBMessage>)defaultMessageInstance {
    return nil;
}

- (id<PBMessage>)build {
    return nil;
}

- (id<PBMessage>)buildPartial {
    return nil;
}


#pragma mark - State

/**
 * Get the message being built.  We don't just pass this to the
 * constructor because it becomes null when build() is called.
 */
- (PBGeneratedMessage *)internalGetResult {
    return nil;
}

- (BOOL)isInitialized {
    return self.internalGetResult.isInitialized;
}

- (void)checkInitializedParsed {
    PBGeneratedMessage* result = self.internalGetResult;
    if (result != nil && !result.isInitialized) {
        // Error
        return;
    }
}

- (void)checkInitialized {
    PBGeneratedMessage* result = self.internalGetResult;
    if (result != nil && !result.isInitialized) {
        // Error
        return;
    }
}


#pragma mark - Merge Methods

- (instancetype)mergeFromCodedInputStream:(PBCodedInputStream*)input {
    NSParameterAssert(input);

    return [self mergeFromCodedInputStream:input
                         extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}

- (instancetype)mergeFromCodedInputStream:(PBCodedInputStream*)input
                        extensionRegistry:(PBExtensionRegistry*)extensionRegistry {
    return nil;
}

- (id<PBMessage_Builder>)mergeFromData:(NSData *)data {
    NSParameterAssert(data);
    
    PBCodedInputStream* input = [PBCodedInputStream streamWithData:data];
    [self mergeFromCodedInputStream:input];
    [input checkLastTagWas:0];
    return self;
}

- (id<PBMessage_Builder>)mergeFromData:(NSData *)data
                     extensionRegistry:(PBExtensionRegistry*)extensionRegistry
{
    NSParameterAssert(data);
    
    PBCodedInputStream* input = [PBCodedInputStream streamWithData:data];
    [self mergeFromCodedInputStream:input extensionRegistry:extensionRegistry];
    [input checkLastTagWas:0];
    return self;
}

- (id<PBMessage_Builder>) mergeFromInputStream:(NSInputStream *)input {
    NSParameterAssert(input);
    
    PBCodedInputStream* codedInput = [PBCodedInputStream streamWithInputStream:input];
    [self mergeFromCodedInputStream:codedInput];
    [codedInput checkLastTagWas:0];
    return self;
}

- (id<PBMessage_Builder>)mergeFromInputStream:(NSInputStream *)input
                            extensionRegistry:(PBExtensionRegistry*)extensionRegistry
{
    NSParameterAssert(input);
    
    PBCodedInputStream* codedInput = [PBCodedInputStream streamWithInputStream:input];
    [self mergeFromCodedInputStream:codedInput extensionRegistry:extensionRegistry];
    [codedInput checkLastTagWas:0];
    return self;
}


#pragma mark - Unknown Fields

- (PBUnknownFieldSet*)unknownFields {
    return self.internalGetResult.unknownFields;
}

- (id<PBMessage_Builder>)setUnknownFields:(PBUnknownFieldSet*)unknownFields {
    self.internalGetResult.unknownFields = unknownFields;
    return self;
}

- (id<PBMessage_Builder>)mergeUnknownFields:(PBUnknownFieldSet*)unknownFields {
    NSParameterAssert(unknownFields);
    
    PBGeneratedMessage* result = self.internalGetResult;
    result.unknownFields =
    [[[PBUnknownFieldSet builderWithUnknownFields:result.unknownFields]
      mergeUnknownFields:unknownFields] build];
    return self;
}

/**
 * Called by subclasses to parse an unknown field.
 * @return {@code YES} unless the tag is an end-group tag.
 */
- (BOOL) parseUnknownField:(PBCodedInputStream*)input
             unknownFields:(PBUnknownFieldSet_Builder*)unknownFields
         extensionRegistry:(PBExtensionRegistry*)extensionRegistry
                       tag:(int32_t)tag
{
    NSParameterAssert(input);
    NSParameterAssert(unknownFields);
    
    return [unknownFields mergeFieldFrom:tag input:input];
}


@end
