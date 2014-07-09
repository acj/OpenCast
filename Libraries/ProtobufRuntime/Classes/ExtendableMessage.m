//
//  ExtendableMessage.m
//  Protocol Buffers for Objective C
//
//  Copyright 2014 Ed Preston
//  Copyright 2010 Booyah Inc.
//  Copyright 2008 Cyrus Najmabadi
//

#import "ExtendableMessage.h"

#import "ExtensionField.h"

/**
 * Generated message classes for message types that contain extension ranges
 * subclass this.
 *
 * <p>This class implements type-safe accessors for extensions.  They
 * implement all the same operations that you can do with normal fields --
 * e.g. "has", "get", and "getCount" -- but for extensions.  The extensions
 * are identified using instances of the class {@link GeneratedExtension};
 * the protocol compiler generates a static instance of this class for every
 * extension in its input.  Through the magic of generics, all is made
 * type-safe.
 *
 * <p>For example, imagine you have the {@code .proto} file:
 *
 * <pre>
 * option java_class = "MyProto";
 *
 * message Foo {
 *   extensions 1000 to max;
 * }
 *
 * extend Foo {
 *   optional int32 bar;
 * }
 * </pre>
 *
 * <p>Then you might write code like:
 *
 * <pre>
 * MyProto.Foo foo = getFoo();
 * int i = foo.getExtension(MyProto.bar);
 * </pre>
 *
 * <p>See also {@link ExtendableBuilder}.
 */

@implementation PBExtendableMessage


- (BOOL)isInitialized:(id)object {
    
    if ([object isKindOfClass:[NSArray class]]) {
        for (id child in object) {
            if (![self isInitialized:child]) {
                return NO;
            }
        }
    } else if ([object conformsToProtocol:@protocol(PBMessage)]) {
        return [object isInitialized];
    }
    
    return YES;
}

- (BOOL)extensionsAreInitialized {
    return [self isInitialized:_extensionMap.allValues];
}

- (id)getExtension:(PBExtensionField *)extension {
    NSParameterAssert(extension);
    
    [self ensureExtensionIsRegistered:extension];
    id value = _extensionMap[@([extension fieldNumber])];
    if (value != nil) {
        return value;
    }
    
    return [extension defaultValue];
}

- (void)ensureExtensionIsRegistered:(PBExtensionField *)extension {
    NSParameterAssert(extension);
    
    if ([extension extendedClass] != [self class]) {
        NSAssert(NO, @"Trying to use an extension for another type.");
        return;
    }
    
    if (_extensionRegistry == nil) {
        self.extensionRegistry = [NSMutableDictionary dictionary];
    }
    _extensionRegistry[@([extension fieldNumber])] = extension;
}

- (BOOL)hasExtension:(PBExtensionField *)extension {
    NSParameterAssert(extension);
    
    BOOL exists = NO;
    id object = _extensionMap[@([extension fieldNumber])];
    if (object != nil) {
        exists = YES;
    }
    
    return exists;
}

- (void)writeExtensionsToCodedOutputStream:(PBCodedOutputStream*)output
                                      from:(int32_t)startInclusive
                                        to:(int32_t)endExclusive
{
    NSParameterAssert(output);

    NSArray* sortedKeys = [_extensionMap.allKeys sortedArrayUsingSelector:@selector(compare:)];
    for (NSNumber* number in sortedKeys) {
        int32_t fieldNumber = [number intValue];
        if (fieldNumber >= startInclusive && fieldNumber < endExclusive) {
            PBExtensionField * extension = _extensionRegistry[number];
            id value = _extensionMap[number];
            [extension writeValue:value includingTagToCodedOutputStream:output];
        }
    }
}

- (void)writeExtensionDescriptionToMutableString:(NSMutableString*) output
                                            from:(int32_t)startInclusive
                                              to:(int32_t)endExclusive
                                      withIndent:(NSString*)indent
{
    NSParameterAssert(output);
    
    NSArray* sortedKeys = [_extensionMap.allKeys sortedArrayUsingSelector:@selector(compare:)];
    for (NSNumber* number in sortedKeys) {
        int32_t fieldNumber = [number intValue];
        if (fieldNumber >= startInclusive && fieldNumber < endExclusive) {
            PBExtensionField * extension = _extensionRegistry[number];
            id value = _extensionMap[number];
            [extension writeDescriptionOf:value to:output withIndent:indent];
        }
    }
}

- (BOOL)isEqualExtensionsInOther:(PBExtendableMessage*)otherMessage
                            from:(int32_t)startInclusive
                              to:(int32_t)endExclusive
{
    NSParameterAssert(otherMessage);
    
    NSArray* sortedKeys = [_extensionMap.allKeys sortedArrayUsingSelector:@selector(compare:)];
    for (NSNumber* number in sortedKeys) {
        int32_t fieldNumber = [number intValue];
        if (fieldNumber >= startInclusive && fieldNumber < endExclusive) {
            id value = _extensionMap[number];
            id otherValue = (otherMessage.extensionMap)[number];
            if (![value isEqual:otherValue]) {
                return NO;
            }
        }
    }
    return YES;
}

- (NSUInteger)hashExtensionsFrom:(int32_t)startInclusive
                              to:(int32_t)endExclusive
{
    NSUInteger hashCode = 0;
    NSArray* sortedKeys = [_extensionMap.allKeys sortedArrayUsingSelector:@selector(compare:)];
    for (NSNumber* number in sortedKeys) {
        int32_t fieldNumber = [number intValue];
        if (fieldNumber >= startInclusive && fieldNumber < endExclusive) {
            id value = _extensionMap[number];
            hashCode = hashCode * 31 + [value hash];
        }
    }
    return hashCode;
}

- (int32_t)extensionsSerializedSize {
    int32_t size = 0;
    for (NSNumber* number in _extensionMap) {
        PBExtensionField * extension = _extensionRegistry[number];
        id value = _extensionMap[number];
        size += [extension computeSerializedSizeIncludingTag:value];
    }
    
    return size;
}


@end
