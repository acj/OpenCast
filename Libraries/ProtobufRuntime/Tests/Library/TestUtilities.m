// Protocol Buffers, Objective C
//
// Copyright 2010 Booyah Inc.
// Copyright 2008 Cyrus Najmabadi
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

#import "TestUtilities.h"
#import "ProtocolModels.h"
#import "unittest.pb.h"

@implementation TestUtilities

+ (NSData*) getData:(NSString*) str {
    return [str dataUsingEncoding:NSUTF8StringEncoding];
}


+ (NSData*) goldenData {
    NSString* path = [[NSBundle mainBundle] pathForResource:@"golden_message" ofType:nil];
    if (path == nil) {
        path = @"golden_message";
    }
    NSData* goldenData = [NSData dataWithContentsOfFile:path];
    return goldenData;
}


+ (NSData*) goldenPackedFieldsData {
    NSString* path = [[NSBundle mainBundle] pathForResource:@"golden_packed_fields_message" ofType:nil];
    if (path == nil) {
        path = @"golden_packed_fields_message";
    }
    NSData* goldenData = [NSData dataWithContentsOfFile:path];
    return goldenData;
}


- (void) failWithException:(NSException *) anException {
    @throw anException;
}


// -------------------------------------------------------------------

/**
 * Modify the repeated extensions of {@code message} to contain the values
 * expected by {@code assertRepeatedExtensionsModified()}.
 */
+ (void) modifyRepeatedExtensions:(TestAllExtensions_Builder*) message {
    [message setExtension:[UnittestRoot repeatedInt32Extension] index:1 value:@501];
    [message setExtension:[UnittestRoot repeatedInt64Extension] index:1 value:@502];
    [message setExtension:[UnittestRoot repeatedUint32Extension] index:1 value:@503];
    [message setExtension:[UnittestRoot repeatedUint64Extension] index:1 value:@504];
    [message setExtension:[UnittestRoot repeatedSint32Extension] index:1 value:@505];
    [message setExtension:[UnittestRoot repeatedSint64Extension] index:1 value:@506];
    [message setExtension:[UnittestRoot repeatedFixed32Extension] index:1 value:@507];
    [message setExtension:[UnittestRoot repeatedFixed64Extension] index:1 value:@508];
    [message setExtension:[UnittestRoot repeatedSfixed32Extension] index:1 value:@509];
    [message setExtension:[UnittestRoot repeatedSfixed64Extension] index:1 value:@510];
    [message setExtension:[UnittestRoot repeatedFloatExtension] index:1 value:@511.0f];
    [message setExtension:[UnittestRoot repeatedDoubleExtension] index:1 value:@512.0];
    [message setExtension:[UnittestRoot repeatedBoolExtension] index:1 value:@YES];
    [message setExtension:[UnittestRoot repeatedStringExtension] index:1 value:@"515"];
    [message setExtension:[UnittestRoot repeatedBytesExtension] index:1 value:[TestUtilities getData:@"516"]];
    
    [message setExtension:[UnittestRoot RepeatedGroupExtension] index:1 value:
     [[[RepeatedGroup_extension builder] setA:517] build]];
    [message setExtension:[UnittestRoot repeatedNestedMessageExtension] index:1 value:
     [[[TestAllTypes_NestedMessage builder] setBb:518] build]];
    [message setExtension:[UnittestRoot repeatedForeignMessageExtension] index:1 value:
     [[[ForeignMessage builder] setC:519] build]];
    [message setExtension:[UnittestRoot repeatedImportMessageExtension] index:1 value:
     [[[ImportMessage builder] setD:520] build]];
    
    [message setExtension:[UnittestRoot repeatedNestedEnumExtension] index:1 value:
     @(TestAllTypes_NestedEnumFOO)];
    [message setExtension:[UnittestRoot repeatedForeignEnumExtension] index:1 value:
     @(ForeignEnumFOREIGNFOO)];
    [message setExtension:[UnittestRoot repeatedImportEnumExtension] index:1 value:
     @(ImportEnumIMPORTFOO)];
    
    [message setExtension:[UnittestRoot repeatedStringPieceExtension] index:1 value:@"524"];
    [message setExtension:[UnittestRoot repeatedCordExtension] index:1 value:@"525"];
}



/**
 * Assert (using {@code junit.framework.Assert}} that all extensions of
 * {@code message} are set to the values assigned by {@code setAllExtensions}.
 */
