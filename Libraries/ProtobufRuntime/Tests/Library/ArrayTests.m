// Protocol Buffers for Objective C
//
// Copyright 2010 Booyah Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "ArrayTests.h"

#import "PBArray.h"

@implementation ArrayTests

#pragma mark PBArray

- (void)testCount
{
	const int32_t kValues[3] = { 1, 2, 3 };
	PBArray *array = [[PBArray alloc] initWithValues:kValues count:3 valueType:PBArrayValueTypeInt32];
	XCTAssertEqual([array count], (NSUInteger)3);
	XCTAssertEqual(array.count, (NSUInteger)3);
}

- (void)testValueType
{
	const int32_t kValues[3] = { 1, 2, 3 };
	PBArray *array = [[PBArray alloc] initWithValues:kValues count:3 valueType:PBArrayValueTypeInt32];
	XCTAssertEqual(array.valueType, PBArrayValueTypeInt32);
}

- (void)testPrimitiveAccess
{
	const int32_t kValues[3] = { 1, 2, 3 };
	PBArray *array = [[PBArray alloc] initWithValues:kValues count:3 valueType:PBArrayValueTypeInt32];
	XCTAssertEqual([array int32AtIndex:1], 2);
}


- (void)testEmpty
{
	PBArray *array = [[PBArray alloc] init];
	XCTAssertEqual(array.count, (NSUInteger)0);
	XCTAssertEqual(array.valueType, PBArrayValueTypeBool);
	XCTAssertEqual(array.data, (const void *)nil);
	XCTAssertThrowsSpecificNamed([array boolAtIndex:0], NSException, NSRangeException);
}
/*
- (void)testCopy
{
	const int32_t kValues[3] = { 1, 2, 3 };
	PBArray *original = [[PBArray alloc] initWithValues:kValues count:3 valueType:PBArrayValueTypeInt32];
	PBArray *copy = [original copy];
	XCTAssertEqual(original.valueType, copy.valueType, nil);
	XCTAssertEqual(original.count, copy.count, nil);
	XCTAssertEqual([original int32AtIndex:1], [copy int32AtIndex:1], nil);
}
*/

- (void)testArrayAppendingArray
{
	const int32_t kValues[3] = { 1, 2, 3 };
	PBArray *a = [[PBArray alloc] initWithValues:kValues count:3 valueType:PBArrayValueTypeInt32];
	PBArray *b = [[PBArray alloc] initWithValues:kValues count:3 valueType:PBArrayValueTypeInt32];

	PBArray *copy = [a arrayByAppendingArray:b] ;
	XCTAssertEqual(copy.valueType, a.valueType);
	XCTAssertEqual(copy.count, a.count + b.count);

}

- (void)testAppendArrayTypeException
{
	const int32_t kValuesA[3] = { 1, 2, 3 };
	const int64_t kValuesB[3] = { 1, 2, 3 };
	PBArray *a = [[PBArray alloc] initWithValues:kValuesA count:3 valueType:PBArrayValueTypeInt32];
	PBArray *b = [[PBArray alloc] initWithValues:kValuesB count:3 valueType:PBArrayValueTypeInt64];
	XCTAssertThrowsSpecificNamed([a arrayByAppendingArray:b], NSException, PBArrayTypeMismatchException);
}

- (void)testRangeException
{
	const int32_t kValues[3] = { 1, 2, 3 };
	PBArray *array = [[PBArray alloc] initWithValues:kValues count:3 valueType:PBArrayValueTypeInt32];
	XCTAssertThrowsSpecificNamed([array int32AtIndex:10], NSException, NSRangeException);
}

- (void)testTypeMismatchException
{
	const int32_t kValues[3] = { 1, 2, 3 };
	PBArray *array = [[PBArray alloc] initWithValues:kValues count:3 valueType:PBArrayValueTypeInt32];
	XCTAssertThrowsSpecificNamed([array boolAtIndex:0], NSException, PBArrayTypeMismatchException);
}

- (void)testNumberExpectedException
{
	NSArray *objects = @[@"Test"];
	XCTAssertThrowsSpecificNamed([[PBArray alloc] initWithArray:objects valueType:PBArrayValueTypeInt32],
								NSException, PBArrayNumberExpectedException);
}

#pragma mark PBAppendableArray
/*
- (void)testAddValue
{
	PBAppendableArray *array = [[PBAppendableArray alloc] initWithValueType:PBArrayValueTypeInt32];
	[array addInt32:1];
	[array addInt32:4];
	XCTAssertEqual(array.count, (NSUInteger)2, nil);
	XCTAssertThrowsSpecificNamed([array addBool:NO], NSException, PBArrayTypeMismatchException, nil);
}



- (void)testAppendArray
{
	const int32_t kValues[3] = { 1, 2, 3 };
	PBArray *source = [[PBArray alloc] initWithValues:kValues count:3 valueType:PBArrayValueTypeInt32];
	PBAppendableArray *array = [[PBAppendableArray alloc] initWithValueType:PBArrayValueTypeInt32];
	[array appendArray:source];
	XCTAssertEqual(array.count, source.count, nil);
	XCTAssertEqual([array int32AtIndex:1], 2, nil);
}
*/
- (void)testAppendValues
{
	const int32_t kValues[3] = { 1, 2, 3 };
	PBAppendableArray *array = [[PBAppendableArray alloc] initWithValueType:PBArrayValueTypeInt32];
	[array appendValues:kValues count:3];
	XCTAssertEqual(array.count, (NSUInteger)3);
	XCTAssertEqual([array int32AtIndex:1], 2);
}

- (void)testEqualValues
{
	const int32_t kValues[3] = { 1, 2, 3 };
	PBArray *array1 = [[PBArray alloc] initWithValues:kValues count:2 valueType:PBArrayValueTypeInt32];

	// Test self equality.
	XCTAssertEqualObjects(array1, array1);

	PBArray *array2 = [[PBArray alloc] initWithValues:kValues count:2 valueType:PBArrayValueTypeInt32];
	// Test other equality.
	XCTAssertEqualObjects(array1, array2);

	// Test non equality of nil.
	XCTAssertFalse([array1 isEqual:nil]);

	// Test non equality of other object type.
	XCTAssertFalse([array1 isEqual:@""]);

	// Test non equality of arrays of different sizes with same prefix.
	PBArray *array3 = [[PBArray alloc] initWithValues:kValues count:3 valueType:PBArrayValueTypeInt32];
	XCTAssertFalse([array1 isEqual:array3]);

	// Test non equality of arrays of same sizes with different contents.
	const int32_t kValues2[2] = { 2, 1 };
	PBArray *array4 = [[PBArray alloc] initWithValues:kValues2 count:2 valueType:PBArrayValueTypeInt32];
	XCTAssertFalse([array1 isEqual:array4]);

}

@end