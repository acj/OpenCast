// Protocol Buffers for Objective C
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
#import "CoreTests.h"

@implementation CoreTests

- (void) testTypeSizes {
  XCTAssertEqual(4, (int)sizeof(int));	
  #ifdef __x86_64__	
    XCTAssertEqual(8, (int)sizeof(long));
  #else
    XCTAssertEqual(4, (int)sizeof(long), nil);
  #endif
  XCTAssertEqual(8, (int)sizeof(long long));
  XCTAssertEqual(4, (int)sizeof(int32_t));
  XCTAssertEqual(8, (int)sizeof(int64_t));
  XCTAssertEqual(4, (int)sizeof(Float32));
  XCTAssertEqual(8, (int)sizeof(Float64));
  XCTAssertEqual(0, !!0);
  XCTAssertEqual(1, !!1);
  XCTAssertEqual(1, !!2);
}

@end