- (void) assertAllExtensionsSet:(TestAllExtensions*) message {
    XCTAssertTrue([message hasExtension:[UnittestRoot optionalInt32Extension]], @"");
    XCTAssertTrue([message hasExtension:[UnittestRoot optionalInt64Extension]], @"");
    XCTAssertTrue([message hasExtension:[UnittestRoot optionalUint32Extension]], @"");
    XCTAssertTrue([message hasExtension:[UnittestRoot optionalUint64Extension]], @"");
    XCTAssertTrue([message hasExtension:[UnittestRoot optionalSint32Extension]], @"");
    XCTAssertTrue([message hasExtension:[UnittestRoot optionalSint64Extension]], @"");
    XCTAssertTrue([message hasExtension:[UnittestRoot optionalFixed32Extension]], @"");
    XCTAssertTrue([message hasExtension:[UnittestRoot optionalFixed64Extension]], @"");
    XCTAssertTrue([message hasExtension:[UnittestRoot optionalSfixed32Extension]], @"");
    XCTAssertTrue([message hasExtension:[UnittestRoot optionalSfixed64Extension]], @"");
    XCTAssertTrue([message hasExtension:[UnittestRoot optionalFloatExtension]], @"");
    XCTAssertTrue([message hasExtension:[UnittestRoot optionalDoubleExtension]], @"");
    XCTAssertTrue([message hasExtension:[UnittestRoot optionalBoolExtension]], @"");
    XCTAssertTrue([message hasExtension:[UnittestRoot optionalStringExtension]], @"");
    XCTAssertTrue([message hasExtension:[UnittestRoot optionalBytesExtension]], @"");
    
    XCTAssertTrue([message hasExtension:[UnittestRoot OptionalGroupExtension]], @"");
    XCTAssertTrue([message hasExtension:[UnittestRoot optionalNestedMessageExtension]], @"");
    XCTAssertTrue([message hasExtension:[UnittestRoot optionalForeignMessageExtension]], @"");
    XCTAssertTrue([message hasExtension:[UnittestRoot optionalImportMessageExtension]], @"");
    
    XCTAssertTrue([[message getExtension:[UnittestRoot OptionalGroupExtension]] hasA], @"");
    XCTAssertTrue([[message getExtension:[UnittestRoot optionalNestedMessageExtension]] hasBb], @"");
    XCTAssertTrue([[message getExtension:[UnittestRoot optionalForeignMessageExtension]] hasC], @"");
    XCTAssertTrue([[message getExtension:[UnittestRoot optionalImportMessageExtension]] hasD], @"");
    
    XCTAssertTrue([message hasExtension:[UnittestRoot optionalNestedEnumExtension]], @"");
    XCTAssertTrue([message hasExtension:[UnittestRoot optionalForeignEnumExtension]], @"");
    XCTAssertTrue([message hasExtension:[UnittestRoot optionalImportEnumExtension]], @"");
    
    XCTAssertTrue([message hasExtension:[UnittestRoot optionalStringPieceExtension]], @"");
    XCTAssertTrue([message hasExtension:[UnittestRoot optionalCordExtension]], @"");
    
    XCTAssertTrue(101 == [[message getExtension:[UnittestRoot optionalInt32Extension]] intValue], @"");
    XCTAssertTrue(102L == [[message getExtension:[UnittestRoot optionalInt64Extension]] intValue], @"");
    XCTAssertTrue(103 == [[message getExtension:[UnittestRoot optionalUint32Extension]] intValue], @"");
    XCTAssertTrue(104L == [[message getExtension:[UnittestRoot optionalUint64Extension]] intValue], @"");
    XCTAssertTrue(105 == [[message getExtension:[UnittestRoot optionalSint32Extension]] intValue], @"");
    XCTAssertTrue(106L == [[message getExtension:[UnittestRoot optionalSint64Extension]] intValue], @"");
    XCTAssertTrue(107 == [[message getExtension:[UnittestRoot optionalFixed32Extension]] intValue], @"");
    XCTAssertTrue(108L == [[message getExtension:[UnittestRoot optionalFixed64Extension]] intValue], @"");
    XCTAssertTrue(109 == [[message getExtension:[UnittestRoot optionalSfixed32Extension]] intValue], @"");
    XCTAssertTrue(110L == [[message getExtension:[UnittestRoot optionalSfixed64Extension]] intValue], @"");
    XCTAssertTrue(111.0 == [[message getExtension:[UnittestRoot optionalFloatExtension]] floatValue], @"");
    XCTAssertTrue(112.0 == [[message getExtension:[UnittestRoot optionalDoubleExtension]] doubleValue], @"");
    XCTAssertTrue(YES == [[message getExtension:[UnittestRoot optionalBoolExtension]] boolValue], @"");
    XCTAssertEqualObjects(@"115", [message getExtension:[UnittestRoot optionalStringExtension]], @"");
    XCTAssertEqualObjects([TestUtilities getData:@"116"], [message getExtension:[UnittestRoot optionalBytesExtension]], @"");
    
    XCTAssertTrue(117 == [(OptionalGroup_extension *)[message getExtension:[UnittestRoot OptionalGroupExtension]] a], @"");
    XCTAssertTrue(118 == [(TestAllTypes_NestedMessage *)[message getExtension:[UnittestRoot optionalNestedMessageExtension]] bb], @"");
    XCTAssertTrue(119 == [[message getExtension:[UnittestRoot optionalForeignMessageExtension]] c], @"");
    XCTAssertTrue(120 == [[message getExtension:[UnittestRoot optionalImportMessageExtension]] d], @"");
    
    XCTAssertTrue(TestAllTypes_NestedEnumBAZ == [[message getExtension:[UnittestRoot optionalNestedEnumExtension]] intValue], @"");
    XCTAssertTrue(ForeignEnumFOREIGNBAZ == [[message getExtension:[UnittestRoot optionalForeignEnumExtension]] intValue], @"");
    XCTAssertTrue(ImportEnumIMPORTBAZ == [[message getExtension:[UnittestRoot optionalImportEnumExtension]] intValue], @"");
    
    XCTAssertEqualObjects(@"124", [message getExtension:[UnittestRoot optionalStringPieceExtension]], @"");
    XCTAssertEqualObjects(@"125", [message getExtension:[UnittestRoot optionalCordExtension]], @"");
    
    // -----------------------------------------------------------------
    
    XCTAssertTrue(2 == [[message getExtension:[UnittestRoot repeatedInt32Extension]] count], @"");
    XCTAssertTrue(2 == [[message getExtension:[UnittestRoot repeatedInt64Extension]] count], @"");
    XCTAssertTrue(2 == [[message getExtension:[UnittestRoot repeatedUint32Extension]] count], @"");
    XCTAssertTrue(2 == [[message getExtension:[UnittestRoot repeatedUint64Extension]] count], @"");
    XCTAssertTrue(2 == [[message getExtension:[UnittestRoot repeatedSint32Extension]] count], @"");
    XCTAssertTrue(2 == [[message getExtension:[UnittestRoot repeatedSint64Extension]] count], @"");
    XCTAssertTrue(2 == [[message getExtension:[UnittestRoot repeatedFixed32Extension]] count], @"");
    XCTAssertTrue(2 == [[message getExtension:[UnittestRoot repeatedFixed64Extension]] count], @"");
    XCTAssertTrue(2 == [[message getExtension:[UnittestRoot repeatedSfixed32Extension]] count], @"");
    XCTAssertTrue(2 == [[message getExtension:[UnittestRoot repeatedSfixed64Extension]] count], @"");
    XCTAssertTrue(2 == [[message getExtension:[UnittestRoot repeatedFloatExtension]] count], @"");
    XCTAssertTrue(2 == [[message getExtension:[UnittestRoot repeatedDoubleExtension]] count], @"");
    XCTAssertTrue(2 == [[message getExtension:[UnittestRoot repeatedBoolExtension]] count], @"");
    XCTAssertTrue(2 == [[message getExtension:[UnittestRoot repeatedStringExtension]] count], @"");
    XCTAssertTrue(2 == [[message getExtension:[UnittestRoot repeatedBytesExtension]] count], @"");
    
    XCTAssertTrue(2 == [[message getExtension:[UnittestRoot RepeatedGroupExtension]] count], @"");
    XCTAssertTrue(2 == [[message getExtension:[UnittestRoot repeatedNestedMessageExtension]] count], @"");
    XCTAssertTrue(2 == [[message getExtension:[UnittestRoot repeatedForeignMessageExtension]] count], @"");
    XCTAssertTrue(2 == [[message getExtension:[UnittestRoot repeatedImportMessageExtension]] count], @"");
    XCTAssertTrue(2 == [[message getExtension:[UnittestRoot repeatedNestedEnumExtension]] count], @"");
    XCTAssertTrue(2 == [[message getExtension:[UnittestRoot repeatedForeignEnumExtension]] count], @"");
    XCTAssertTrue(2 == [[message getExtension:[UnittestRoot repeatedImportEnumExtension]] count], @"");
    
    XCTAssertTrue(2 == [[message getExtension:[UnittestRoot repeatedStringPieceExtension]] count], @"");
    XCTAssertTrue(2 == [[message getExtension:[UnittestRoot repeatedCordExtension]] count], @"");
    
    XCTAssertTrue(201 == [[message getExtension:[UnittestRoot repeatedInt32Extension]][0] intValue], @"");;
    XCTAssertTrue(202L == [[message getExtension:[UnittestRoot repeatedInt64Extension]][0] intValue], @"");;
    XCTAssertTrue(203 == [[message getExtension:[UnittestRoot repeatedUint32Extension]][0] intValue], @"");;
    XCTAssertTrue(204L == [[message getExtension:[UnittestRoot repeatedUint64Extension]][0] intValue], @"");
    XCTAssertTrue(205 == [[message getExtension:[UnittestRoot repeatedSint32Extension]][0] intValue], @"");
    XCTAssertTrue(206L == [[message getExtension:[UnittestRoot repeatedSint64Extension]][0] intValue], @"");
    XCTAssertTrue(207 == [[message getExtension:[UnittestRoot repeatedFixed32Extension]][0] intValue], @"");
    XCTAssertTrue(208L == [[message getExtension:[UnittestRoot repeatedFixed64Extension]][0] intValue], @"");
    XCTAssertTrue(209 == [[message getExtension:[UnittestRoot repeatedSfixed32Extension]][0] intValue], @"");
    XCTAssertTrue(210L == [[message getExtension:[UnittestRoot repeatedSfixed64Extension]][0] intValue], @"");
    XCTAssertTrue(211.0 == [[message getExtension:[UnittestRoot repeatedFloatExtension]][0] floatValue], @"");
    XCTAssertTrue(212.0 == [[message getExtension:[UnittestRoot repeatedDoubleExtension]][0] doubleValue], @"");
    XCTAssertTrue(YES == [[message getExtension:[UnittestRoot repeatedBoolExtension]][0] boolValue], @"");
    XCTAssertEqualObjects(@"215", [message getExtension:[UnittestRoot repeatedStringExtension]][0], @"");
    XCTAssertEqualObjects([TestUtilities getData:@"216"], [message getExtension:[UnittestRoot repeatedBytesExtension]][0], @"");
    
    XCTAssertTrue(217 == [(RepeatedGroup_extension *)[message getExtension:[UnittestRoot RepeatedGroupExtension]][0] a], @"");
    XCTAssertTrue(218 == [(TestAllTypes_NestedMessage *)[message getExtension:[UnittestRoot repeatedNestedMessageExtension]][0] bb], @"");
    XCTAssertTrue(219 == [[message getExtension:[UnittestRoot repeatedForeignMessageExtension]][0] c], @"");
    XCTAssertTrue(220 == [[message getExtension:[UnittestRoot repeatedImportMessageExtension]][0] d], @"");
    
    XCTAssertTrue(TestAllTypes_NestedEnumBAR == [[message getExtension:[UnittestRoot repeatedNestedEnumExtension]][0] intValue], @"");
    XCTAssertTrue(ForeignEnumFOREIGNBAR == [[message getExtension:[UnittestRoot repeatedForeignEnumExtension]][0] intValue], @"");
    XCTAssertTrue(ImportEnumIMPORTBAR == [[message getExtension:[UnittestRoot repeatedImportEnumExtension]][0] intValue], @"");
    
    XCTAssertEqualObjects(@"224", [message getExtension:[UnittestRoot repeatedStringPieceExtension]][0], @"");
    XCTAssertEqualObjects(@"225", [message getExtension:[UnittestRoot repeatedCordExtension]][0], @"");
    
    XCTAssertTrue(301 == [[message getExtension:[UnittestRoot repeatedInt32Extension]][1] intValue], @"");
    XCTAssertTrue(302L == [[message getExtension:[UnittestRoot repeatedInt64Extension]][1] intValue], @"");
    XCTAssertTrue(303 == [[message getExtension:[UnittestRoot repeatedUint32Extension]][1] intValue], @"");
    XCTAssertTrue(304L == [[message getExtension:[UnittestRoot repeatedUint64Extension]][1] intValue], @"");
    XCTAssertTrue(305 == [[message getExtension:[UnittestRoot repeatedSint32Extension]][1] intValue], @"");
    XCTAssertTrue(306L == [[message getExtension:[UnittestRoot repeatedSint64Extension]][1] intValue], @"");
    XCTAssertTrue(307 == [[message getExtension:[UnittestRoot repeatedFixed32Extension]][1] intValue], @"");
    XCTAssertTrue(308L == [[message getExtension:[UnittestRoot repeatedFixed64Extension]][1] intValue], @"");
    XCTAssertTrue(309 == [[message getExtension:[UnittestRoot repeatedSfixed32Extension]][1] intValue], @"");
    XCTAssertTrue(310L == [[message getExtension:[UnittestRoot repeatedSfixed64Extension]][1] intValue], @"");
    XCTAssertTrue(311.0 == [[message getExtension:[UnittestRoot repeatedFloatExtension]][1] floatValue], @"");
    XCTAssertTrue(312.0 == [[message getExtension:[UnittestRoot repeatedDoubleExtension]][1] doubleValue], @"");
    XCTAssertTrue(NO == [[message getExtension:[UnittestRoot repeatedBoolExtension]][1] boolValue], @"");
    XCTAssertEqualObjects(@"315", [message getExtension:[UnittestRoot repeatedStringExtension]][1], @"");
    XCTAssertEqualObjects([TestUtilities getData:@"316"], [message getExtension:[UnittestRoot repeatedBytesExtension]][1], @"");
    
    XCTAssertTrue(317 == [(RepeatedGroup_extension *)[message getExtension:[UnittestRoot RepeatedGroupExtension]][1] a], @"");
    XCTAssertTrue(318 == [(TestAllTypes_NestedMessage *)[message getExtension:[UnittestRoot repeatedNestedMessageExtension]][1] bb], @"");
    XCTAssertTrue(319 == [[message getExtension:[UnittestRoot repeatedForeignMessageExtension]][1] c], @"");
    XCTAssertTrue(320 == [[message getExtension:[UnittestRoot repeatedImportMessageExtension]][1] d], @"");
    
    XCTAssertTrue(TestAllTypes_NestedEnumBAZ == [[message getExtension:[UnittestRoot repeatedNestedEnumExtension]][1] intValue], @"");
    XCTAssertTrue(ForeignEnumFOREIGNBAZ == [[message getExtension:[UnittestRoot repeatedForeignEnumExtension]][1] intValue], @"");
    XCTAssertTrue(ImportEnumIMPORTBAZ == [[message getExtension:[UnittestRoot repeatedImportEnumExtension]][1] intValue], @"");
    
    XCTAssertEqualObjects(@"324", [message getExtension:[UnittestRoot repeatedStringPieceExtension]][1], @"");
    XCTAssertEqualObjects(@"325", [message getExtension:[UnittestRoot repeatedCordExtension]][1], @"");
    
    // -----------------------------------------------------------------
    
    XCTAssertTrue([message hasExtension:[UnittestRoot defaultInt32Extension]], @"");
    XCTAssertTrue([message hasExtension:[UnittestRoot defaultInt64Extension]], @"");
    XCTAssertTrue([message hasExtension:[UnittestRoot defaultUint32Extension]], @"");
    XCTAssertTrue([message hasExtension:[UnittestRoot defaultUint64Extension]], @"");
    XCTAssertTrue([message hasExtension:[UnittestRoot defaultSint32Extension]], @"");
    XCTAssertTrue([message hasExtension:[UnittestRoot defaultSint64Extension]], @"");
    XCTAssertTrue([message hasExtension:[UnittestRoot defaultFixed32Extension]], @"");
    XCTAssertTrue([message hasExtension:[UnittestRoot defaultFixed64Extension]], @"");
    XCTAssertTrue([message hasExtension:[UnittestRoot defaultSfixed32Extension]], @"");
    XCTAssertTrue([message hasExtension:[UnittestRoot defaultSfixed64Extension]], @"");
    XCTAssertTrue([message hasExtension:[UnittestRoot defaultFloatExtension]], @"");
    XCTAssertTrue([message hasExtension:[UnittestRoot defaultDoubleExtension]], @"");
    XCTAssertTrue([message hasExtension:[UnittestRoot defaultBoolExtension]], @"");
    XCTAssertTrue([message hasExtension:[UnittestRoot defaultStringExtension]], @"");
    XCTAssertTrue([message hasExtension:[UnittestRoot defaultBytesExtension]], @"");
    
    XCTAssertTrue([message hasExtension:[UnittestRoot defaultNestedEnumExtension]], @"");
    XCTAssertTrue([message hasExtension:[UnittestRoot defaultForeignEnumExtension]], @"");
    XCTAssertTrue([message hasExtension:[UnittestRoot defaultImportEnumExtension]], @"");
    
    XCTAssertTrue([message hasExtension:[UnittestRoot defaultStringPieceExtension]], @"");
    XCTAssertTrue([message hasExtension:[UnittestRoot defaultCordExtension]], @"");
    
    XCTAssertTrue(401 == [[message getExtension:[UnittestRoot defaultInt32Extension]] intValue], @"");
    XCTAssertTrue(402L == [[message getExtension:[UnittestRoot defaultInt64Extension]] intValue], @"");
    XCTAssertTrue(403 == [[message getExtension:[UnittestRoot defaultUint32Extension]] intValue], @"");
    XCTAssertTrue(404L == [[message getExtension:[UnittestRoot defaultUint64Extension]] intValue], @"");
    XCTAssertTrue(405 == [[message getExtension:[UnittestRoot defaultSint32Extension]] intValue], @"");
    XCTAssertTrue(406L == [[message getExtension:[UnittestRoot defaultSint64Extension]] intValue], @"");
    XCTAssertTrue(407 == [[message getExtension:[UnittestRoot defaultFixed32Extension]] intValue], @"");
    XCTAssertTrue(408L == [[message getExtension:[UnittestRoot defaultFixed64Extension]] intValue], @"");
    XCTAssertTrue(409 == [[message getExtension:[UnittestRoot defaultSfixed32Extension]] intValue], @"");
    XCTAssertTrue(410L == [[message getExtension:[UnittestRoot defaultSfixed64Extension]] intValue], @"");
    XCTAssertTrue(411.0 == [[message getExtension:[UnittestRoot defaultFloatExtension]] floatValue], @"");
    XCTAssertTrue(412.0 == [[message getExtension:[UnittestRoot defaultDoubleExtension]] doubleValue], @"");
    XCTAssertTrue(NO == [[message getExtension:[UnittestRoot defaultBoolExtension]] boolValue], @"");
    XCTAssertEqualObjects(@"415", [message getExtension:[UnittestRoot defaultStringExtension]], @"");
    XCTAssertEqualObjects([TestUtilities getData:@"416"], [message getExtension:[UnittestRoot defaultBytesExtension]], @"");
    
    XCTAssertTrue(TestAllTypes_NestedEnumFOO == [[message getExtension:[UnittestRoot defaultNestedEnumExtension]] intValue], @"");
    XCTAssertTrue(ForeignEnumFOREIGNFOO == [[message getExtension:[UnittestRoot defaultForeignEnumExtension]] intValue], @"");
    XCTAssertTrue(ImportEnumIMPORTFOO == [[message getExtension:[UnittestRoot defaultImportEnumExtension]] intValue], @"");
    
    XCTAssertEqualObjects(@"424", [message getExtension:[UnittestRoot defaultStringPieceExtension]], @"");
    XCTAssertEqualObjects(@"425", [message getExtension:[UnittestRoot defaultCordExtension]], @"");
}

+ (void) assertAllExtensionsSet:(TestAllExtensions*) message {
    return [[[TestUtilities alloc] init] assertAllExtensionsSet:message];
}


