//
//  Field.h
//  Protocol Buffers for Objective C
//
//  Copyright 2014 Ed Preston
//  Copyright 2010 Booyah Inc.
//  Copyright 2008 Cyrus Najmabadi
//

#import <Foundation/Foundation.h>


@class PBArray;
@class PBAppendableArray;
@class PBCodedOutputStream;


@interface PBField : NSObject {
@protected
	PBAppendableArray *	_varintArray;
	PBAppendableArray *	_fixed32Array;
	PBAppendableArray *	_fixed64Array;
	NSMutableArray *	_lengthDelimitedArray;
	NSMutableArray *	_groupArray;
}

@property (nonatomic,strong,readonly) PBArray *	varintArray;
@property (nonatomic,strong,readonly) PBArray *	fixed32Array;
@property (nonatomic,strong,readonly) PBArray *	fixed64Array;
@property (nonatomic,strong,readonly) NSArray *	lengthDelimitedArray;
@property (nonatomic,strong,readonly) NSArray *	groupArray;

+ (instancetype)defaultInstance;

- (int32_t)getSerializedSize:(int32_t)fieldNumber;
- (int32_t)getSerializedSizeAsMessageSetExtension:(int32_t)fieldNumber;

- (void)writeTo:(int32_t)fieldNumber output:(PBCodedOutputStream *)output;

- (void)writeAsMessageSetExtensionTo:(int32_t)fieldNumber
                              output:(PBCodedOutputStream *)output;

- (void)writeDescriptionFor:(int32_t) fieldNumber
                         to:(NSMutableString*) output
                 withIndent:(NSString*) indent;

@end
