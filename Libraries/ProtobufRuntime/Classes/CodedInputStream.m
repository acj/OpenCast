//
//  CodedInputStream.m
//  Protocol Buffers for Objective C
//
//  Copyright 2014 Ed Preston
//  Copyright 2010 Booyah Inc.
//  Copyright 2008 Cyrus Najmabadi
//

#import "CodedInputStream.h"

#import "Message_Builder.h"
#import "Utilities.h"
#import "WireFormat.h"
#import "UnknownFieldSet.h"
#import "UnknownFieldSet_Builder.h"


#pragma mark - PBCodedInputStream

@implementation PBCodedInputStream {
    NSInputStream* _input;
    NSMutableData* _buffer;
    
    int32_t _bufferSize;
    int32_t _bufferSizeAfterLimit;
    int32_t _bufferPos;
    
    int32_t _lastTag;
    
    /**
     * The total number of bytes read before the current buffer.  The total
     * bytes read up to the current position can be computed as
     * {@code totalBytesRetired + bufferPos}.
     */
    int32_t _totalBytesRetired;
    
    /** The absolute position of the end of the current message. */
    int32_t _currentLimit;
    
    /** See setRecursionLimit() */
    uint32_t _recursionDepth;
    uint32_t _recursionLimit;
    
    /** See setSizeLimit() */
    int32_t _sizeLimit;
}

const int32_t DEFAULT_RECURSION_LIMIT = 64;
const int32_t DEFAULT_SIZE_LIMIT = 64 << 20;  // 64MB
const int32_t BUFFER_SIZE = 4096;


- (void)dealloc {
    [_input close];
}

- (void)commonInit {
    _currentLimit = INT_MAX;
    _recursionLimit = DEFAULT_RECURSION_LIMIT;
    _sizeLimit = DEFAULT_SIZE_LIMIT;
}

- (instancetype)initWithData:(NSData*)data {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    _buffer = [NSMutableData dataWithData:data];
    uint32_t bufferLength = 0; bufferLength += _buffer.length;
    _bufferSize = bufferLength;
    _input = nil;
    
    [self commonInit];
    
    return self;
}

- (instancetype)initWithInputStream:(NSInputStream*)input {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    _buffer = [NSMutableData dataWithLength:BUFFER_SIZE];
    _bufferSize = 0;
    _input = input;
    [_input open];
    
    [self commonInit];
    
    return self;
}

+ (instancetype)streamWithData:(NSData*)data {
    return [[PBCodedInputStream alloc] initWithData:data];
}

+ (instancetype)streamWithInputStream:(NSInputStream*)input {
    return [[PBCodedInputStream alloc] initWithInputStream:input];
}

/**
 * Attempt to read a field tag, returning zero if we have reached EOF.
 * Protocol message parsers use this to read tags, since a protocol message
 * may legally end wherever a tag occurs, and zero is not a valid tag number.
 */
- (int32_t)readTag {
    if (self.isAtEnd) {
        _lastTag = 0;
        return 0;
    }
    
    _lastTag = [self readRawVarint32];
    if (_lastTag == 0) {
        // If we actually read zero, that's not a valid tag.
        NSAssert(NO, @"Invalid Tag 0 read from protocol buffer.");
    }
    return _lastTag;
}

/**
 * Verifies that the last call to readTag() returned the given tag value.
 * This is used to verify that a nested group ended with the correct
 * end tag.
 */
- (void)checkLastTagWas:(int32_t)value {
    if (_lastTag != value) {
        NSAssert(NO, @"Invalid End Tag read from protocol buffer.");
    }
}

/**
 * Reads and discards a single field, given its tag value.
 *
 * @return {@code NO} if the tag is an endgroup tag, in which case
 *         nothing is skipped.  Otherwise, returns {@code YES}.
 */