- (void) assertRepeatedExtensionsModified:(TestAllExtensions*) message {
    // ModifyRepeatedFields only sets the second repeated element of each
    // field.  In addition to verifying this, we also verify that the first
    // element and size were *not* modified.
    XCTAssertTrue(2 == [[message getExtension:[UnittestRoot repeatedInt32Extension]] count], @"");
    XCTAssertTrue(2 == [[message getExtension:[UnittestRoot repeatedInt64Extension]] count], @"");
    XCTAssertTrue(2 == [[message getExtension:[UnittestRoot repeatedUint32Extension]] count], @"");
    XCTAssertTrue(2 == [[message getExtension:[UnittestRoot repeatedUint64Extension]] count], @"");
    XCTAssertTrue(2 == [[message getExtension:[UnittestRoot repeatedSint32Extension]] count], @"");
    XCTAssertTrue(2 == [[message getExtension:[UnittestRoot repeatedSint64Extension]] count], @"");
    XCTAssertTrue(2 == [[message getExtension:[UnittestRoot repeatedFixed32Extension]] count], @"");
    XCTAssertTrue(2 == [[message getExtension:[UnittestRoot repeatedFixed64Extension]] count], @"");
    XCTAssertTrue(2 == [[message getExtension:[UnittestRoot repeatedSfixed32Extension]] count], @"");
    XCTAssertTrue(2 == [[message getExtension:[UnittestRoot repeatedSfixed64Extension]] count], @"");
    XCTAssertTrue(2 == [[message getExtension:[UnittestRoot repeatedFloatExtension]] count], @"");
    XCTAssertTrue(2 == [[message getExtension:[UnittestRoot repeatedDoubleExtension]] count], @"");
    XCTAssertTrue(2 == [[message getExtension:[UnittestRoot repeatedBoolExtension]] count], @"");
    XCTAssertTrue(2 == [[message getExtension:[UnittestRoot repeatedStringExtension]] count], @"");
    XCTAssertTrue(2 == [[message getExtension:[UnittestRoot repeatedBytesExtension]] count], @"");
    
    XCTAssertTrue(2 == [[message getExtension:[UnittestRoot RepeatedGroupExtension]] count], @"");
    XCTAssertTrue(2 == [[message getExtension:[UnittestRoot repeatedNestedMessageExtension]] count], @"");
    XCTAssertTrue(2 == [[message getExtension:[UnittestRoot repeatedForeignMessageExtension]] count], @"");
    XCTAssertTrue(2 == [[message getExtension:[UnittestRoot repeatedImportMessageExtension]] count], @"");
    XCTAssertTrue(2 == [[message getExtension:[UnittestRoot repeatedNestedEnumExtension]] count], @"");
    XCTAssertTrue(2 == [[message getExtension:[UnittestRoot repeatedForeignEnumExtension]] count], @"");
    XCTAssertTrue(2 == [[message getExtension:[UnittestRoot repeatedImportEnumExtension]] count], @"");
    
    XCTAssertTrue(2 == [[message getExtension:[UnittestRoot repeatedStringPieceExtension]] count], @"");
    XCTAssertTrue(2 == [[message getExtension:[UnittestRoot repeatedCordExtension]] count], @"");
    
    XCTAssertTrue(201  == [[message getExtension:[UnittestRoot repeatedInt32Extension]][0] intValue], @"");
    XCTAssertTrue(202L == [[message getExtension:[UnittestRoot repeatedInt64Extension]][0] intValue], @"");
    XCTAssertTrue(203  == [[message getExtension:[UnittestRoot repeatedUint32Extension]][0] intValue], @"");
    XCTAssertTrue(204L == [[message getExtension:[UnittestRoot repeatedUint64Extension]][0] intValue], @"");
    XCTAssertTrue(205  == [[message getExtension:[UnittestRoot repeatedSint32Extension]][0] intValue], @"");
    XCTAssertTrue(206L == [[message getExtension:[UnittestRoot repeatedSint64Extension]][0] intValue], @"");
    XCTAssertTrue(207  == [[message getExtension:[UnittestRoot repeatedFixed32Extension]][0] intValue], @"");
    XCTAssertTrue(208L == [[message getExtension:[UnittestRoot repeatedFixed64Extension]][0] intValue], @"");
    XCTAssertTrue(209  == [[message getExtension:[UnittestRoot repeatedSfixed32Extension]][0] intValue], @"");
    XCTAssertTrue(210L == [[message getExtension:[UnittestRoot repeatedSfixed64Extension]][0] intValue], @"");
    XCTAssertTrue(211.0 == [[message getExtension:[UnittestRoot repeatedFloatExtension]][0] floatValue], @"");
    XCTAssertTrue(212.0 == [[message getExtension:[UnittestRoot repeatedDoubleExtension]][0] doubleValue], @"");
    XCTAssertTrue(YES == [[message getExtension:[UnittestRoot repeatedBoolExtension]][0] boolValue], @"");
    XCTAssertEqualObjects(@"215", [message getExtension:[UnittestRoot repeatedStringExtension]][0], @"");
    XCTAssertEqualObjects([TestUtilities getData:@"216"], [message getExtension:[UnittestRoot repeatedBytesExtension]][0], @"");
    
    XCTAssertTrue(217 == [(RepeatedGroup_extension *)[message getExtension:[UnittestRoot RepeatedGroupExtension]][0] a], @"");
    XCTAssertTrue(218 == [(TestAllTypes_NestedMessage *)[message getExtension:[UnittestRoot repeatedNestedMessageExtension]][0] bb], @"");
    XCTAssertTrue(219 == [[message getExtension:[UnittestRoot repeatedForeignMessageExtension]][0] c], @"");
    XCTAssertTrue(220 == [[message getExtension:[UnittestRoot repeatedImportMessageExtension]][0] d], @"");
    
    XCTAssertTrue(TestAllTypes_NestedEnumBAR ==
                  [[message getExtension:[UnittestRoot repeatedNestedEnumExtension]][0] intValue], @"");
    XCTAssertTrue(ForeignEnumFOREIGNBAR ==
                  [[message getExtension:[UnittestRoot repeatedForeignEnumExtension]][0] intValue], @"");
    XCTAssertTrue(ImportEnumIMPORTBAR ==
                  [[message getExtension:[UnittestRoot repeatedImportEnumExtension]][0] intValue], @"");
    
    XCTAssertEqualObjects(@"224", [message getExtension:[UnittestRoot repeatedStringPieceExtension]][0], @"");
    XCTAssertEqualObjects(@"225", [message getExtension:[UnittestRoot repeatedCordExtension]][0], @"");
    
    // Actually verify the second (modified) elements now.
    XCTAssertTrue(501  == [[message getExtension:[UnittestRoot repeatedInt32Extension]][1] intValue], @"");
    XCTAssertTrue(502L == [[message getExtension:[UnittestRoot repeatedInt64Extension]][1] intValue], @"");
    XCTAssertTrue(503  == [[message getExtension:[UnittestRoot repeatedUint32Extension]][1] intValue], @"");
    XCTAssertTrue(504L == [[message getExtension:[UnittestRoot repeatedUint64Extension]][1] intValue], @"");
    XCTAssertTrue(505  == [[message getExtension:[UnittestRoot repeatedSint32Extension]][1] intValue], @"");
    XCTAssertTrue(506L == [[message getExtension:[UnittestRoot repeatedSint64Extension]][1] intValue], @"");
    XCTAssertTrue(507  == [[message getExtension:[UnittestRoot repeatedFixed32Extension]][1] intValue], @"");
    XCTAssertTrue(508L == [[message getExtension:[UnittestRoot repeatedFixed64Extension]][1] intValue], @"");
    XCTAssertTrue(509  == [[message getExtension:[UnittestRoot repeatedSfixed32Extension]][1] intValue], @"");
    XCTAssertTrue(510L == [[message getExtension:[UnittestRoot repeatedSfixed64Extension]][1] intValue], @"");
    XCTAssertTrue(511.0 == [[message getExtension:[UnittestRoot repeatedFloatExtension]][1] floatValue], @"");
    XCTAssertTrue(512.0 == [[message getExtension:[UnittestRoot repeatedDoubleExtension]][1] doubleValue], @"");
    XCTAssertTrue(YES == [[message getExtension:[UnittestRoot repeatedBoolExtension]][1] boolValue], @"");
    XCTAssertEqualObjects(@"515", [message getExtension:[UnittestRoot repeatedStringExtension]][1], @"");
    XCTAssertEqualObjects([TestUtilities getData:@"516"], [message getExtension:[UnittestRoot repeatedBytesExtension]][1], @"");
    
    XCTAssertTrue(517 == [(RepeatedGroup_extension *)[message getExtension:[UnittestRoot RepeatedGroupExtension]][1] a], @"");
    XCTAssertTrue(518 == [(TestAllTypes_NestedMessage *)[message getExtension:[UnittestRoot repeatedNestedMessageExtension]][1] bb], @"");
    XCTAssertTrue(519 == [[message getExtension:[UnittestRoot repeatedForeignMessageExtension]][1] c], @"");
    XCTAssertTrue(520 == [[message getExtension:[UnittestRoot repeatedImportMessageExtension]][1] d], @"");
    
    XCTAssertTrue(TestAllTypes_NestedEnumFOO ==
                  [[message getExtension:[UnittestRoot repeatedNestedEnumExtension]][1] intValue], @"");
    XCTAssertTrue(ForeignEnumFOREIGNFOO ==
                  [[message getExtension:[UnittestRoot repeatedForeignEnumExtension]][1] intValue], @"");
    XCTAssertTrue(ImportEnumIMPORTFOO ==
                  [[message getExtension:[UnittestRoot repeatedImportEnumExtension]][1] intValue], @"");
    
    XCTAssertEqualObjects(@"524", [message getExtension:[UnittestRoot repeatedStringPieceExtension]][1], @"");
    XCTAssertEqualObjects(@"525", [message getExtension:[UnittestRoot repeatedCordExtension]][1], @"");
}


+ (void) assertRepeatedExtensionsModified:(TestAllExtensions*) message {
    [[[TestUtilities alloc] init]  assertRepeatedExtensionsModified:message];
}


// -------------------------------------------------------------------

/**
 * Assert (using {@code junit.framework.Assert}} that all fields of
 * {@code message} are set to the values assigned by {@code setAllFields}.
 */
