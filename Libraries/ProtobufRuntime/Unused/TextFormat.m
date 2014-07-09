//
//  TextFormat.m
//  Protocol Buffers for Objective C
//
//  Copyright 2014 Ed Preston
//  Copyright 2010 Booyah Inc.
//  Copyright 2008 Cyrus Najmabadi
//

#import "TextFormat.h"

#import "Utilities.h"


BOOL isOctal(unichar c) ;
BOOL allZeroes(NSString* string);
BOOL isDecimal(unichar c) ;
BOOL isHex(unichar c);
int32_t digitValue(unichar c);


/** Is this an octal digit? */
BOOL isOctal(unichar c) {
    return '0' <= c && c <= '7';
}

BOOL allZeroes(NSString* string) {
    for (int i = 0; i < string.length; i++) {
        if ([string characterAtIndex:i] != '0') {
            return NO;
        }
    }
    
    return YES;
}

/** Is this an octal digit? */
BOOL isDecimal(unichar c) {
    return '0' <= c && c <= '9';
}

/** Is this a hex digit? */
BOOL isHex(unichar c) {
    return
    isDecimal(c) ||
    ('a' <= c && c <= 'f') ||
    ('A' <= c && c <= 'F');
}

/**
 * Interpret a character as a digit (in any base up to 36) and return the
 * numeric value.  This is like {@code Character.digit()} but we don't accept
 * non-ASCII digits.
 */
int32_t digitValue(unichar c) {
    if ('0' <= c && c <= '9') {
        return c - '0';
    } else if ('a' <= c && c <= 'z') {
        return c - 'a' + 10;
    } else {
        return c - 'A' + 10;
    }
}


#pragma mark - PBTextFormat

@implementation PBTextFormat

+ (int64_t)parseInteger:(NSString*)text
                isSigned:(BOOL)isSigned
                  isLong:(BOOL)isLong {
    
    NSParameterAssert(text);
    NSParameterAssert(text.length > 0);
    
    if (isblank([text characterAtIndex:0])) {
        NSAssert(NO, @"Invalid character.");
        return 0;
    }
    
    if ([text hasPrefix:@"-"]) {
        if (!isSigned) {
            NSAssert(NO, @"Number must be positive.");
            return 0;
        }
    }
    
    // now call into the appropriate conversion utilities.
    int64_t result;
    const char* in_string = text.UTF8String;
    char* out_string = NULL;
    errno = 0;
    if (isLong) {
        if (isSigned) {
            result = strtoll(in_string, &out_string, 0);
        } else {
            result = convertUInt64ToInt64(strtoull(in_string, &out_string, 0));
        }
    } else {
        if (isSigned) {
            result = strtol(in_string, &out_string, 0);
        } else {
            uint32_t returnLength = 0; returnLength += strtoul(in_string, &out_string, 0);
            result = convertUInt32ToInt32(returnLength);
        }
    }
    
    // from the man pages:
    // (Thus, i* tr is not `\0' but **endptr is `\0' on return, the entire
    // string was valid.)
    if (*in_string == 0 || *out_string != 0) {
        NSAssert(NO, @"Illegal number.");
        return 0;
    }
    
    if (errno == ERANGE) {
        NSAssert(NO, @"Number out of range.");
        return 0;
    }
    
    return result;
}

/**
 * Parse a 32-bit signed integer from the text.  This function recognizes
 * the prefixes "0x" and "0" to signify hexidecimal and octal numbers,
 * respectively.
 */
+ (int32_t)parseInt32:(NSString*)text {
    NSParameterAssert(text);
    
    return (int32_t)[self parseInteger:text isSigned:YES isLong:NO];
}

/**
 * Parse a 32-bit unsigned integer from the text.  This function recognizes
 * the prefixes "0x" and "0" to signify hexidecimal and octal numbers,
 * respectively.  The result is coerced to a (signed) {@code int} when returned.
 */
+ (int32_t)parseUInt32:(NSString*)text {
    NSParameterAssert(text);
    
    return (int32_t)[self parseInteger:text isSigned:NO isLong:NO];
}