- (BOOL)skipField:(int32_t)tag {
    switch (PBWireFormatGetTagWireType(tag)) {
        case PBWireFormatVarint:
            [self readInt32];
            return YES;
        case PBWireFormatFixed64:
            [self readRawLittleEndian64];
            return YES;
        case PBWireFormatLengthDelimited:
            [self skipRawData:[self readRawVarint32]];
            return YES;
        case PBWireFormatStartGroup:
            [self skipMessage];
            [self checkLastTagWas:
             PBWireFormatMakeTag(PBWireFormatGetTagFieldNumber(tag),
                                 PBWireFormatEndGroup)];
            return YES;
        case PBWireFormatEndGroup:
            return NO;
        case PBWireFormatFixed32:
            [self readRawLittleEndian32];
            return YES;
        default:
            NSAssert(NO, @"Invalid Wire Type read from protocol buffer.");

    }
    
    return NO;
}

/**
 * Reads and discards an entire message.  This will read either until EOF
 * or until an endgroup tag, whichever comes first.
 */
- (void)skipMessage {
    while (YES) {
        int32_t tag = [self readTag];
        if (tag == 0 || ![self skipField:tag]) {
            return;
        }
    }
}

/** Read a {@code double} field value from the stream. */
- (Float64)readDouble {
    return convertInt64ToFloat64([self readRawLittleEndian64]);
}

/** Read a {@code float} field value from the stream. */
- (Float32)readFloat {
    return convertInt32ToFloat32([self readRawLittleEndian32]);
}

/** Read a {@code uint64} field value from the stream. */
- (uint64_t)readUInt64 {
    return [self readRawVarint64];
}

/** Read an {@code int64} field value from the stream. */
- (int64_t)readInt64 {
    return [self readRawVarint64];
}

/** Read an {@code int32} field value from the stream. */
- (int32_t)readInt32 {
    return [self readRawVarint32];
}

/** Read a {@code fixed64} field value from the stream. */
- (int64_t)readFixed64 {
    return [self readRawLittleEndian64];
}

/** Read a {@code fixed32} field value from the stream. */
- (int32_t)readFixed32 {
    return [self readRawLittleEndian32];
}

/** Read a {@code bool} field value from the stream. */
- (BOOL)readBool {
    return [self readRawVarint32] != 0;
}

/** Read a {@code string} field value from the stream. */
- (NSString*)readString {
    int32_t size = [self readRawVarint32];
    if (size <= (_bufferSize - _bufferPos) && size > 0) {
        // Fast path:  We already have the bytes in a contiguous buffer, so
        //   just copy directly from it.
        //  new String(buffer, bufferPos, size, "UTF-8");
        NSString* result = [[NSString alloc] initWithBytes:(((uint8_t*) _buffer.bytes) + _bufferPos)
                                                    length:size
                                                  encoding:NSUTF8StringEncoding] ;
        _bufferPos += size;
        return result;
    } else {
        // Slow path:  Build a byte array first then copy it.
        NSData* data = [self readRawData:size];
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
    }
}


/** Read a {@code group} field value from the stream. */
- (void)      readGroup:(int32_t) fieldNumber
                builder:(id<PBMessage_Builder>) builder
      extensionRegistry:(PBExtensionRegistry*) extensionRegistry
{
    if (_recursionDepth >= _recursionLimit) {
        NSAssert(NO, @"Recursion Limit Exceeded reading protocol buffer.");
    }
    ++_recursionDepth;
    [builder mergeFromCodedInputStream:self extensionRegistry:extensionRegistry];
    [self checkLastTagWas:PBWireFormatMakeTag(fieldNumber, PBWireFormatEndGroup)];
    --_recursionDepth;
}


/**
 * Reads a {@code group} field value from the stream and merges it into the
 * given {@link PBUnknownFieldSet}.
 */
- (void)readUnknownGroup:(int32_t) fieldNumber
                 builder:(PBUnknownFieldSet_Builder*) builder
{
    if (_recursionDepth >= _recursionLimit) {
        NSAssert(NO, @"Recursion Limit Exceeded reading protocol buffer.");
    }
    ++_recursionDepth;
    [builder mergeFromCodedInputStream:self];
    [self checkLastTagWas:PBWireFormatMakeTag(fieldNumber, PBWireFormatEndGroup)];
    --_recursionDepth;
}


