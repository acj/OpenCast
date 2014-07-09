//
//  TextFormat.h
//  Protocol Buffers for Objective C
//
//  Copyright 2014 Ed Preston
//  Copyright 2010 Booyah Inc.
//  Copyright 2008 Cyrus Najmabadi
//

@interface PBTextFormat : NSObject

+ (int32_t)parseInt32:(NSString*)text;
+ (int32_t)parseUInt32:(NSString*)text;
+ (int64_t)parseInt64:(NSString*)text;
+ (int64_t)parseUInt64:(NSString*)text;

+ (NSData*)unescapeBytes:(NSString*)input;

@end
