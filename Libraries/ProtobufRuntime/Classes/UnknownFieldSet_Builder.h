//
//  UnknownFieldSet_Builder.h
//  Protocol Buffers for Objective C
//
//  Copyright 2014 Ed Preston
//  Copyright 2010 Booyah Inc.
//  Copyright 2008 Cyrus Najmabadi
//

#import "Message_Builder.h"


@class PBField;
@class PBMutableField;
@class PBUnknownFieldSet;
@class PBCodedInputStream;


@interface PBUnknownFieldSet_Builder : NSObject <PBMessage_Builder>

+ (instancetype)createBuilder:(PBUnknownFieldSet*)unknownFields;

- (PBUnknownFieldSet*)build;

- (instancetype)mergeUnknownFields:(PBUnknownFieldSet*)other;

- (instancetype)mergeFromCodedInputStream:(PBCodedInputStream*)input;
- (instancetype)mergeFromData:(NSData*)data;
- (instancetype)mergeFromInputStream:(NSInputStream*)input;

- (instancetype)mergeVarintField:(int32_t)number value:(int32_t)value;

- (BOOL)mergeFieldFrom:(int32_t)tag input:(PBCodedInputStream*)input;

- (instancetype)addField:(PBField*)field forNumber:(int32_t)number;

- (instancetype)clear;
- (instancetype)mergeField:(PBField*)field forNumber:(int32_t)number;

@end