/** Read an embedded message field value from the stream. */
- (void)readMessage:(id<PBMessage_Builder>) builder
  extensionRegistry:(PBExtensionRegistry*) extensionRegistry
{
    int32_t length = [self readRawVarint32];
    if (_recursionDepth >= _recursionLimit) {
        NSAssert(NO, @"Recursion Limit Exceeded reading protocol buffer.");
    }
    int32_t oldLimit = [self pushLimit:length];
    ++_recursionDepth;
    [builder mergeFromCodedInputStream:self extensionRegistry:extensionRegistry];
    [self checkLastTagWas:0];
    --_recursionDepth;
    [self popLimit:oldLimit];
}

/** Read a {@code bytes} field value from the stream. */
- (NSData*)readData {
    int32_t size = [self readRawVarint32];
    if (size < _bufferSize - _bufferPos && size > 0) {
        // Fast path:  We already have the bytes in a contiguous buffer, so
        //   just copy directly from it.
        NSData* result = [NSData dataWithBytes:(((uint8_t*) _buffer.bytes) + _bufferPos) length:size];
        _bufferPos += size;
        return result;
    } else {
        // Slow path:  Build a byte array first then copy it.
        return [self readRawData:size];
    }
}

/** Read a {@code uint32} field value from the stream. */
- (uint32_t)readUInt32 {
    return [self readRawVarint32];
}

/**
 * Read an enum field value from the stream.  Caller is responsible
 * for converting the numeric value to an actual enum.
 */
- (int32_t)readEnum {
    return [self readRawVarint32];
}

/** Read an {@code sfixed32} field value from the stream. */
- (int32_t)readSFixed32 {
    return [self readRawLittleEndian32];
}

/** Read an {@code sfixed64} field value from the stream. */
- (int64_t)readSFixed64 {
    return [self readRawLittleEndian64];
}

/** Read an {@code sint32} field value from the stream. */
- (int32_t)readSInt32 {
    return decodeZigZag32([self readRawVarint32]);
}

/** Read an {@code sint64} field value from the stream. */
- (int64_t)readSInt64 {
    return decodeZigZag64([self readRawVarint64]);
}


// =================================================================

/**
 * Read a raw Varint from the stream.  If larger than 32 bits, discard the
 * upper bits.
 */
- (int32_t)readRawVarint32 {
    int8_t tmp = [self readRawByte];
    if (tmp >= 0) {
        return tmp;
    }
    int32_t result = tmp & 0x7f;
    if ((tmp = [self readRawByte]) >= 0) {
        result |= tmp << 7;
    } else {
        result |= (tmp & 0x7f) << 7;
        if ((tmp = [self readRawByte]) >= 0) {
            result |= tmp << 14;
        } else {
            result |= (tmp & 0x7f) << 14;
            if ((tmp = [self readRawByte]) >= 0) {
                result |= tmp << 21;
            } else {
                result |= (tmp & 0x7f) << 21;
                result |= (tmp = [self readRawByte]) << 28;
                if (tmp < 0) {
                    // Discard upper 32 bits.
                    for (int i = 0; i < 5; i++) {
                        if ([self readRawByte] >= 0) {
                            return result;
                        }
                    }
                    NSAssert(NO, @"Malformed Varint found reading protocol buffer.");
                }
            }
        }
    }
    return result;
}

/** Read a raw Varint from the stream. */
- (int64_t)readRawVarint64 {
    int32_t shift = 0;
    int64_t result = 0;
    while (shift < 64) {
        int8_t b = [self readRawByte];
        result |= (int64_t)(b & 0x7F) << shift;
        if ((b & 0x80) == 0) {
            return result;
        }
        shift += 7;
    }
    
    // We should not get here
    NSAssert(NO, @"Malformed Varint found reading protocol buffer.");
    return result;
}

/** Read a 32-bit little-endian integer from the stream. */
- (int32_t)readRawLittleEndian32 {
    int8_t b1 = [self readRawByte];
    int8_t b2 = [self readRawByte];
    int8_t b3 = [self readRawByte];
    int8_t b4 = [self readRawByte];
    return
    (((int32_t)b1 & 0xff)      ) |
    (((int32_t)b2 & 0xff) <<  8) |
    (((int32_t)b3 & 0xff) << 16) |
    (((int32_t)b4 & 0xff) << 24);
}

