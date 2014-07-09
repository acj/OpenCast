//
//  RingBuffer.m
//  Protocol Buffers for Objective C
//
//

#import "RingBuffer.h"


@implementation RingBuffer{
	NSMutableData *_buffer;
	NSInteger _position;
	NSInteger _tail;
}

- (instancetype)initWithData:(NSMutableData*)data {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    _buffer = data;
    
	return self;
}


- (NSUInteger)freeSpace {
	return (_position < _tail ? _tail - _position : (_buffer.length - _position) + _tail) - (_tail ? 1 : 0);
}


- (BOOL)appendByte:(uint8_t)byte {
	if (self.freeSpace < 1) return NO;
	((uint8_t*)_buffer.mutableBytes)[_position++] = byte;
	return YES;
}


- (NSInteger)appendData:(const NSData*)value offset:(int32_t)offset length:(int32_t)length {
	NSInteger totalWritten = 0;
	const uint8_t *input = value.bytes;
	uint8_t *data = _buffer.mutableBytes;
	
	if (_position >= _tail) {
		totalWritten = MIN(_buffer.length - _position, length);
		memcpy(data + _position, input + offset, totalWritten);
		_position += totalWritten;
		if (totalWritten == length) return length;
		length -= totalWritten;
		offset += totalWritten;
	}
	
	NSUInteger freeSpace = self.freeSpace;
	if (!freeSpace) return totalWritten;
	
	if (_position == _buffer.length) {
		_position = 0;
	}
	
	// position < tail
	NSInteger written = MIN(freeSpace, length);
	memcpy(data + _position, input + offset, written);
	_position += written;
	totalWritten += written;
	
	return totalWritten;
}


- (NSInteger)flushToOutputStream:(NSOutputStream*)stream {
	NSInteger totalWritten = 0;
	const uint8_t *data = _buffer.bytes;
	
	if (_tail > _position) {
		NSInteger written = [stream write:data + _tail maxLength:_buffer.length - _tail];
        if (written <= 0) return totalWritten;
        totalWritten += written;
		_tail += written;
		if (_tail == _buffer.length) {
			_tail = 0;
		}
	}

	if (_tail < _position) {
		NSInteger written = [stream write:data + _tail maxLength:_position - _tail];
		if (written <= 0) return totalWritten;
		totalWritten += written;
		_tail += written;
	}

    if (_tail == _position) {
        _tail = _position = 0;
    }

    if (_position == _buffer.length && _tail > 0) {
        _position = 0;
    }

    if (_tail == _buffer.length) {
        _tail = 0;
    }
	
	return totalWritten;
}


@end
