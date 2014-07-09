//
//  MutableExtensionRegistry.m
//  Protocol Buffers for Objective C
//
//  Copyright 2014 Ed Preston
//  Copyright 2010 Booyah Inc.
//  Copyright 2008 Cyrus Najmabadi
//

#import "MutableExtensionRegistry.h"

#import "ExtensionField.h"


@implementation PBMutableExtensionRegistry {
    NSMutableDictionary* _mutableClassMap;
}

- (instancetype)initWithClassMap:(NSMutableDictionary *)mutableClassMap {
    
    self = [super initWithClassMap:mutableClassMap];
    if (self == nil) {
        return nil;
    }
    
    _mutableClassMap = mutableClassMap;

    return self;
}

+ (instancetype)registry {
    return [[PBMutableExtensionRegistry alloc] initWithClassMap:[NSMutableDictionary dictionary]] ;
}

- (void)addExtension:(PBExtensionField *)extension {
    if (extension == nil) {
        return;
    }
    
    Class extendedClass = [extension extendedClass];
    id key = [self keyForClass:extendedClass];
    
    NSMutableDictionary* extensionMap = _classMap[key];
    if (extensionMap == nil) {
        extensionMap = [NSMutableDictionary dictionary];
        _mutableClassMap[key] = extensionMap;
    }
    
    extensionMap[@([extension fieldNumber])] = extension;
}


@end