/** Read a 64-bit little-endian integer from the stream. */
- (int64_t)readRawLittleEndian64 {
    int8_t b1 = [self readRawByte];
    int8_t b2 = [self readRawByte];
    int8_t b3 = [self readRawByte];
    int8_t b4 = [self readRawByte];
    int8_t b5 = [self readRawByte];
    int8_t b6 = [self readRawByte];
    int8_t b7 = [self readRawByte];
    int8_t b8 = [self readRawByte];
    return
    (((int64_t)b1 & 0xff)      ) |
    (((int64_t)b2 & 0xff) <<  8) |
    (((int64_t)b3 & 0xff) << 16) |
    (((int64_t)b4 & 0xff) << 24) |
    (((int64_t)b5 & 0xff) << 32) |
    (((int64_t)b6 & 0xff) << 40) |
    (((int64_t)b7 & 0xff) << 48) |
    (((int64_t)b8 & 0xff) << 56);
}

/**
 * Set the maximum message recursion depth.  In order to prevent malicious
 * messages from causing stack overflows, {@code PBCodedInputStream} limits
 * how deeply messages may be nested.  The default limit is 64.
 *
 * @return the old limit.
 */
- (int32_t)setRecursionLimit:(int32_t)limit {
    NSAssert((limit > 0), @"Recursion limit cannot be negative.");
    
    int32_t oldLimit = _recursionLimit;
    _recursionLimit = limit;
    return oldLimit;
}

/**
 * Set the maximum message size.  In order to prevent malicious
 * messages from exhausting memory or causing integer overflows,
 * {@code PBCodedInputStream} limits how large a message may be.
 * The default limit is 64MB.  You should set this limit as small
 * as you can without harming your app's functionality.  Note that
 * size limits only apply when reading from an {@code InputStream}, not
 * when constructed around a raw byte array.
 *
 * @return the old limit.
 */
- (int32_t)setSizeLimit:(int32_t)limit {
    NSAssert((limit >= 0), @"Size limit cannot be negative.");

    int32_t oldLimit = _sizeLimit;
    _sizeLimit = limit;
    return oldLimit;
}

/**
 * Resets the current size counter to zero (see {@link #setSizeLimit(int)}).
 */
- (void)resetSizeCounter {
    _totalBytesRetired = 0;
}

/**
 * Sets {@code currentLimit} to (current position) + {@code byteLimit}.  This
 * is called when descending into a length-delimited embedded message.
 *
 * @return the old limit.
 */
- (int32_t)pushLimit:(int32_t)byteLimit {
    NSAssert((byteLimit >= 0), @"Byte limit cannot be negative.");

    byteLimit += _totalBytesRetired + _bufferPos;
    int32_t oldLimit = _currentLimit;
    if (byteLimit > oldLimit) {
        NSAssert(NO, @"Truncated Message read from protocol buffer.");
    }
    _currentLimit = byteLimit;
    
    [self recomputeBufferSizeAfterLimit];
    
    return oldLimit;
}

- (void)recomputeBufferSizeAfterLimit {
    _bufferSize += _bufferSizeAfterLimit;
    int32_t bufferEnd = _totalBytesRetired + _bufferSize;
    if (bufferEnd > _currentLimit) {
        // Limit is in current buffer.
        _bufferSizeAfterLimit = bufferEnd - _currentLimit;
        _bufferSize -= _bufferSizeAfterLimit;
    } else {
        _bufferSizeAfterLimit = 0;
    }
}

/**
 * Discards the current limit, returning to the previous limit.
 *
 * @param oldLimit The old limit, as returned by {@code pushLimit}.
 */
- (void)popLimit:(int32_t)oldLimit {
    _currentLimit = oldLimit;
    [self recomputeBufferSizeAfterLimit];
}

/**
 * Returns the number of bytes to be read before the current limit.
 * If no limit is set, returns -1.
 */
