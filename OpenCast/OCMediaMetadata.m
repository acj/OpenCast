//
//  OCMediaMetadata.m
//  OpenCast

#import "OCMediaMetadata.h"

@implementation OCMediaMetadata

@synthesize metadataType=_metadataType; // FIXME

- (id)initWithMetadataType:(OCMediaMetadataType)metadataType {
    // TODO
    _metadataType = metadataType;
    return self;
}

- (id)init {
    // TODO
    return self;
}

- (OCMediaMetadataType)metadataType {
    // TODO
    return self.metadataType;
}

- (NSArray *)images {
    // TODO
    return nil;
}

- (void)removeAllMediaImages {
    // TODO
}

- (void)addImage:(OCImage *)image {
    // TODO
}

- (BOOL)containsKey:(NSString *)key {
    // TODO
    return NO;
}

- (NSArray *)allKeys {
    // TODO
    return nil;
}

- (id)objectForKey:(NSString *)key {
    // TODO
    return nil;
}

- (void)setString:(NSString *)value forKey:(NSString *)key {
    // TODO
}

- (NSString *)stringForKey:(NSString *)key {
    // TODO
    return nil;
}

- (void)setInteger:(NSInteger)value forKey:(NSString *)key {
    // TODO
}

- (NSInteger)integerForKey:(NSString *)key {
    // TODO
    return 0;
}

- (NSInteger)integerForKey:(NSString *)key defaultValue:(NSInteger)defaultValue {
    // TODO
    return 0;
}

- (void)setDouble:(double)value forKey:(NSString *)key {
    // TODO
}

- (double)doubleForKey:(NSString *)key {
    // TODO
    return 0.f;
}

- (double)doubleForKey:(NSString *)key defaultValue:(double)defaultValue {
    // TODO
    return 0;
}

- (void)setDate:(NSDate *)date forKey:(NSString *)key {
    // TODO
}

- (NSDate *)dateForKey:(NSString *)key {
    // TODO
    return nil;
}

- (NSString *)dateAsStringForKey:(NSString *)key {
    // TODO
    return nil;
}

/** @cond INTERNAL */

- (id)initWithJSONObject:(id)JSONObject {
    // TODO
    return nil;
}

+ (instancetype)metadataWithJSONObject:(id)JSONObject {
    // TODO
    return nil;
}

- (id)JSONObject {
    // TODO
    return nil;
}

@end
