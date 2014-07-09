//
//  RingBuffer.h
//  Protocol Buffers for Objective C
//
//

#import <Foundation/Foundation.h>


@interface RingBuffer : NSObject

- (instancetype)initWithData:(NSMutableData*)data;

// Returns false if there is not enough free space in buffer
- (BOOL)appendByte:(uint8_t)byte;

// Returns number of bytes written
- (NSInteger)appendData:(const NSData*)value
                 offset:(int32_t)offset
                 length:(int32_t)length;

// Returns number of bytes written
- (NSInteger)flushToOutputStream:(NSOutputStream*)stream;

@end