- (int32_t)bytesUntilLimit {
    if (_currentLimit == INT_MAX) {
        return -1;
    }
    
    int32_t currentAbsolutePosition = _totalBytesRetired + _bufferPos;
    return _currentLimit - currentAbsolutePosition;
}

/**
 * Returns true if the stream has reached the end of the input.  This is the
 * case if either the end of the underlying input source has been reached or
 * if the stream has reached a limit created using {@link #pushLimit(int)}.
 */
- (BOOL)isAtEnd {
    return _bufferPos == _bufferSize && ![self refillBuffer:NO];
}

/**
 * Called with {@code this.buffer} is empty to read more bytes from the
 * input.  If {@code mustSucceed} is YES, refillBuffer() gurantees that
 * either there will be at least one byte in the buffer when it returns
 * or it will throw an exception.  If {@code mustSucceed} is NO,
 * refillBuffer() returns NO if no more bytes were available.
 */
- (BOOL)refillBuffer:(BOOL)mustSucceed {
    if (_bufferPos < _bufferSize) {
        NSAssert(NO, @"RefillBuffer called when buffer wasn't empty.");
        return NO;
    }
    
    if (_totalBytesRetired + _bufferSize == _currentLimit) {
        // Oops, we hit a limit.
        if (mustSucceed) {
            NSAssert(NO, @"Truncated Message read from protocol buffer.");
        } else {
            return NO;
        }
    }
    
    _totalBytesRetired += _bufferSize;
    
    // TODO(cyrusn): does NSInputStream behave the same as java.io.InputStream
    // when there is no more data?
    _bufferPos = 0;
    _bufferSize = 0;
    if (_input != nil) {
        int32_t readLength = 0;
        readLength += [_input read:_buffer.mutableBytes maxLength:_buffer.length];
        _bufferSize = readLength;
    }
    
    if (_bufferSize <= 0) {
        _bufferSize = 0;
        if (mustSucceed) {
            NSAssert(NO, @"Truncated Message read from protocol buffer.");
        } else {
            return NO;
        }
    } else {
        [self recomputeBufferSizeAfterLimit];
        int32_t totalBytesRead = _totalBytesRetired + _bufferSize + _bufferSizeAfterLimit;
        if (totalBytesRead > _sizeLimit || totalBytesRead < 0) {
            NSAssert(NO, @"Size limit exceeded reading protocol buffer.");
        }
        return YES;
    }
    
    return NO;
}

/**
 * Read one byte from the input.
 */
- (int8_t)readRawByte {
    if (_bufferPos == _bufferSize) {
        [self refillBuffer:YES];
    }
    int8_t* bytes = (int8_t*)_buffer.bytes;
    return bytes[_bufferPos++];
}

/**
 * Read a fixed size of bytes from the input.
 */