- (void) assertAllFieldsSet:(TestAllTypes*) message {
    
    XCTAssertTrue(message.hasOptionalInt32, @"");
    XCTAssertTrue(message.hasOptionalInt64, @"");
    XCTAssertTrue(message.hasOptionalUint32, @"");
    XCTAssertTrue(message.hasOptionalUint64, @"");
    XCTAssertTrue(message.hasOptionalSint32, @"");
    XCTAssertTrue(message.hasOptionalSint64, @"");
    XCTAssertTrue(message.hasOptionalFixed32, @"");
    XCTAssertTrue(message.hasOptionalFixed64, @"");
    XCTAssertTrue(message.hasOptionalSfixed32, @"");
    XCTAssertTrue(message.hasOptionalSfixed64, @"");
    XCTAssertTrue(message.hasOptionalFloat, @"");
    XCTAssertTrue(message.hasOptionalDouble, @"");
    XCTAssertTrue(message.hasOptionalBool, @"");
    XCTAssertTrue(message.hasOptionalString, @"");
    XCTAssertTrue(message.hasOptionalBytes, @"");

    XCTAssertTrue(message.hasOptionalGroup, @"");
    XCTAssertTrue(message.hasOptionalNestedMessage, @"");
    XCTAssertTrue(message.hasOptionalForeignMessage, @"");
    XCTAssertTrue(message.hasOptionalImportMessage, @"");
    
    XCTAssertTrue(message.OptionalGroup.hasA, @"");
    XCTAssertTrue(message.optionalNestedMessage.hasBb, @"");
    XCTAssertTrue(message.optionalForeignMessage.hasC, @"");
    XCTAssertTrue(message.optionalImportMessage.hasD, @"");
    
    XCTAssertTrue(message.hasOptionalNestedEnum, @"");
    XCTAssertTrue(message.hasOptionalForeignEnum, @"");
    XCTAssertTrue(message.hasOptionalImportEnum, @"");
    
    XCTAssertTrue(message.hasOptionalStringPiece, @"");
    XCTAssertTrue(message.hasOptionalCord, @"");
    
    XCTAssertTrue(101 == message.optionalInt32, @"");
    XCTAssertTrue(102 == message.optionalInt64, @"");
    XCTAssertTrue(103 == message.optionalUint32, @"");
    XCTAssertTrue(104 == message.optionalUint64, @"");
    XCTAssertTrue(105 == message.optionalSint32, @"");
    XCTAssertTrue(106 == message.optionalSint64, @"");
    XCTAssertTrue(107 == message.optionalFixed32, @"");
    XCTAssertTrue(108 == message.optionalFixed64, @"");
    XCTAssertTrue(109 == message.optionalSfixed32, @"");
    XCTAssertTrue(110 == message.optionalSfixed64, @"");
    XCTAssertEqualWithAccuracy(111.0f, message.optionalFloat, 0.1, @"");
    XCTAssertEqualWithAccuracy(112.0, message.optionalDouble, 0.1, @"");
    XCTAssertTrue(YES == message.optionalBool, @"");
    XCTAssertEqualObjects(@"115", message.optionalString, @"");
    XCTAssertEqualObjects([TestUtilities getData:@"116"], message.optionalBytes, @"");
    
    XCTAssertTrue(117 == message.OptionalGroup.a, @"");
    XCTAssertTrue(118 == message.optionalNestedMessage.bb, @"");
    XCTAssertTrue(119 == message.optionalForeignMessage.c, @"");
    XCTAssertTrue(120 == message.optionalImportMessage.d, @"");
    
    XCTAssertTrue(TestAllTypes_NestedEnumBAZ == message.optionalNestedEnum, @"");
    XCTAssertTrue(ForeignEnumFOREIGNBAZ == message.optionalForeignEnum, @"");
    XCTAssertTrue(ImportEnumIMPORTBAZ == message.optionalImportEnum, @"");
    
    XCTAssertEqualObjects(@"124", message.optionalStringPiece, @"");
    XCTAssertEqualObjects(@"125", message.optionalCord, @"");
    
    // -----------------------------------------------------------------
    
    XCTAssertTrue(2 == message.repeatedInt32.count, @"");
    XCTAssertTrue(2 == message.repeatedInt64.count, @"");
    XCTAssertTrue(2 == message.repeatedUint32.count, @"");
    XCTAssertTrue(2 == message.repeatedUint64.count, @"");
    XCTAssertTrue(2 == message.repeatedSint32.count, @"");
    XCTAssertTrue(2 == message.repeatedSint64.count, @"");
    XCTAssertTrue(2 == message.repeatedFixed32.count, @"");
    XCTAssertTrue(2 == message.repeatedFixed64.count, @"");
    XCTAssertTrue(2 == message.repeatedSfixed32.count, @"");
    XCTAssertTrue(2 == message.repeatedSfixed64.count, @"");
    XCTAssertTrue(2 == message.repeatedFloat.count, @"");
    XCTAssertTrue(2 == message.repeatedDouble.count, @"");
    XCTAssertTrue(2 == message.repeatedBool.count, @"");
    XCTAssertTrue(2 == message.repeatedString.count, @"");
    XCTAssertTrue(2 == message.repeatedBytes.count, @"");
    
    XCTAssertTrue(2 == message.RepeatedGroup.count, @"");
    XCTAssertTrue(2 == message.repeatedNestedMessage.count, @"");
    XCTAssertTrue(2 == message.repeatedForeignMessage.count, @"");
    XCTAssertTrue(2 == message.repeatedImportMessage.count, @"");
    XCTAssertTrue(2 == message.repeatedNestedEnum.count, @"");
    XCTAssertTrue(2 == message.repeatedForeignEnum.count, @"");
    XCTAssertTrue(2 == message.repeatedImportEnum.count, @"");
    
    XCTAssertTrue(2 == message.repeatedStringPiece.count, @"");
    XCTAssertTrue(2 == message.repeatedCord.count, @"");
    
    XCTAssertTrue(201 == [message repeatedInt32AtIndex:0], @"");
    XCTAssertTrue(202 == [message repeatedInt64AtIndex:0], @"");
    XCTAssertTrue(203 == [message repeatedUint32AtIndex:0], @"");
    XCTAssertTrue(204 == [message repeatedUint64AtIndex:0], @"");
    XCTAssertTrue(205 == [message repeatedSint32AtIndex:0], @"");
    XCTAssertTrue(206 == [message repeatedSint64AtIndex:0], @"");
    XCTAssertTrue(207 == [message repeatedFixed32AtIndex:0], @"");
    XCTAssertTrue(208 == [message repeatedFixed64AtIndex:0], @"");
    XCTAssertTrue(209 == [message repeatedSfixed32AtIndex:0], @"");
    XCTAssertTrue(210 == [message repeatedSfixed64AtIndex:0], @"");
    XCTAssertEqualWithAccuracy(211.0f, [message repeatedFloatAtIndex:0], 0.1, @"");
    XCTAssertEqualWithAccuracy(212.0, [message repeatedDoubleAtIndex:0], 0.1, @"");
    XCTAssertTrue(YES == [message repeatedBoolAtIndex:0], @"");
    XCTAssertEqualObjects(@"215", [message repeatedStringAtIndex:0], @"");
    XCTAssertEqualObjects([TestUtilities getData:@"216"], [message repeatedBytesAtIndex:0], @"");
    
    XCTAssertTrue(217 == [message RepeatedGroupAtIndex:0].a, @"");
    XCTAssertTrue(218 == [message repeatedNestedMessageAtIndex:0].bb, @"");
    XCTAssertTrue(219 == [message repeatedForeignMessageAtIndex:0].c, @"");
    XCTAssertTrue(220 == [message repeatedImportMessageAtIndex:0].d, @"");
    
    XCTAssertTrue(TestAllTypes_NestedEnumBAR == [message repeatedNestedEnumAtIndex:0], @"");
    XCTAssertTrue(ForeignEnumFOREIGNBAR == [message repeatedForeignEnumAtIndex:0], @"");
    XCTAssertTrue(ImportEnumIMPORTBAR == [message repeatedImportEnumAtIndex:0], @"");
    
    XCTAssertEqualObjects(@"224", [message repeatedStringPieceAtIndex:0], @"");
    XCTAssertEqualObjects(@"225", [message repeatedCordAtIndex:0], @"");
    
    XCTAssertTrue(301 == [message repeatedInt32AtIndex:1], @"");
    XCTAssertTrue(302 == [message repeatedInt64AtIndex:1], @"");
    XCTAssertTrue(303 == [message repeatedUint32AtIndex:1], @"");
    XCTAssertTrue(304 == [message repeatedUint64AtIndex:1], @"");
    XCTAssertTrue(305 == [message repeatedSint32AtIndex:1], @"");
    XCTAssertTrue(306 == [message repeatedSint64AtIndex:1], @"");
    XCTAssertTrue(307 == [message repeatedFixed32AtIndex:1], @"");
    XCTAssertTrue(308 == [message repeatedFixed64AtIndex:1], @"");
    XCTAssertTrue(309 == [message repeatedSfixed32AtIndex:1], @"");
    XCTAssertTrue(310 == [message repeatedSfixed64AtIndex:1], @"");
    XCTAssertEqualWithAccuracy(311.0f, [message repeatedFloatAtIndex:1], 0.1, @"");
    XCTAssertEqualWithAccuracy(312.0, [message repeatedDoubleAtIndex:1], 0.1, @"");
    XCTAssertTrue(NO == [message repeatedBoolAtIndex:1], @"");
    XCTAssertEqualObjects(@"315", [message repeatedStringAtIndex:1], @"");
    XCTAssertEqualObjects([TestUtilities getData:@"316"], [message repeatedBytesAtIndex:1], @"");
    
    XCTAssertTrue(317 == [message RepeatedGroupAtIndex:1].a, @"");
    XCTAssertTrue(318 == [message repeatedNestedMessageAtIndex:1].bb, @"");
    XCTAssertTrue(319 == [message repeatedForeignMessageAtIndex:1].c, @"");
    XCTAssertTrue(320 == [message repeatedImportMessageAtIndex:1].d, @"");
    
    XCTAssertTrue(TestAllTypes_NestedEnumBAZ == [message repeatedNestedEnumAtIndex:0], @"");
    XCTAssertTrue(ForeignEnumFOREIGNBAZ == [message repeatedForeignEnumAtIndex:0], @"");
    XCTAssertTrue(ImportEnumIMPORTBAZ == [message repeatedImportEnumAtIndex:0], @"");
    
    XCTAssertEqualObjects(@"324", [message repeatedStringPieceAtIndex:1], @"");
    XCTAssertEqualObjects(@"325", [message repeatedCordAtIndex:1], @"");
    
    // -----------------------------------------------------------------
    
    XCTAssertTrue(message.hasDefaultInt32, @"");
    XCTAssertTrue(message.hasDefaultInt64, @"");
    XCTAssertTrue(message.hasDefaultUint32, @"");
    XCTAssertTrue(message.hasDefaultUint64, @"");
    XCTAssertTrue(message.hasDefaultSint32, @"");
    XCTAssertTrue(message.hasDefaultSint64, @"");
    XCTAssertTrue(message.hasDefaultFixed32, @"");
    XCTAssertTrue(message.hasDefaultFixed64, @"");
    XCTAssertTrue(message.hasDefaultSfixed32, @"");
    XCTAssertTrue(message.hasDefaultSfixed64, @"");
    XCTAssertTrue(message.hasDefaultFloat, @"");
    XCTAssertTrue(message.hasDefaultDouble, @"");
    XCTAssertTrue(message.hasDefaultBool, @"");
    XCTAssertTrue(message.hasDefaultString, @"");
    XCTAssertTrue(message.hasDefaultBytes, @"");
    
    XCTAssertTrue(message.hasDefaultNestedEnum, @"");
    XCTAssertTrue(message.hasDefaultForeignEnum, @"");
    XCTAssertTrue(message.hasDefaultImportEnum, @"");
    
    XCTAssertTrue(message.hasDefaultStringPiece, @"");
    XCTAssertTrue(message.hasDefaultCord, @"");
    
    XCTAssertTrue(401 == message.defaultInt32, @"");
    XCTAssertTrue(402 == message.defaultInt64, @"");
    XCTAssertTrue(403 == message.defaultUint32, @"");
    XCTAssertTrue(404 == message.defaultUint64, @"");
    XCTAssertTrue(405 == message.defaultSint32, @"");
    XCTAssertTrue(406 == message.defaultSint64, @"");
    XCTAssertTrue(407 == message.defaultFixed32, @"");
    XCTAssertTrue(408 == message.defaultFixed64, @"");
    XCTAssertTrue(409 == message.defaultSfixed32, @"");
    XCTAssertTrue(410 == message.defaultSfixed64, @"");
    XCTAssertEqualWithAccuracy(411.0f, message.defaultFloat, 0.1, @"");
    XCTAssertEqualWithAccuracy(412.0, message.defaultDouble, 0.1, @"");
    XCTAssertTrue(NO == message.defaultBool, @"");
    XCTAssertEqualObjects(@"415", message.defaultString, @"");
    XCTAssertEqualObjects([TestUtilities getData:@"416"], message.defaultBytes, @"");
    
    XCTAssertTrue(TestAllTypes_NestedEnumFOO == message.defaultNestedEnum, @"");
    XCTAssertTrue(ForeignEnumFOREIGNFOO == message.defaultForeignEnum, @"");
    XCTAssertTrue(ImportEnumIMPORTFOO == message.defaultImportEnum, @"");
    
    XCTAssertEqualObjects(@"424", message.defaultStringPiece, @"");
    XCTAssertEqualObjects(@"425", message.defaultCord, @"");
}

+ (void) assertAllFieldsSet:(TestAllTypes*) message {
    [[[TestUtilities alloc] init]  assertAllFieldsSet:message];
}


+ (void) setAllFields:(TestAllTypes_Builder*) message {
    [message setOptionalInt32:101];
    [message setOptionalInt64:102];
    [message setOptionalUint32:103];
    [message setOptionalUint64:104];
    [message setOptionalSint32:105];
    [message setOptionalSint64:106];
    [message setOptionalFixed32:107];
    [message setOptionalFixed64:108];
    [message setOptionalSfixed32:109];
    [message setOptionalSfixed64:110];
    [message setOptionalFloat:111];
    [message setOptionalDouble:112];
    [message setOptionalBool:YES];
    [message setOptionalString:@"115"];
    [message setOptionalBytes:[self getData:@"116"]];
    
    [message setOptionalGroup:[[[TestAllTypes_OptionalGroup builder] setA:117] build]];
    [message setOptionalNestedMessage:[[[TestAllTypes_NestedMessage builder] setBb:118] build]];
    [message setOptionalForeignMessage:[[[ForeignMessage builder] setC:119] build]];
    [message setOptionalImportMessage:[[[ImportMessage builder] setD:120] build]];
    
    [message setOptionalNestedEnum:TestAllTypes_NestedEnumBAZ];
    [message setOptionalForeignEnum:ForeignEnumFOREIGNBAZ];
    [message setOptionalImportEnum:ImportEnumIMPORTBAZ];
    
    [message setOptionalStringPiece:@"124"];
    [message setOptionalCord:@"125"];
    
    [message setOptionalPublicImportMessage:[[[PublicImportMessage builder] setE:126] build]];
    [message setOptionalLazyMessage:[[[TestAllTypes_NestedMessage builder] setBb:127] build]];
    
    // -----------------------------------------------------------------
    
    [message addRepeatedInt32   :201];
    [message addRepeatedInt64   :202];
    [message addRepeatedUint32  :203];
    [message addRepeatedUint64  :204];
    [message addRepeatedSint32  :205];
    [message addRepeatedSint64  :206];
    [message addRepeatedFixed32 :207];
    [message addRepeatedFixed64 :208];
    [message addRepeatedSfixed32:209];
    [message addRepeatedSfixed64:210];
    [message addRepeatedFloat   :211];
    [message addRepeatedDouble  :212];
    [message addRepeatedBool    :YES];
    [message addRepeatedString  :@"215"];
    [message addRepeatedBytes   :[self getData:@"216"]];
    
    [message addRepeatedGroup:[[[TestAllTypes_RepeatedGroup builder] setA:217] build]];
    [message addRepeatedNestedMessage:[[[TestAllTypes_NestedMessage builder] setBb:218] build]];
    [message addRepeatedForeignMessage:[[[ForeignMessage builder] setC:219] build]];
    [message addRepeatedImportMessage:[[[ImportMessage builder] setD:220] build]];
    
    [message addRepeatedNestedEnum:TestAllTypes_NestedEnumBAR];
    [message addRepeatedForeignEnum:ForeignEnumFOREIGNBAR];
    [message addRepeatedImportEnum:ImportEnumIMPORTBAR];
    
    [message addRepeatedStringPiece:@"224"];
    [message addRepeatedCord:@"225"];
    
    [message addRepeatedLazyMessage:[[[TestAllTypes_NestedMessage builder] setBb:227] build]];
    
    
    // Add a second one of each field.
    [message addRepeatedInt32   :301];
    [message addRepeatedInt64   :302];
    [message addRepeatedUint32  :303];
    [message addRepeatedUint64  :304];
    [message addRepeatedSint32  :305];
    [message addRepeatedSint64  :306];
    [message addRepeatedFixed32 :307];
    [message addRepeatedFixed64 :308];
    [message addRepeatedSfixed32:309];
    [message addRepeatedSfixed64:310];
    [message addRepeatedFloat   :311];
    [message addRepeatedDouble  :312];
    [message addRepeatedBool    :NO];
    [message addRepeatedString  :@"315"];
    [message addRepeatedBytes   :[self getData:@"316"]];
    
    [message addRepeatedGroup:[[[TestAllTypes_RepeatedGroup builder] setA:317] build]];
    [message addRepeatedNestedMessage:[[[TestAllTypes_NestedMessage builder] setBb:318] build]];
    [message addRepeatedForeignMessage:[[[ForeignMessage builder] setC:319] build]];
    [message addRepeatedImportMessage:[[[ImportMessage builder] setD:320] build]];
    
    [message addRepeatedNestedEnum:TestAllTypes_NestedEnumBAZ];
    [message addRepeatedForeignEnum:ForeignEnumFOREIGNBAZ];
    [message addRepeatedImportEnum:ImportEnumIMPORTBAZ];
    
    [message addRepeatedStringPiece:@"324"];
    [message addRepeatedCord:@"325"];
    
    [message addRepeatedLazyMessage:[[[TestAllTypes_NestedMessage builder] setBb:327] build]];
    
    // -----------------------------------------------------------------
    
    [message setDefaultInt32   :401];
    [message setDefaultInt64   :402];
    [message setDefaultUint32  :403];
    [message setDefaultUint64  :404];
    [message setDefaultSint32  :405];
    [message setDefaultSint64  :406];
    [message setDefaultFixed32 :407];
    [message setDefaultFixed64 :408];
    [message setDefaultSfixed32:409];
    [message setDefaultSfixed64:410];
    [message setDefaultFloat   :411];
    [message setDefaultDouble  :412];
    [message setDefaultBool    :NO];
    [message setDefaultString  :@"415"];
    [message setDefaultBytes   :[self getData:@"416"]];
    
    [message setDefaultNestedEnum :TestAllTypes_NestedEnumFOO];
    [message setDefaultForeignEnum:ForeignEnumFOREIGNFOO];
    [message setDefaultImportEnum :ImportEnumIMPORTFOO];
    
    [message setDefaultStringPiece:@"424"];
    [message setDefaultCord:@"425"];
}

