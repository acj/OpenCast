//
//  MutableField.h
//  Protocol Buffers for Objective C
//
//  Copyright 2014 Ed Preston
//  Copyright 2010 Booyah Inc.
//  Copyright 2008 Cyrus Najmabadi
//

#import "MutableField.h"

#import "Field.h"
#import "PBArray.h"


@implementation PBMutableField

+ (instancetype)field {
	return [[PBMutableField alloc] init] ;
}

- (instancetype)clear {
	_varintArray = nil;
	_fixed32Array = nil;
	_fixed64Array = nil;
	_lengthDelimitedArray = nil;
	_groupArray = nil;

	return self;
}

- (instancetype)mergeFromField:(PBField *)otherField {
    NSParameterAssert(otherField);
    
	if (otherField.varintArray.count > 0) {
		if (_varintArray == nil) {
			_varintArray = [otherField->_varintArray copy];
		} else {
			[_varintArray appendArray:otherField->_varintArray];
		}
	}

	if (otherField.fixed32Array.count > 0) {
		if (_fixed32Array == nil) {
			_fixed32Array = [otherField->_fixed32Array copy];
		} else {
			[_fixed32Array appendArray:otherField->_fixed32Array];
		}
	}

	if (otherField.fixed64Array.count > 0) {
		if (_fixed64Array == nil) {
			_fixed64Array = [otherField->_fixed64Array copy];
		} else {
			[_fixed64Array appendArray:otherField->_fixed64Array];
		}
	}

	if (otherField.lengthDelimitedArray.count > 0) {
		if (_lengthDelimitedArray == nil) {
			_lengthDelimitedArray = [otherField->_lengthDelimitedArray copy];
		} else {
            [_lengthDelimitedArray addObjectsFromArray:otherField->_lengthDelimitedArray];
		}
	}

	if (otherField.groupArray.count > 0) {
		if (_groupArray == nil) {
			_groupArray = [otherField->_groupArray copy];
		} else {
            [_groupArray addObjectsFromArray:otherField->_groupArray];
		}
	}

	return self;
}

- (instancetype)addVarint:(int64_t)value {
	if (_varintArray == nil) {
		_varintArray = [[PBAppendableArray alloc] initWithValueType:PBArrayValueTypeInt64];
	}
	[_varintArray addInt64:value];

	return self;
}

- (instancetype)addFixed32:(int32_t)value {
	if (_fixed32Array == nil) {
		_fixed32Array = [[PBAppendableArray alloc] initWithValueType:PBArrayValueTypeInt32];
	}
	[_fixed32Array addInt32:value];

	return self;
}

- (instancetype)addFixed64:(int64_t)value {
	if (_fixed64Array == nil) {
		_fixed64Array = [[PBAppendableArray alloc] initWithValueType:PBArrayValueTypeInt64];
	}
	[_fixed64Array addInt64:value];

	return self;
}

- (instancetype)addLengthDelimited:(NSData *)value {
    NSParameterAssert(value);
    
	if (_lengthDelimitedArray == nil) {
		_lengthDelimitedArray = [[NSMutableArray alloc] init];
	}
	[_lengthDelimitedArray addObject:value];

	return self;
}

- (instancetype)addGroup:(PBUnknownFieldSet *)value {
    NSParameterAssert(value);
    
	if (_groupArray == nil) {
		_groupArray = [[NSMutableArray alloc] init];
	}
	[_groupArray addObject:value];

	return self;
}


@end