- (NSData*)readRawData:(int32_t)size {
    
    NSParameterAssert(size >= 0);
    
    if (size <= 0) {
        return nil;
    }
    
    if (_totalBytesRetired + _bufferPos + size > _currentLimit) {
        // Read to the end of the stream anyway.
        [self skipRawData:_currentLimit - _totalBytesRetired - _bufferPos];
        // Then fail.
        NSAssert(NO, @"Truncated Message read from protocol buffer.");
    }
    
    if (size <= _bufferSize - _bufferPos) {
        // We have all the bytes we need already.
        NSData* data = [NSData dataWithBytes:(((int8_t*) _buffer.bytes) + _bufferPos) length:size];
        _bufferPos += size;
        return data;
    } else if (size < BUFFER_SIZE) {
        // Reading more bytes than are in the buffer, but not an excessive number
        // of bytes.  We can safely allocate the resulting array ahead of time.
        
        // First copy what we have.
        NSMutableData* bytes = [NSMutableData dataWithLength:size];
        int32_t pos = _bufferSize - _bufferPos;
        memcpy(bytes.mutableBytes, ((int8_t*)_buffer.bytes) + _bufferPos, pos);
        _bufferPos = _bufferSize;
        
        // We want to use refillBuffer() and then copy from the buffer into our
        // byte array rather than reading directly into our byte array because
        // the input may be unbuffered.
        [self refillBuffer:YES];
        
        while (size - pos > _bufferSize) {
            memcpy(((int8_t*)bytes.mutableBytes) + pos, _buffer.bytes, _bufferSize);
            pos += _bufferSize;
            _bufferPos = _bufferSize;
            [self refillBuffer:YES];
        }
        
        memcpy(((int8_t*)bytes.mutableBytes) + pos, _buffer.bytes, size - pos);
        _bufferPos = size - pos;
        
        return bytes;
    } else {
        // The size is very large.  For security reasons, we can't allocate the
        // entire byte array yet.  The size comes directly from the input, so a
        // maliciously-crafted message could provide a bogus very large size in
        // order to trick the app into allocating a lot of memory.  We avoid this
        // by allocating and reading only a small chunk at a time, so that the
        // malicious message must actuall* e* extremely large to cause
        // problems.  Meanwhile, we limit the allowed size of a message elsewhere.
        
        // Remember the buffer markers since we'll have to copy the bytes out of
        // it later.
        int32_t originalBufferPos = _bufferPos;
        int32_t originalBufferSize = _bufferSize;
        
        // Mark the current buffer consumed.
        _totalBytesRetired += _bufferSize;
        _bufferPos = 0;
        _bufferSize = 0;
        
        // Read all the rest of the bytes we need.
        int32_t sizeLeft = size - (originalBufferSize - originalBufferPos);
        NSMutableArray* chunks = [NSMutableArray array];
        
        while (sizeLeft > 0) {
            NSMutableData* chunk = [NSMutableData dataWithLength:MIN(sizeLeft, BUFFER_SIZE)];
            
            int32_t pos = 0;
            while (pos < chunk.length) {
                int32_t n = 0;
                if (_input != nil) {
                    n += [_input read:(((uint8_t*) chunk.mutableBytes) + pos) maxLength:chunk.length - pos];
                }
                if (n <= 0) {
                    NSAssert(NO, @"Truncated Message read from protocol buffer.");
                }
                _totalBytesRetired += n;
                pos += n;
            }
            sizeLeft -= chunk.length;
            [chunks addObject:chunk];
        }
        
        // OK, got everything.  Now concatenate it all into one buffer.
        NSMutableData* bytes = [NSMutableData dataWithLength:size];
        
        // Start by copying the leftover bytes from this.buffer.
        int32_t pos = originalBufferSize - originalBufferPos;
        memcpy(bytes.mutableBytes, ((int8_t*)_buffer.bytes) + originalBufferPos, pos);
        
        // And now all the chunks.
        for (NSData* chunk in chunks) {
            memcpy(((int8_t*)bytes.mutableBytes) + pos, chunk.bytes, chunk.length);
            pos += chunk.length;
        }
        
        // Done.
        return bytes;
    }
}

/**
 * Reads and discards {@code size} bytes.
 */
- (void)skipRawData:(int32_t)size {
    
    NSParameterAssert(size >= 0);
    
    if (size <= 0) {
        return;
    }
    
    if (_totalBytesRetired + _bufferPos + size > _currentLimit) {
        // Read to the end of the stream anyway.
        [self skipRawData:_currentLimit - _totalBytesRetired - _bufferPos];
        // Then fail.
        NSAssert(NO, @"Truncated Message read from protocol buffer.");
    }
    
    if (size <= (_bufferSize - _bufferPos)) {
        // We have all the bytes we need already.
        _bufferPos += size;
    } else {
        // Skipping more bytes than are in the buffer.  First skip what we have.
        int32_t pos = _bufferSize - _bufferPos;
        _totalBytesRetired += pos;
        _bufferPos = 0;
        _bufferSize = 0;
        
        // Then skip directly from the InputStream for the rest.
        while (pos < size) {
            NSMutableData* data = [NSMutableData dataWithLength:(size - pos)];
            int32_t n = (_input == nil) ? -1 : (int32_t)[_input read:data.mutableBytes maxLength:(size - pos)];
            if (n <= 0) {
                NSAssert(NO, @"Truncated Message read from protocol buffer.");
            }
            pos += n;
            _totalBytesRetired += n;
        }
    }
}


@end