/**
 * Set every field of {@code message} to the values expected by
 * {@code assertAllExtensionsSet()}.
 */
+ (void) setAllExtensions:(TestAllExtensions_Builder*) message {
    [message setExtension:[UnittestRoot optionalInt32Extension]   value:@101];
    [message setExtension:[UnittestRoot optionalInt64Extension]   value:@102];
    [message setExtension:[UnittestRoot optionalUint32Extension]  value:@103];
    [message setExtension:[UnittestRoot optionalUint64Extension]  value:@104];
    [message setExtension:[UnittestRoot optionalSint32Extension]  value:@105];
    [message setExtension:[UnittestRoot optionalSint64Extension]  value:@106];
    [message setExtension:[UnittestRoot optionalFixed32Extension] value:@107];
    [message setExtension:[UnittestRoot optionalFixed64Extension] value:@108];
    [message setExtension:[UnittestRoot optionalSfixed32Extension] value:@109];
    [message setExtension:[UnittestRoot optionalSfixed64Extension] value:@110];
    [message setExtension:[UnittestRoot optionalFloatExtension]   value:@111.0f];
    [message setExtension:[UnittestRoot optionalDoubleExtension]  value:@112.0];
    [message setExtension:[UnittestRoot optionalBoolExtension]    value:@YES];
    [message setExtension:[UnittestRoot optionalStringExtension]  value:@"115"];
    [message setExtension:[UnittestRoot optionalBytesExtension]   value:[self getData:@"116"]];
    
    [message setExtension:[UnittestRoot OptionalGroupExtension]
                    value:[[[OptionalGroup_extension builder] setA:117] build]];
    [message setExtension:[UnittestRoot optionalNestedMessageExtension]
                    value:[[[TestAllTypes_NestedMessage builder] setBb:118] build]];
    [message setExtension:[UnittestRoot optionalForeignMessageExtension]
                    value:[[[ForeignMessage builder] setC:119] build]];
    [message setExtension:[UnittestRoot optionalImportMessageExtension]
                    value:[[[ImportMessage builder] setD:120] build]];
    
    [message setExtension:[UnittestRoot optionalNestedEnumExtension]
                    value:@(TestAllTypes_NestedEnumBAZ)];
    [message setExtension:[UnittestRoot optionalForeignEnumExtension]
                    value:@(ForeignEnumFOREIGNBAZ)];
    [message setExtension:[UnittestRoot optionalImportEnumExtension]
                    value:@(ImportEnumIMPORTBAZ)];
    
    [message setExtension:[UnittestRoot optionalStringPieceExtension]  value:@"124"];
    [message setExtension:[UnittestRoot optionalCordExtension] value:@"125"];
    
    [message setExtension:[UnittestRoot optionalPublicImportMessageExtension]
                    value:[[[PublicImportMessage builder] setE:126] build]];
    [message setExtension:[UnittestRoot optionalLazyMessageExtension]
                    value:[[[TestAllTypes_NestedMessage builder] setBb:127] build]];
    
    // -----------------------------------------------------------------
    
    [message addExtension:[UnittestRoot repeatedInt32Extension]    value:@201];
    [message addExtension:[UnittestRoot repeatedInt64Extension]    value:@202];
    [message addExtension:[UnittestRoot repeatedUint32Extension]   value:@203];
    [message addExtension:[UnittestRoot repeatedUint64Extension]   value:@204];
    [message addExtension:[UnittestRoot repeatedSint32Extension]   value:@205];
    [message addExtension:[UnittestRoot repeatedSint64Extension]   value:@206];
    [message addExtension:[UnittestRoot repeatedFixed32Extension]  value:@207];
    [message addExtension:[UnittestRoot repeatedFixed64Extension]  value:@208];
    [message addExtension:[UnittestRoot repeatedSfixed32Extension] value:@209];
    [message addExtension:[UnittestRoot repeatedSfixed64Extension] value:@210];
    [message addExtension:[UnittestRoot repeatedFloatExtension]    value:@211.0f];
    [message addExtension:[UnittestRoot repeatedDoubleExtension]   value:@212.0];
    [message addExtension:[UnittestRoot repeatedBoolExtension]     value:@YES];
    [message addExtension:[UnittestRoot repeatedStringExtension]  value:@"215"];
    [message addExtension:[UnittestRoot repeatedBytesExtension]   value:[self getData:@"216"]];
    
    [message addExtension:[UnittestRoot RepeatedGroupExtension]
                    value:[[[RepeatedGroup_extension builder] setA:217] build]];
    [message addExtension:[UnittestRoot repeatedNestedMessageExtension]
                    value:[[[TestAllTypes_NestedMessage builder] setBb:218] build]];
    [message addExtension:[UnittestRoot repeatedForeignMessageExtension]
                    value:[[[ForeignMessage builder] setC:219] build]];
    [message addExtension:[UnittestRoot repeatedImportMessageExtension]
                    value:[[[ImportMessage builder] setD:220] build]];
    
    [message addExtension:[UnittestRoot repeatedNestedEnumExtension]
                    value:@(TestAllTypes_NestedEnumBAR)];
    [message addExtension:[UnittestRoot repeatedForeignEnumExtension]
                    value:@(ForeignEnumFOREIGNBAR)];
    [message addExtension:[UnittestRoot repeatedImportEnumExtension]
                    value:@(ImportEnumIMPORTBAR)];
    
    [message addExtension:[UnittestRoot repeatedStringPieceExtension] value:@"224"];
    [message addExtension:[UnittestRoot repeatedCordExtension] value:@"225"];
    
    [message addExtension:[UnittestRoot repeatedLazyMessageExtension]
                    value:[[[TestAllTypes_NestedMessage builder] setBb:227] build]];
    
    // Add a second one of each field.
    [message addExtension:[UnittestRoot repeatedInt32Extension] value:@301];
    [message addExtension:[UnittestRoot repeatedInt64Extension] value:@302];
    [message addExtension:[UnittestRoot repeatedUint32Extension] value:@303];
    [message addExtension:[UnittestRoot repeatedUint64Extension] value:@304];
    [message addExtension:[UnittestRoot repeatedSint32Extension] value:@305];
    [message addExtension:[UnittestRoot repeatedSint64Extension] value:@306];
    [message addExtension:[UnittestRoot repeatedFixed32Extension] value:@307];
    [message addExtension:[UnittestRoot repeatedFixed64Extension] value:@308];
    [message addExtension:[UnittestRoot repeatedSfixed32Extension] value:@309];
    [message addExtension:[UnittestRoot repeatedSfixed64Extension] value:@310];
    [message addExtension:[UnittestRoot repeatedFloatExtension] value:@311.0f];
    [message addExtension:[UnittestRoot repeatedDoubleExtension] value:@312.0];
    [message addExtension:[UnittestRoot repeatedBoolExtension] value:@NO];
    [message addExtension:[UnittestRoot repeatedStringExtension] value:@"315"];
    [message addExtension:[UnittestRoot repeatedBytesExtension] value:[self getData:@"316"]];
    
    [message addExtension:[UnittestRoot RepeatedGroupExtension]
                    value:[[[RepeatedGroup_extension builder] setA:317] build]];
    [message addExtension:[UnittestRoot repeatedNestedMessageExtension]
                    value:[[[TestAllTypes_NestedMessage builder] setBb:318] build]];
    [message addExtension:[UnittestRoot repeatedForeignMessageExtension]
                    value:[[[ForeignMessage builder] setC:319] build]];
    [message addExtension:[UnittestRoot repeatedImportMessageExtension]
                    value:[[[ImportMessage builder] setD:320] build]];
    
    [message addExtension:[UnittestRoot repeatedNestedEnumExtension]
                    value:@(TestAllTypes_NestedEnumBAZ)];
    [message addExtension:[UnittestRoot repeatedForeignEnumExtension]
                    value:@(ForeignEnumFOREIGNBAZ)];
    [message addExtension:[UnittestRoot repeatedImportEnumExtension]
                    value:@(ImportEnumIMPORTBAZ)];
    
    [message addExtension:[UnittestRoot repeatedStringPieceExtension] value:@"324"];
    [message addExtension:[UnittestRoot repeatedCordExtension] value:@"325"];
    
    [message addExtension:[UnittestRoot repeatedLazyMessageExtension]
                    value:[[[TestAllTypes_NestedMessage builder] setBb:327] build]];
    
    // -----------------------------------------------------------------
    
    [message setExtension:[UnittestRoot defaultInt32Extension] value:@401];
    [message setExtension:[UnittestRoot defaultInt64Extension] value:@402];
    [message setExtension:[UnittestRoot defaultUint32Extension] value:@403];
    [message setExtension:[UnittestRoot defaultUint64Extension] value:@404];
    [message setExtension:[UnittestRoot defaultSint32Extension] value:@405];
    [message setExtension:[UnittestRoot defaultSint64Extension] value:@406];
    [message setExtension:[UnittestRoot defaultFixed32Extension] value:@407];
    [message setExtension:[UnittestRoot defaultFixed64Extension] value:@408];
    [message setExtension:[UnittestRoot defaultSfixed32Extension] value:@409];
    [message setExtension:[UnittestRoot defaultSfixed64Extension] value:@410];
    [message setExtension:[UnittestRoot defaultFloatExtension] value:@411.0f];
    [message setExtension:[UnittestRoot defaultDoubleExtension] value:@412.0];
    [message setExtension:[UnittestRoot defaultBoolExtension] value:@NO];
    [message setExtension:[UnittestRoot defaultStringExtension] value:@"415"];
    [message setExtension:[UnittestRoot defaultBytesExtension] value:[self getData:@"416"]];
    
    [message setExtension:[UnittestRoot defaultNestedEnumExtension]
                    value:@(TestAllTypes_NestedEnumFOO)];
    [message setExtension:[UnittestRoot defaultForeignEnumExtension]
                    value:@(ForeignEnumFOREIGNFOO)];
    [message setExtension:[UnittestRoot defaultImportEnumExtension]
                    value:@(ImportEnumIMPORTFOO)];
    
    [message setExtension:[UnittestRoot defaultStringPieceExtension] value:@"424"];
    [message setExtension:[UnittestRoot defaultCordExtension] value:@"425"];
}


/**
 * Register all of {@code TestAllExtensions}' extensions with the
 * given {@link ExtensionRegistry}.
 */
+ (void) registerAllExtensions:(PBMutableExtensionRegistry*) registry {
    [UnittestRoot registerAllExtensions:registry];
    /*
     [registry addExtension:[UnittestRoot optionalInt32Extension]];
     [registry addExtension:[UnittestRoot optionalInt64Extension]];
     [registry addExtension:[UnittestRoot optionalUint32Extension]];
     [registry addExtension:[UnittestRoot optionalUint64Extension]];
     [registry addExtension:[UnittestRoot optionalSint32Extension]];
     [registry addExtension:[UnittestRoot optionalSint64Extension]];
     [registry addExtension:[UnittestRoot optionalFixed32Extension]];
     [registry addExtension:[UnittestRoot optionalFixed64Extension]];
     [registry addExtension:[UnittestRoot optionalSfixed32Extension]];
     [registry addExtension:[UnittestRoot optionalSfixed64Extension]];
     [registry addExtension:[UnittestRoot optionalFloatExtension]];
     [registry addExtension:[UnittestRoot optionalDoubleExtension]];
     [registry addExtension:[UnittestRoot optionalBoolExtension]];
     [registry addExtension:[UnittestRoot optionalStringExtension]];
     [registry addExtension:[UnittestRoot optionalBytesExtension]];
     [registry addExtension:[UnittestRoot optionalGroupExtension]];
     [registry addExtension:[UnittestRoot optionalNestedMessageExtension]];
     [registry addExtension:[UnittestRoot optionalForeignMessageExtension]];
     [registry addExtension:[UnittestRoot optionalImportMessageExtension]];
     [registry addExtension:[UnittestRoot optionalNestedEnumExtension]];
     [registry addExtension:[UnittestRoot optionalForeignEnumExtension]];
     [registry addExtension:[UnittestRoot optionalImportEnumExtension]];
     [registry addExtension:[UnittestRoot optionalStringPieceExtension]];
     [registry addExtension:[UnittestRoot optionalCordExtension]];
     
     [registry addExtension:[UnittestRoot repeatedInt32Extension]];
     [registry addExtension:[UnittestRoot repeatedInt64Extension]];
     [registry addExtension:[UnittestRoot repeatedUint32Extension]];
     [registry addExtension:[UnittestRoot repeatedUint64Extension]];
     [registry addExtension:[UnittestRoot repeatedSint32Extension]];
     [registry addExtension:[UnittestRoot repeatedSint64Extension]];
     [registry addExtension:[UnittestRoot repeatedFixed32Extension]];
     [registry addExtension:[UnittestRoot repeatedFixed64Extension]];
     [registry addExtension:[UnittestRoot repeatedSfixed32Extension]];
     [registry addExtension:[UnittestRoot repeatedSfixed64Extension]];
     [registry addExtension:[UnittestRoot repeatedFloatExtension]];
     [registry addExtension:[UnittestRoot repeatedDoubleExtension]];
     [registry addExtension:[UnittestRoot repeatedBoolExtension]];
     [registry addExtension:[UnittestRoot repeatedStringExtension]];
     [registry addExtension:[UnittestRoot repeatedBytesExtension]];
     [registry addExtension:[UnittestRoot repeatedGroupExtension]];
     [registry addExtension:[UnittestRoot repeatedNestedMessageExtension]];
     [registry addExtension:[UnittestRoot repeatedForeignMessageExtension]];
     [registry addExtension:[UnittestRoot repeatedImportMessageExtension]];
     [registry addExtension:[UnittestRoot repeatedNestedEnumExtension]];
     [registry addExtension:[UnittestRoot repeatedForeignEnumExtension]];
     [registry addExtension:[UnittestRoot repeatedImportEnumExtension]];
     [registry addExtension:[UnittestRoot repeatedStringPieceExtension]];
     [registry addExtension:[UnittestRoot repeatedCordExtension]];
     
     [registry addExtension:[UnittestRoot defaultInt32Extension]];
     [registry addExtension:[UnittestRoot defaultInt64Extension]];
     [registry addExtension:[UnittestRoot defaultUint32Extension]];
     [registry addExtension:[UnittestRoot defaultUint64Extension]];
     [registry addExtension:[UnittestRoot defaultSint32Extension]];
     [registry addExtension:[UnittestRoot defaultSint64Extension]];
     [registry addExtension:[UnittestRoot defaultFixed32Extension]];
     [registry addExtension:[UnittestRoot defaultFixed64Extension]];
     [registry addExtension:[UnittestRoot defaultSfixed32Extension]];
     [registry addExtension:[UnittestRoot defaultSfixed64Extension]];
     [registry addExtension:[UnittestRoot defaultFloatExtension]];
     [registry addExtension:[UnittestRoot defaultDoubleExtension]];
     [registry addExtension:[UnittestRoot defaultBoolExtension]];
     [registry addExtension:[UnittestRoot defaultStringExtension]];
     [registry addExtension:[UnittestRoot defaultBytesExtension]];
     [registry addExtension:[UnittestRoot defaultNestedEnumExtension]];
     [registry addExtension:[UnittestRoot defaultForeignEnumExtension]];
     [registry addExtension:[UnittestRoot defaultImportEnumExtension]];
     [registry addExtension:[UnittestRoot defaultStringPieceExtension]];
     [registry addExtension:[UnittestRoot defaultCordExtension]];
     */
}


