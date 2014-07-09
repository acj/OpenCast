//
//  UnknownFieldSet.h
//  Protocol Buffers for Objective C
//
//  Copyright 2014 Ed Preston
//  Copyright 2010 Booyah Inc.
//  Copyright 2008 Cyrus Najmabadi
//


@class PBCodedOutputStream;
@class PBField;
@class PBUnknownFieldSet_Builder;


@interface PBUnknownFieldSet : NSObject

@property (readonly, strong) NSDictionary* fields;

+ (instancetype)defaultInstance;

+ (instancetype)setWithFields:(NSMutableDictionary*)fields;
+ (instancetype)parseFromData:(NSData*)data;

+ (PBUnknownFieldSet_Builder*)builder;
+ (PBUnknownFieldSet_Builder*)builderWithUnknownFields:(PBUnknownFieldSet*)other;

- (void)writeAsMessageSetTo:(PBCodedOutputStream*)output;
- (void)writeToCodedOutputStream:(PBCodedOutputStream*)output;
- (NSData*)data;

- (int32_t)serializedSize;
- (int32_t)serializedSizeAsMessageSet;

- (BOOL)hasField:(int32_t)number;
- (PBField*)getField:(int32_t)number;

- (void)writeDescriptionTo:(NSMutableString*)output
                withIndent:(NSString*)indent;

@end
