//
//  CodedInputStream.h
//  Protocol Buffers for Objective C
//
//  Copyright 2014 Ed Preston
//  Copyright 2010 Booyah Inc.
//  Copyright 2008 Cyrus Najmabadi
//

@class PBExtensionRegistry;
@class PBUnknownFieldSet_Builder;
@protocol PBMessage_Builder;

/**
 * Reads and decodes protocol message fields.
 *
 * This class contains two kinds of methods:  methods that read specific
 * protocol message constructs and field types (e.g. {@link #readTag()} and
 * {@link #readInt32()}) and methods that read low-level values (e.g.
 * {@link #readRawVarint32()} and {@link #readRawBytes}).  If you are reading
 * encoded protocol messages, you should use the former methods, but if you are
 * reading some other format of your own design, use the latter.
 *
 * @author Cyrus Najmabadi
 */
@interface PBCodedInputStream : NSObject

+ (instancetype)streamWithData:(NSData*)data;
+ (instancetype)streamWithInputStream:(NSInputStream*)input;

/**
 * Attempt to read a field tag, returning zero if we have reached EOF.
 * Protocol message parsers use this to read tags, since a protocol message
 * may legally end wherever a tag occurs, and zero is not a valid tag number.
 */
- (int32_t)readTag;
- (BOOL)refillBuffer:(BOOL)mustSucceed;

- (Float64)readDouble;
- (Float32)readFloat;
- (uint64_t)readUInt64;
- (uint32_t)readUInt32;
- (int64_t)readInt64;
- (int32_t)readInt32;
- (int64_t)readFixed64;
- (int32_t)readFixed32;
- (int32_t)readEnum;
- (int32_t)readSFixed32;
- (int64_t)readSFixed64;
- (int32_t)readSInt32;
- (int64_t)readSInt64;

/**
 * Read one byte from the input.
 */
- (int8_t)readRawByte;

/**
 * Read a raw Varint from the stream.  If larger than 32 bits, discard the
 * upper bits.
 */
- (int32_t)readRawVarint32;
- (int64_t)readRawVarint64;
- (int32_t)readRawLittleEndian32;
- (int64_t)readRawLittleEndian64;

/**
 * Read a fixed size of bytes from the input.
 */
- (NSData*)readRawData:(int32_t)size;

/**
 * Reads and discards a single field, given its tag value.
 *
 * @return {@code false} if the tag is an endgroup tag, in which case
 *         nothing is skipped.  Otherwise, returns {@code true}.
 */
- (BOOL)skipField:(int32_t)tag;


/**
 * Reads and discards {@code size} bytes.
 */
- (void)skipRawData:(int32_t)size;

/**
 * Reads and discards an entire message.  This will read either until EOF
 * or until an endgroup tag, whichever comes first.
 */
- (void)skipMessage;

- (BOOL)isAtEnd;
- (int32_t)pushLimit:(int32_t)byteLimit;
- (void)recomputeBufferSizeAfterLimit;
- (void)popLimit:(int32_t)oldLimit;
- (int32_t)bytesUntilLimit;


/** Read an embedded message field value from the stream. */
- (void) readMessage:(id<PBMessage_Builder>)builder
   extensionRegistry:(PBExtensionRegistry*)extensionRegistry;

- (BOOL)readBool;
- (NSString*)readString;
- (NSData*)readData;

- (void)readGroup:(int32_t)fieldNumber
          builder:(id<PBMessage_Builder>)builder
extensionRegistry:(PBExtensionRegistry*)extensionRegistry;

/**
 * Reads a {@code group} field value from the stream and merges it into the
 * given {@link UnknownFieldSet}.
 */
- (void)readUnknownGroup:(int32_t)fieldNumber
                 builder:(PBUnknownFieldSet_Builder*)builder;

/**
 * Verifies that the last call to readTag() returned the given tag value.
 * This is used to verify that a nested group ended with the correct
 * end tag.
 */
- (void)checkLastTagWas:(int32_t)value;

@end