/**
 * Get an unmodifiable {@link ExtensionRegistry} containing all the
 * extensions of {@code TestAllExtensions}.
 */
+ (PBExtensionRegistry*) extensionRegistry {
    PBMutableExtensionRegistry* registry = [PBMutableExtensionRegistry registry];
    [self registerAllExtensions:registry];
    return registry;
}


+ (TestAllTypes*) allSet {
    TestAllTypes_Builder* builder = [TestAllTypes builder];
    [self setAllFields:builder];
    return [builder build];
}


+ (TestAllExtensions*) allExtensionsSet {
    TestAllExtensions_Builder* builder = [TestAllExtensions builder];
    [self setAllExtensions:builder];
    return [builder build];
}


+ (TestPackedTypes*) packedSet {
    TestPackedTypes_Builder* builder = [TestPackedTypes builder];
    [self setPackedFields:builder];
    return [builder build];
}


+ (TestPackedExtensions*) packedExtensionsSet {
    TestPackedExtensions_Builder* builder = [TestPackedExtensions builder];
    [self setPackedExtensions:builder];
    return [builder build];
}

// -------------------------------------------------------------------

/**
 * Assert (using {@code junit.framework.Assert}} that all fields of
 * {@code message} are cleared, and that getting the fields returns their
 * default values.
 */
- (void) assertClear:(TestAllTypes*) message {
    // hasBlah() should initially be NO for all optional fields.
    XCTAssertFalse(message.hasOptionalInt32, @"");
    XCTAssertFalse(message.hasOptionalInt64, @"");
    XCTAssertFalse(message.hasOptionalUint32, @"");
    XCTAssertFalse(message.hasOptionalUint64, @"");
    XCTAssertFalse(message.hasOptionalSint32, @"");
    XCTAssertFalse(message.hasOptionalSint64, @"");
    XCTAssertFalse(message.hasOptionalFixed32, @"");
    XCTAssertFalse(message.hasOptionalFixed64, @"");
    XCTAssertFalse(message.hasOptionalSfixed32, @"");
    XCTAssertFalse(message.hasOptionalSfixed64, @"");
    XCTAssertFalse(message.hasOptionalFloat, @"");
    XCTAssertFalse(message.hasOptionalDouble, @"");
    XCTAssertFalse(message.hasOptionalBool, @"");
    XCTAssertFalse(message.hasOptionalString, @"");
    XCTAssertFalse(message.hasOptionalBytes, @"");
    
    XCTAssertFalse(message.hasOptionalGroup, @"");
    XCTAssertFalse(message.hasOptionalNestedMessage, @"");
    XCTAssertFalse(message.hasOptionalForeignMessage, @"");
    XCTAssertFalse(message.hasOptionalImportMessage, @"");
    
    XCTAssertFalse(message.hasOptionalNestedEnum, @"");
    XCTAssertFalse(message.hasOptionalForeignEnum, @"");
    XCTAssertFalse(message.hasOptionalImportEnum, @"");
    
    XCTAssertFalse(message.hasOptionalStringPiece, @"");
    XCTAssertFalse(message.hasOptionalCord, @"");
    
    // Optional fields without defaults are set to zero or something like it.
    XCTAssertTrue(0 == message.optionalInt32, @"");
    XCTAssertTrue(0 == message.optionalInt64, @"");
    XCTAssertTrue(0 == message.optionalUint32, @"");
    XCTAssertTrue(0 == message.optionalUint64, @"");
    XCTAssertTrue(0 == message.optionalSint32, @"");
    XCTAssertTrue(0 == message.optionalSint64, @"");
    XCTAssertTrue(0 == message.optionalFixed32, @"");
    XCTAssertTrue(0 == message.optionalFixed64, @"");
    XCTAssertTrue(0 == message.optionalSfixed32, @"");
    XCTAssertTrue(0 == message.optionalSfixed64, @"");
    XCTAssertTrue(0 == message.optionalFloat, @"");
    XCTAssertTrue(0 == message.optionalDouble, @"");
    XCTAssertTrue(NO == message.optionalBool, @"");
    XCTAssertEqualObjects(@"", message.optionalString, @"");
    XCTAssertEqualObjects([NSData data], message.optionalBytes, @"");
    
    // Embedded messages should also be clear.
    XCTAssertFalse(message.OptionalGroup.hasA, @"");
    XCTAssertFalse(message.optionalNestedMessage.hasBb, @"");
    XCTAssertFalse(message.optionalForeignMessage.hasC, @"");
    XCTAssertFalse(message.optionalImportMessage.hasD, @"");
    
    XCTAssertTrue(0 == message.OptionalGroup.a, @"");
    XCTAssertTrue(0 == message.optionalNestedMessage.bb, @"");
    XCTAssertTrue(0 == message.optionalForeignMessage.c, @"");
    XCTAssertTrue(0 == message.optionalImportMessage.d, @"");
    
    // Enums without defaults are set to the first value in the enum.
    XCTAssertTrue(TestAllTypes_NestedEnumFOO == message.optionalNestedEnum, @"");
    XCTAssertTrue(ForeignEnumFOREIGNFOO == message.optionalForeignEnum, @"");
    XCTAssertTrue(ImportEnumIMPORTFOO == message.optionalImportEnum, @"");
    
    XCTAssertEqualObjects(@"", message.optionalStringPiece, @"");
    XCTAssertEqualObjects(@"", message.optionalCord, @"");
    
    // Repeated fields are empty.
    XCTAssertTrue(0 == message.repeatedInt32.count, @"");
    XCTAssertTrue(0 == message.repeatedInt64.count, @"");
    XCTAssertTrue(0 == message.repeatedUint32.count, @"");
    XCTAssertTrue(0 == message.repeatedUint64.count, @"");
    XCTAssertTrue(0 == message.repeatedSint32.count, @"");
    XCTAssertTrue(0 == message.repeatedSint64.count, @"");
    XCTAssertTrue(0 == message.repeatedFixed32.count, @"");
    XCTAssertTrue(0 == message.repeatedFixed64.count, @"");
    XCTAssertTrue(0 == message.repeatedSfixed32.count, @"");
    XCTAssertTrue(0 == message.repeatedSfixed64.count, @"");
    XCTAssertTrue(0 == message.repeatedFloat.count, @"");
    XCTAssertTrue(0 == message.repeatedDouble.count, @"");
    XCTAssertTrue(0 == message.repeatedBool.count, @"");
    XCTAssertTrue(0 == message.repeatedString.count, @"");
    XCTAssertTrue(0 == message.repeatedBytes.count, @"");
    
    XCTAssertTrue(0 == message.RepeatedGroup.count, @"");
    XCTAssertTrue(0 == message.repeatedNestedMessage.count, @"");
    XCTAssertTrue(0 == message.repeatedForeignMessage.count, @"");
    XCTAssertTrue(0 == message.repeatedImportMessage.count, @"");
    XCTAssertTrue(0 == message.repeatedNestedEnum.count, @"");
    XCTAssertTrue(0 == message.repeatedForeignEnum.count, @"");
    XCTAssertTrue(0 == message.repeatedImportEnum.count, @"");
    
    XCTAssertTrue(0 == message.repeatedStringPiece.count, @"");
    XCTAssertTrue(0 == message.repeatedCord.count, @"");
    
    // hasBlah() should also be NO for all default fields.
    XCTAssertFalse(message.hasDefaultInt32, @"");
    XCTAssertFalse(message.hasDefaultInt64, @"");
    XCTAssertFalse(message.hasDefaultUint32, @"");
    XCTAssertFalse(message.hasDefaultUint64, @"");
    XCTAssertFalse(message.hasDefaultSint32, @"");
    XCTAssertFalse(message.hasDefaultSint64, @"");
    XCTAssertFalse(message.hasDefaultFixed32, @"");
    XCTAssertFalse(message.hasDefaultFixed64, @"");
    XCTAssertFalse(message.hasDefaultSfixed32, @"");
    XCTAssertFalse(message.hasDefaultSfixed64, @"");
    XCTAssertFalse(message.hasDefaultFloat, @"");
    XCTAssertFalse(message.hasDefaultDouble, @"");
    XCTAssertFalse(message.hasDefaultBool, @"");
    XCTAssertFalse(message.hasDefaultString, @"");
    XCTAssertFalse(message.hasDefaultBytes, @"");
    
    XCTAssertFalse(message.hasDefaultNestedEnum, @"");
    XCTAssertFalse(message.hasDefaultForeignEnum, @"");
    XCTAssertFalse(message.hasDefaultImportEnum, @"");
    
    XCTAssertFalse(message.hasDefaultStringPiece, @"");
    XCTAssertFalse(message.hasDefaultCord, @"");
    
    // Fields with defaults have their default values (duh).
    XCTAssertTrue( 41 == message.defaultInt32, @"");
    XCTAssertTrue( 42 == message.defaultInt64, @"");
    XCTAssertTrue( 43 == message.defaultUint32, @"");
    XCTAssertTrue( 44 == message.defaultUint64, @"");
    XCTAssertTrue(-45 == message.defaultSint32, @"");
    XCTAssertTrue( 46 == message.defaultSint64, @"");
    XCTAssertTrue( 47 == message.defaultFixed32, @"");
    XCTAssertTrue( 48 == message.defaultFixed64, @"");
    XCTAssertTrue( 49 == message.defaultSfixed32, @"");
    XCTAssertTrue(-50 == message.defaultSfixed64, @"");
    XCTAssertEqualWithAccuracy(51.5, message.defaultFloat, 0.1, @"");
    XCTAssertEqualWithAccuracy(52e3, message.defaultDouble, 0.1, @"");
    XCTAssertTrue(YES == message.defaultBool, @"");
    XCTAssertEqualObjects(@"hello", message.defaultString, @"");
    XCTAssertEqualObjects([TestUtilities getData:@"world"], message.defaultBytes, @"");
    
    XCTAssertTrue(TestAllTypes_NestedEnumBAR == message.defaultNestedEnum, @"");
    XCTAssertTrue(ForeignEnumFOREIGNBAR == message.defaultForeignEnum, @"");
    XCTAssertTrue(ImportEnumIMPORTBAR == message.defaultImportEnum, @"");
    
    XCTAssertEqualObjects(@"abc", message.defaultStringPiece, @"");
    XCTAssertEqualObjects(@"123", message.defaultCord, @"");
}


+ (void) assertClear:(TestAllTypes*) message {
    return [[[TestUtilities alloc] init]  assertClear:message];
}


