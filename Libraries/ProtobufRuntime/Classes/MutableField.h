//
//  MutableField.h
//  Protocol Buffers for Objective C
//
//  Copyright 2014 Ed Preston
//  Copyright 2010 Booyah Inc.
//  Copyright 2008 Cyrus Najmabadi
//

#import "Field.h"


@class PBUnknownFieldSet;


@interface PBMutableField : PBField

+ (instancetype)field;

- (instancetype)mergeFromField:(PBField *)otherField;

- (instancetype)clear;

- (instancetype)addVarint:(int64_t)value;
- (instancetype)addFixed32:(int32_t)value;
- (instancetype)addFixed64:(int64_t)value;
- (instancetype)addLengthDelimited:(NSData *)value;
- (instancetype)addGroup:(PBUnknownFieldSet *)value;

@end
