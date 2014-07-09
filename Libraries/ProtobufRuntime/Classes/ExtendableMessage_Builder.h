//
//  ExtendableMessage_Builder.h
//  Protocol Buffers for Objective C
//
//  Copyright 2014 Ed Preston
//  Copyright 2010 Booyah Inc.
//  Copyright 2008 Cyrus Najmabadi
//

#import "GeneratedMessage_Builder.h"


@class PBExtendableMessage;
@class PBExtensionField;


@interface PBExtendableMessage_Builder : PBGeneratedMessage_Builder

- (id)getExtension:(PBExtensionField *) extension;

- (BOOL)hasExtension:(PBExtensionField *) extension;

- (instancetype)setExtension:(PBExtensionField *)extension
                                        value:(id)value;

- (instancetype)addExtension:(PBExtensionField *)extension
                                        value:(id)value;

- (instancetype)setExtension:(PBExtensionField *)extension
                                        index:(int32_t)index
                                        value:(id)value;

- (instancetype)clearExtension:(PBExtensionField *)extension;

/* @protected */
- (void)mergeExtensionFields:(PBExtendableMessage*) other;

@end