- (void) assertExtensionsClear:(TestAllExtensions*) message {
    // hasBlah() should initially be NO for all optional fields.
    XCTAssertFalse([message hasExtension:[UnittestRoot optionalInt32Extension]], @"");
    XCTAssertFalse([message hasExtension:[UnittestRoot optionalInt64Extension]], @"");
    XCTAssertFalse([message hasExtension:[UnittestRoot optionalUint32Extension]], @"");
    XCTAssertFalse([message hasExtension:[UnittestRoot optionalUint64Extension]], @"");
    XCTAssertFalse([message hasExtension:[UnittestRoot optionalSint32Extension]], @"");
    XCTAssertFalse([message hasExtension:[UnittestRoot optionalSint64Extension]], @"");
    XCTAssertFalse([message hasExtension:[UnittestRoot optionalFixed32Extension]], @"");
    XCTAssertFalse([message hasExtension:[UnittestRoot optionalFixed64Extension]], @"");
    XCTAssertFalse([message hasExtension:[UnittestRoot optionalSfixed32Extension]], @"");
    XCTAssertFalse([message hasExtension:[UnittestRoot optionalSfixed64Extension]], @"");
    XCTAssertFalse([message hasExtension:[UnittestRoot optionalFloatExtension]], @"");
    XCTAssertFalse([message hasExtension:[UnittestRoot optionalDoubleExtension]], @"");
    XCTAssertFalse([message hasExtension:[UnittestRoot optionalBoolExtension]], @"");
    XCTAssertFalse([message hasExtension:[UnittestRoot optionalStringExtension]], @"");
    XCTAssertFalse([message hasExtension:[UnittestRoot optionalBytesExtension]], @"");
    
    XCTAssertFalse([message hasExtension:[UnittestRoot OptionalGroupExtension]], @"");
    XCTAssertFalse([message hasExtension:[UnittestRoot optionalNestedMessageExtension]], @"");
    XCTAssertFalse([message hasExtension:[UnittestRoot optionalForeignMessageExtension]], @"");
    XCTAssertFalse([message hasExtension:[UnittestRoot optionalImportMessageExtension]], @"");
    
    XCTAssertFalse([message hasExtension:[UnittestRoot optionalNestedEnumExtension]], @"");
    XCTAssertFalse([message hasExtension:[UnittestRoot optionalForeignEnumExtension]], @"");
    XCTAssertFalse([message hasExtension:[UnittestRoot optionalImportEnumExtension]], @"");
    
    XCTAssertFalse([message hasExtension:[UnittestRoot optionalStringPieceExtension]], @"");
    XCTAssertFalse([message hasExtension:[UnittestRoot optionalCordExtension]], @"");
    
    // Optional fields without defaults are set to zero or something like it.
    XCTAssertTrue(0     == [[message getExtension:[UnittestRoot optionalInt32Extension]] intValue], @"");
    XCTAssertTrue(0L    == [[message getExtension:[UnittestRoot optionalInt64Extension]] intValue], @"");
    XCTAssertTrue(0     == [[message getExtension:[UnittestRoot optionalUint32Extension]] intValue], @"");
    XCTAssertTrue(0L    == [[message getExtension:[UnittestRoot optionalUint64Extension]] intValue], @"");
    XCTAssertTrue(0     == [[message getExtension:[UnittestRoot optionalSint32Extension]] intValue], @"");
    XCTAssertTrue(0L    == [[message getExtension:[UnittestRoot optionalSint64Extension]] intValue], @"");
    XCTAssertTrue(0     == [[message getExtension:[UnittestRoot optionalFixed32Extension]] intValue], @"");
    XCTAssertTrue(0L    == [[message getExtension:[UnittestRoot optionalFixed64Extension]] intValue], @"");
    XCTAssertTrue(0     == [[message getExtension:[UnittestRoot optionalSfixed32Extension]] intValue], @"");
    XCTAssertTrue(0L    == [[message getExtension:[UnittestRoot optionalSfixed64Extension]] intValue], @"");
    XCTAssertTrue(0    == [[message getExtension:[UnittestRoot optionalFloatExtension]] floatValue], @"");
    XCTAssertTrue(0    == [[message getExtension:[UnittestRoot optionalDoubleExtension]] doubleValue], @"");
    XCTAssertTrue(NO == [[message getExtension:[UnittestRoot optionalBoolExtension]] boolValue], @"");
    XCTAssertEqualObjects(@"", [message getExtension:[UnittestRoot optionalStringExtension]], @"");
    XCTAssertEqualObjects([NSData data], [message getExtension:[UnittestRoot optionalBytesExtension]], @"");
    
    // Embedded messages should also be clear.
    
    XCTAssertFalse([[message getExtension:[UnittestRoot OptionalGroupExtension]] hasA], @"");
    XCTAssertFalse([[message getExtension:[UnittestRoot optionalNestedMessageExtension]] hasBb], @"");
    XCTAssertFalse([[message getExtension:[UnittestRoot optionalForeignMessageExtension]] hasC], @"");
    XCTAssertFalse([[message getExtension:[UnittestRoot optionalImportMessageExtension]] hasD], @"");
    
    XCTAssertTrue(0 == [(OptionalGroup_extension *)[message getExtension:[UnittestRoot OptionalGroupExtension]] a], @"");
    XCTAssertTrue(0 == [(TestAllTypes_NestedMessage *)[message getExtension:[UnittestRoot optionalNestedMessageExtension]] bb], @"");
    XCTAssertTrue(0 == [[message getExtension:[UnittestRoot optionalForeignMessageExtension]] c], @"");
    XCTAssertTrue(0 == [[message getExtension:[UnittestRoot optionalImportMessageExtension]] d], @"");
    
    // Enums without defaults are set to the first value in the enum.
    XCTAssertTrue(TestAllTypes_NestedEnumFOO ==
                  [[message getExtension:[UnittestRoot optionalNestedEnumExtension]] intValue], @"");
    XCTAssertTrue(ForeignEnumFOREIGNFOO ==
                  [[message getExtension:[UnittestRoot optionalForeignEnumExtension]] intValue], @"");
    XCTAssertTrue(ImportEnumIMPORTFOO ==
                  [[message getExtension:[UnittestRoot optionalImportEnumExtension]] intValue], @"");
    
    XCTAssertEqualObjects(@"", [message getExtension:[UnittestRoot optionalStringPieceExtension]], @"");
    XCTAssertEqualObjects(@"", [message getExtension:[UnittestRoot optionalCordExtension]], @"");
    
    // Repeated fields are empty.
    XCTAssertTrue(0 == [[message getExtension:[UnittestRoot repeatedInt32Extension]] count], @"");
    XCTAssertTrue(0 == [[message getExtension:[UnittestRoot repeatedInt64Extension]] count], @"");
    XCTAssertTrue(0 == [[message getExtension:[UnittestRoot repeatedUint32Extension]] count], @"");
    XCTAssertTrue(0 == [[message getExtension:[UnittestRoot repeatedUint64Extension]] count], @"");
    XCTAssertTrue(0 == [[message getExtension:[UnittestRoot repeatedSint32Extension]] count], @"");
    XCTAssertTrue(0 == [[message getExtension:[UnittestRoot repeatedSint64Extension]] count], @"");
    XCTAssertTrue(0 == [[message getExtension:[UnittestRoot repeatedFixed32Extension]] count], @"");
    XCTAssertTrue(0 == [[message getExtension:[UnittestRoot repeatedFixed64Extension]] count], @"");
    XCTAssertTrue(0 == [[message getExtension:[UnittestRoot repeatedSfixed32Extension]] count], @"");
    XCTAssertTrue(0 == [[message getExtension:[UnittestRoot repeatedSfixed64Extension]] count], @"");
    XCTAssertTrue(0 == [[message getExtension:[UnittestRoot repeatedFloatExtension]] count], @"");
    XCTAssertTrue(0 == [[message getExtension:[UnittestRoot repeatedDoubleExtension]] count], @"");
    XCTAssertTrue(0 == [[message getExtension:[UnittestRoot repeatedBoolExtension]] count], @"");
    XCTAssertTrue(0 == [[message getExtension:[UnittestRoot repeatedStringExtension]] count], @"");
    XCTAssertTrue(0 == [[message getExtension:[UnittestRoot repeatedBytesExtension]] count], @"");
    
    XCTAssertTrue(0 == [[message getExtension:[UnittestRoot RepeatedGroupExtension]] count], @"");
    XCTAssertTrue(0 == [[message getExtension:[UnittestRoot repeatedNestedMessageExtension]] count], @"");
    XCTAssertTrue(0 == [[message getExtension:[UnittestRoot repeatedForeignMessageExtension]] count], @"");
    XCTAssertTrue(0 == [[message getExtension:[UnittestRoot repeatedImportMessageExtension]] count], @"");
    XCTAssertTrue(0 == [[message getExtension:[UnittestRoot repeatedNestedEnumExtension]] count], @"");
    XCTAssertTrue(0 == [[message getExtension:[UnittestRoot repeatedForeignEnumExtension]] count], @"");
    XCTAssertTrue(0 == [[message getExtension:[UnittestRoot repeatedImportEnumExtension]] count], @"");
    
    XCTAssertTrue(0 == [[message getExtension:[UnittestRoot repeatedStringPieceExtension]] count], @"");
    XCTAssertTrue(0 == [[message getExtension:[UnittestRoot repeatedCordExtension]] count], @"");
    
    // hasBlah() should also be NO for all default fields.
    XCTAssertFalse([message hasExtension:[UnittestRoot defaultInt32Extension]], @"");
    XCTAssertFalse([message hasExtension:[UnittestRoot defaultInt64Extension]], @"");
    XCTAssertFalse([message hasExtension:[UnittestRoot defaultUint32Extension]], @"");
    XCTAssertFalse([message hasExtension:[UnittestRoot defaultUint64Extension]], @"");
    XCTAssertFalse([message hasExtension:[UnittestRoot defaultSint32Extension]], @"");
    XCTAssertFalse([message hasExtension:[UnittestRoot defaultSint64Extension]], @"");
    XCTAssertFalse([message hasExtension:[UnittestRoot defaultFixed32Extension]], @"");
    XCTAssertFalse([message hasExtension:[UnittestRoot defaultFixed64Extension]], @"");
    XCTAssertFalse([message hasExtension:[UnittestRoot defaultSfixed32Extension]], @"");
    XCTAssertFalse([message hasExtension:[UnittestRoot defaultSfixed64Extension]], @"");
    XCTAssertFalse([message hasExtension:[UnittestRoot defaultFloatExtension]], @"");
    XCTAssertFalse([message hasExtension:[UnittestRoot defaultDoubleExtension]], @"");
    XCTAssertFalse([message hasExtension:[UnittestRoot defaultBoolExtension]], @"");
    XCTAssertFalse([message hasExtension:[UnittestRoot defaultStringExtension]], @"");
    XCTAssertFalse([message hasExtension:[UnittestRoot defaultBytesExtension]], @"");
    
    XCTAssertFalse([message hasExtension:[UnittestRoot defaultNestedEnumExtension]], @"");
    XCTAssertFalse([message hasExtension:[UnittestRoot defaultForeignEnumExtension]], @"");
    XCTAssertFalse([message hasExtension:[UnittestRoot defaultImportEnumExtension]], @"");
    
    XCTAssertFalse([message hasExtension:[UnittestRoot defaultStringPieceExtension]], @"");
    XCTAssertFalse([message hasExtension:[UnittestRoot defaultCordExtension]], @"");
    
    // Fields with defaults have their default values (duh).
    XCTAssertTrue( 41     == [[message getExtension:[UnittestRoot defaultInt32Extension]] intValue], @"");
    XCTAssertTrue( 42L    == [[message getExtension:[UnittestRoot defaultInt64Extension]] intValue], @"");
    XCTAssertTrue( 43     == [[message getExtension:[UnittestRoot defaultUint32Extension]] intValue], @"");
    XCTAssertTrue( 44L    == [[message getExtension:[UnittestRoot defaultUint64Extension]] intValue], @"");
    XCTAssertTrue(-45     == [[message getExtension:[UnittestRoot defaultSint32Extension]] intValue], @"");
    XCTAssertTrue( 46L    == [[message getExtension:[UnittestRoot defaultSint64Extension]] intValue], @"");
    XCTAssertTrue( 47     == [[message getExtension:[UnittestRoot defaultFixed32Extension]] intValue], @"");
    XCTAssertTrue( 48L    == [[message getExtension:[UnittestRoot defaultFixed64Extension]] intValue], @"");
    XCTAssertTrue( 49     == [[message getExtension:[UnittestRoot defaultSfixed32Extension]] intValue], @"");
    XCTAssertTrue(-50L    == [[message getExtension:[UnittestRoot defaultSfixed64Extension]] intValue], @"");
    XCTAssertTrue( 51.5  == [[message getExtension:[UnittestRoot defaultFloatExtension]] floatValue], @"");
    XCTAssertTrue( 52e3  == [[message getExtension:[UnittestRoot defaultDoubleExtension]] doubleValue], @"");
    XCTAssertTrue(YES    == [[message getExtension:[UnittestRoot defaultBoolExtension]] boolValue], @"");
    XCTAssertEqualObjects(@"hello", [message getExtension:[UnittestRoot defaultStringExtension]], @"");
    XCTAssertEqualObjects([TestUtilities getData:@"world"], [message getExtension:[UnittestRoot defaultBytesExtension]], @"");
    
    XCTAssertTrue(TestAllTypes_NestedEnumBAR ==
                  [[message getExtension:[UnittestRoot defaultNestedEnumExtension]] intValue], @"");
    XCTAssertTrue(ForeignEnumFOREIGNBAR ==
                  [[message getExtension:[UnittestRoot defaultForeignEnumExtension]] intValue], @"");
    XCTAssertTrue(ImportEnumIMPORTBAR ==
                  [[message getExtension:[UnittestRoot defaultImportEnumExtension]] intValue], @"");
    
    XCTAssertEqualObjects(@"abc", [message getExtension:[UnittestRoot defaultStringPieceExtension]], @"");
    XCTAssertEqualObjects(@"123", [message getExtension:[UnittestRoot defaultCordExtension]], @"");
}