/**
 * Parse a 64-bit signed integer from the text.  This function recognizes
 * the prefixes "0x" and "0" to signify hexidecimal and octal numbers,
 * respectively.
 */
+ (int64_t)parseInt64:(NSString*)text {
    NSParameterAssert(text);
    
    return [self parseInteger:text isSigned:YES isLong:YES];
}

/**
 * Parse a 64-bit unsigned integer from the text.  This function recognizes
 * the prefixes "0x" and "0" to signify hexidecimal and octal numbers,
 * respectively.  The result is coerced to a (signed) {@code long} when
 * returned.
 */
+ (int64_t)parseUInt64:(NSString*)text {
    NSParameterAssert(text);
    
    return [self parseInteger:text isSigned:NO isLong:YES];
}

/**
 * Un-escape a byte sequence as escaped using
 * {@link #escapeBytes(ByteString)}.  Two-digit hex escapes (starting with
 * "\x") are also recognized.
 */
+ (NSData*)unescapeBytes:(NSString*)input {
    
    NSParameterAssert(input);
    
    NSMutableData* result = [NSMutableData dataWithLength:input.length];
    
    int32_t pos = 0;
    for (int32_t i = 0; i < input.length; i++) {
        unichar c = [input characterAtIndex:i];
        if (c == '\\') {
            if (i + 1 < input.length) {
                ++i;
                c = [input characterAtIndex:i];
                if (isOctal(c)) {
                    // Octal escape.
                    int32_t code = digitValue(c);
                    if (i + 1 < input.length && isOctal([input characterAtIndex:(i + 1)])) {
                        ++i;
                        code = code * 8 + digitValue([input characterAtIndex:i]);
                    }
                    if (i + 1 < input.length && isOctal([input characterAtIndex:(i + 1)])) {
                        ++i;
                        code = code * 8 + digitValue([input characterAtIndex:i]);
                    }
                    ((int8_t*)result.mutableBytes)[pos++] = (int8_t)code;
                } else {
                    switch (c) {
                        case 'a' : ((int8_t*)result.mutableBytes)[pos++] = 0x07; break;
                        case 'b' : ((int8_t*)result.mutableBytes)[pos++] = '\b'; break;
                        case 'f' : ((int8_t*)result.mutableBytes)[pos++] = '\f'; break;
                        case 'n' : ((int8_t*)result.mutableBytes)[pos++] = '\n'; break;
                        case 'r' : ((int8_t*)result.mutableBytes)[pos++] = '\r'; break;
                        case 't' : ((int8_t*)result.mutableBytes)[pos++] = '\t'; break;
                        case 'v' : ((int8_t*)result.mutableBytes)[pos++] = 0x0b; break;
                        case '\\': ((int8_t*)result.mutableBytes)[pos++] = '\\'; break;
                        case '\'': ((int8_t*)result.mutableBytes)[pos++] = '\''; break;
                        case '"' : ((int8_t*)result.mutableBytes)[pos++] = '\"'; break;
                            
                        case 'x': // hex escape
                        {
                            int32_t code = 0;
                            if (i + 1 < input.length && isHex([input characterAtIndex:(i + 1)])) {
                                ++i;
                                code = digitValue([input characterAtIndex:i]);
                            } else {
                                NSAssert(NO, @"Invalid escape sequence: '\\x' with no digits");
                                return nil;
                            }
                            if (i + 1 < input.length && isHex([input characterAtIndex:(i + 1)])) {
                                ++i;
                                code = code * 16 + digitValue([input characterAtIndex:i]);
                            }
                            ((int8_t*)result.mutableBytes)[pos++] = (int8_t)code;
                            break;
                        }
                            
                        default:
                            NSAssert(NO, @"Invalid escape sequence");
                            return nil;
                    }
                }
            } else {
                NSAssert(NO, @"Invalid escape sequence: '\\' at end of string");
                return nil;
            }
        } else {
            ((int8_t*)result.mutableBytes)[pos++] = (int8_t)c;
        }
    }
    
    [result setLength:pos];
    return result;
}


@end