+ (void) assertExtensionsClear:(TestAllExtensions*) message {
    [[[TestUtilities alloc] init]  assertExtensionsClear:message];
}

+ (void) setPackedFields:(TestPackedTypes_Builder*) message {
    [message addPackedInt32   :601];
    [message addPackedInt64   :602];
    [message addPackedUint32  :603];
    [message addPackedUint64  :604];
    [message addPackedSint32  :605];
    [message addPackedSint64  :606];
    [message addPackedFixed32 :607];
    [message addPackedFixed64 :608];
    [message addPackedSfixed32:609];
    [message addPackedSfixed64:610];
    [message addPackedFloat   :611];
    [message addPackedDouble  :612];
    [message addPackedBool    :YES];
    [message addPackedEnum    :ForeignEnumFOREIGNBAR];
    // Add a second one of each field.
    [message addPackedInt32   :701];
    [message addPackedInt64   :702];
    [message addPackedUint32  :703];
    [message addPackedUint64  :704];
    [message addPackedSint32  :705];
    [message addPackedSint64  :706];
    [message addPackedFixed32 :707];
    [message addPackedFixed64 :708];
    [message addPackedSfixed32:709];
    [message addPackedSfixed64:710];
    [message addPackedFloat   :711];
    [message addPackedDouble  :712];
    [message addPackedBool    :NO];
    [message addPackedEnum    :ForeignEnumFOREIGNBAZ];
}


- (void) assertPackedFieldsSet:(TestPackedTypes*) message {
    XCTAssertTrue(2 ==  message.packedInt32.count, @"");
    XCTAssertTrue(2 ==  message.packedInt64.count, @"");
    XCTAssertTrue(2 ==  message.packedUint32.count, @"");
    XCTAssertTrue(2 ==  message.packedUint64.count, @"");
    XCTAssertTrue(2 ==  message.packedSint32.count, @"");
    XCTAssertTrue(2 ==  message.packedSint64.count, @"");
    XCTAssertTrue(2 ==  message.packedFixed32.count, @"");
    XCTAssertTrue(2 ==  message.packedFixed64.count, @"");
    XCTAssertTrue(2 ==  message.packedSfixed32.count, @"");
    XCTAssertTrue(2 ==  message.packedSfixed64.count, @"");
    XCTAssertTrue(2 ==  message.packedFloat.count, @"");
    XCTAssertTrue(2 ==  message.packedDouble.count, @"");
    XCTAssertTrue(2 ==  message.packedBool.count, @"");
    XCTAssertTrue(2 ==  message.packedEnum.count, @"");
    XCTAssertTrue(601   ==  [message packedInt32AtIndex:0], @"");
    XCTAssertTrue(602   ==  [message packedInt64AtIndex:0], @"");
    XCTAssertTrue(603   ==  [message packedUint32AtIndex:0], @"");
    XCTAssertTrue(604   ==  [message packedUint64AtIndex:0], @"");
    XCTAssertTrue(605   ==  [message packedSint32AtIndex:0], @"");
    XCTAssertTrue(606   ==  [message packedSint64AtIndex:0], @"");
    XCTAssertTrue(607   ==  [message packedFixed32AtIndex:0], @"");
    XCTAssertTrue(608   ==  [message packedFixed64AtIndex:0], @"");
    XCTAssertTrue(609   ==  [message packedSfixed32AtIndex:0], @"");
    XCTAssertTrue(610   ==  [message packedSfixed64AtIndex:0], @"");
    XCTAssertTrue(611   ==  [message packedFloatAtIndex:0], @"");
    XCTAssertTrue(612   ==  [message packedDoubleAtIndex:0], @"");
    XCTAssertTrue(YES  ==  [message packedBoolAtIndex:0], @"");
    XCTAssertTrue(ForeignEnumFOREIGNBAR ==  [message packedEnumAtIndex:0], @"");
    XCTAssertTrue(701   ==  [message packedInt32AtIndex:1], @"");
    XCTAssertTrue(702   ==  [message packedInt64AtIndex:1], @"");
    XCTAssertTrue(703   ==  [message packedUint32AtIndex:1], @"");
    XCTAssertTrue(704   ==  [message packedUint64AtIndex:1], @"");
    XCTAssertTrue(705   ==  [message packedSint32AtIndex:1], @"");
    XCTAssertTrue(706   ==  [message packedSint64AtIndex:1], @"");
    XCTAssertTrue(707   ==  [message packedFixed32AtIndex:1], @"");
    XCTAssertTrue(708   ==  [message packedFixed64AtIndex:1], @"");
    XCTAssertTrue(709   ==  [message packedSfixed32AtIndex:1], @"");
    XCTAssertTrue(710   ==  [message packedSfixed64AtIndex:1], @"");
    XCTAssertTrue(711   ==  [message packedFloatAtIndex:1], @"");
    XCTAssertTrue(712   ==  [message packedDoubleAtIndex:1], @"");
    XCTAssertTrue(NO ==  [message packedBoolAtIndex:1], @"");
    XCTAssertTrue(ForeignEnumFOREIGNBAZ ==  [message packedEnumAtIndex:0], @"");
}


+ (void) assertPackedFieldsSet:(TestPackedTypes*) message {
    [[[TestUtilities alloc] init]  assertPackedFieldsSet:message];
}



+ (void) setPackedExtensions:(TestPackedExtensions_Builder*) message {
    [message addExtension:[UnittestRoot packedInt32Extension   ] value:@601];
    [message addExtension:[UnittestRoot packedInt64Extension   ] value:@602LL];
    [message addExtension:[UnittestRoot packedUint32Extension  ] value:@603];
    [message addExtension:[UnittestRoot packedUint64Extension  ] value:@604LL];
    [message addExtension:[UnittestRoot packedSint32Extension  ] value:@605];
    [message addExtension:[UnittestRoot packedSint64Extension  ] value:@606LL];
    [message addExtension:[UnittestRoot packedFixed32Extension ] value:@607];
    [message addExtension:[UnittestRoot packedFixed64Extension ] value:@608LL];
    [message addExtension:[UnittestRoot packedSfixed32Extension] value:@609];
    [message addExtension:[UnittestRoot packedSfixed64Extension] value:@610LL];
    [message addExtension:[UnittestRoot packedFloatExtension   ] value:@611.0F];
    [message addExtension:[UnittestRoot packedDoubleExtension  ] value:@612.0];
    [message addExtension:[UnittestRoot packedBoolExtension    ] value:@YES];
    [message addExtension:[UnittestRoot packedEnumExtension] value:@(ForeignEnumFOREIGNBAR)];
    // Add a second one of each field.
    [message addExtension:[UnittestRoot packedInt32Extension   ] value:@701];
    [message addExtension:[UnittestRoot packedInt64Extension   ] value:@702LL];
    [message addExtension:[UnittestRoot packedUint32Extension  ] value:@703];
    [message addExtension:[UnittestRoot packedUint64Extension  ] value:@704LL];
    [message addExtension:[UnittestRoot packedSint32Extension  ] value:@705];
    [message addExtension:[UnittestRoot packedSint64Extension  ] value:@706LL];
    [message addExtension:[UnittestRoot packedFixed32Extension ] value:@707];
    [message addExtension:[UnittestRoot packedFixed64Extension ] value:@708LL];
    [message addExtension:[UnittestRoot packedSfixed32Extension] value:@709];
    [message addExtension:[UnittestRoot packedSfixed64Extension] value:@710LL];
    [message addExtension:[UnittestRoot packedFloatExtension   ] value:@711.0F];
    [message addExtension:[UnittestRoot packedDoubleExtension  ] value:@712.0];
    [message addExtension:[UnittestRoot packedBoolExtension    ] value:@NO];
    [message addExtension:[UnittestRoot packedEnumExtension] value:@(ForeignEnumFOREIGNBAZ)];
}


- (void) assertPackedExtensionsSet:(TestPackedExtensions*) message {
    XCTAssertTrue(2 ==  [[message getExtension:[UnittestRoot packedInt32Extension   ]] count], @"");
    XCTAssertTrue(2 ==  [[message getExtension:[UnittestRoot packedInt64Extension   ]] count], @"");
    XCTAssertTrue(2 ==  [[message getExtension:[UnittestRoot packedUint32Extension  ]] count], @"");
    XCTAssertTrue(2 ==  [[message getExtension:[UnittestRoot packedUint64Extension  ]] count], @"");
    XCTAssertTrue(2 ==  [[message getExtension:[UnittestRoot packedSint32Extension  ]] count], @"");
    XCTAssertTrue(2 ==  [[message getExtension:[UnittestRoot packedSint64Extension  ]] count], @"");
    XCTAssertTrue(2 ==  [[message getExtension:[UnittestRoot packedFixed32Extension ]] count], @"");
    XCTAssertTrue(2 ==  [[message getExtension:[UnittestRoot packedFixed64Extension ]] count], @"");
    XCTAssertTrue(2 ==  [[message getExtension:[UnittestRoot packedSfixed32Extension]] count], @"");
    XCTAssertTrue(2 ==  [[message getExtension:[UnittestRoot packedSfixed64Extension]] count], @"");
    XCTAssertTrue(2 ==  [[message getExtension:[UnittestRoot packedFloatExtension   ]] count], @"");
    XCTAssertTrue(2 ==  [[message getExtension:[UnittestRoot packedDoubleExtension  ]] count], @"");
    XCTAssertTrue(2 ==  [[message getExtension:[UnittestRoot packedBoolExtension    ]] count], @"");
    XCTAssertTrue(2 ==  [[message getExtension:[UnittestRoot packedEnumExtension]] count], @"");
    XCTAssertTrue(601   ==  [[message getExtension:[UnittestRoot packedInt32Extension   ]][0] intValue], @"");
    XCTAssertTrue(602L  ==  [[message getExtension:[UnittestRoot packedInt64Extension   ]][0] longLongValue], @"");
    XCTAssertTrue(603   ==  [[message getExtension:[UnittestRoot packedUint32Extension  ]][0] intValue], @"");
    XCTAssertTrue(604L  ==  [[message getExtension:[UnittestRoot packedUint64Extension  ]][0] longLongValue], @"");
    XCTAssertTrue(605   ==  [[message getExtension:[UnittestRoot packedSint32Extension  ]][0] intValue], @"");
    XCTAssertTrue(606L  ==  [[message getExtension:[UnittestRoot packedSint64Extension  ]][0] longLongValue], @"");
    XCTAssertTrue(607   ==  [[message getExtension:[UnittestRoot packedFixed32Extension ]][0] intValue], @"");
    XCTAssertTrue(608L  ==  [[message getExtension:[UnittestRoot packedFixed64Extension ]][0] longLongValue], @"");
    XCTAssertTrue(609   ==  [[message getExtension:[UnittestRoot packedSfixed32Extension]][0] intValue], @"");
    XCTAssertTrue(610L  ==  [[message getExtension:[UnittestRoot packedSfixed64Extension]][0] longLongValue], @"");
    XCTAssertTrue(611.0F  ==  [[message getExtension:[UnittestRoot packedFloatExtension   ]][0] floatValue], @"");
    XCTAssertTrue(612.0  ==  [[message getExtension:[UnittestRoot packedDoubleExtension  ]][0] doubleValue], @"");
    XCTAssertTrue(YES  ==  [[message getExtension:[UnittestRoot packedBoolExtension    ]][0] boolValue], @"");
    XCTAssertTrue(ForeignEnumFOREIGNBAR == [[message getExtension:[UnittestRoot packedEnumExtension]][0] intValue], @"");
    XCTAssertTrue(701   ==  [[message getExtension:[UnittestRoot packedInt32Extension   ]][1] intValue], @"");
    XCTAssertTrue(702L  ==  [[message getExtension:[UnittestRoot packedInt64Extension   ]][1] longLongValue], @"");
    XCTAssertTrue(703   ==  [[message getExtension:[UnittestRoot packedUint32Extension  ]][1] intValue], @"");
    XCTAssertTrue(704L  ==  [[message getExtension:[UnittestRoot packedUint64Extension  ]][1] longLongValue], @"");
    XCTAssertTrue(705   ==  [[message getExtension:[UnittestRoot packedSint32Extension  ]][1] intValue], @"");
    XCTAssertTrue(706L  ==  [[message getExtension:[UnittestRoot packedSint64Extension  ]][1] longLongValue], @"");
    XCTAssertTrue(707   ==  [[message getExtension:[UnittestRoot packedFixed32Extension ]][1] intValue], @"");
    XCTAssertTrue(708L  ==  [[message getExtension:[UnittestRoot packedFixed64Extension ]][1] longLongValue], @"");
    XCTAssertTrue(709   ==  [[message getExtension:[UnittestRoot packedSfixed32Extension]][1] intValue], @"");
    XCTAssertTrue(710L  ==  [[message getExtension:[UnittestRoot packedSfixed64Extension]][1] longLongValue], @"");
    XCTAssertTrue(711.0F  ==  [[message getExtension:[UnittestRoot packedFloatExtension   ]][1] floatValue], @"");
    XCTAssertTrue(712.0  ==  [[message getExtension:[UnittestRoot packedDoubleExtension  ]][1] doubleValue], @"");
    XCTAssertTrue(NO ==  [[message getExtension:[UnittestRoot packedBoolExtension    ]][1] boolValue], @"");
    XCTAssertTrue(ForeignEnumFOREIGNBAZ == [[message getExtension:[UnittestRoot packedEnumExtension]][1] intValue], @"");
}


+ (void) assertPackedExtensionsSet:(TestPackedExtensions*) message {
    [[[TestUtilities alloc] init]  assertPackedExtensionsSet:message];
}


@end
