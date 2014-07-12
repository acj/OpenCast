//
// cast_channel.pb.h
// 
// Generated by the objc protocol buffer compiler plugin.  DO NOT EDIT!
// source: cast_channel.proto
//

#import <Foundation/Foundation.h>

#import <ProtocolModels/ProtocolModels.h>

// @@protoc_insertion_point(imports)

@class AuthChallenge;
@class AuthChallenge_Builder;
@class AuthError;
@class AuthError_Builder;
@class AuthResponse;
@class AuthResponse_Builder;
@class CastMessage;
@class CastMessage_Builder;
@class DeviceAuthMessage;
@class DeviceAuthMessage_Builder;

#ifndef __has_feature
  #define __has_feature(x) 0 // Compatibility with non-clang compilers.
#endif // __has_feature

#ifndef NS_RETURNS_NOT_RETAINED
  #if __has_feature(attribute_ns_returns_not_retained)
    #define NS_RETURNS_NOT_RETAINED __attribute__((ns_returns_not_retained))
  #else
    #define NS_RETURNS_NOT_RETAINED
  #endif
#endif

typedef NS_ENUM(NSInteger, CastMessage_ProtocolVersion) {
  CastMessage_ProtocolVersionCASTV210 = 0,
};

BOOL CastMessage_ProtocolVersionIsValidValue(CastMessage_ProtocolVersion value);

typedef NS_ENUM(NSInteger, CastMessage_PayloadType) {
  CastMessage_PayloadTypeSTRING = 0,
  CastMessage_PayloadTypeBINARY = 1,
};

BOOL CastMessage_PayloadTypeIsValidValue(CastMessage_PayloadType value);

typedef NS_ENUM(NSInteger, AuthError_ErrorType) {
  AuthError_ErrorTypeINTERNALERROR = 0,
  AuthError_ErrorTypeNOTLS = 1,
};

BOOL AuthError_ErrorTypeIsValidValue(AuthError_ErrorType value);


@interface CastChannelRoot : NSObject {
}
+ (PBExtensionRegistry*) extensionRegistry;
+ (void) registerAllExtensions:(PBMutableExtensionRegistry*)registry;
@end


#pragma mark - CastMessage

@interface CastMessage : PBGeneratedMessage

@property (readonly) CastMessage_ProtocolVersion protocolVersion;
@property (readonly, strong) NSString * sourceId;
@property (readonly, strong) NSString * destinationId;
@property (readonly, strong) NSString * namespace;
@property (readonly) CastMessage_PayloadType payloadType;
@property (readonly, strong) NSString * payloadUtf8;
@property (readonly, strong) NSData * payloadBinary;

- (BOOL)hasProtocolVersion;
- (BOOL)hasSourceId;
- (BOOL)hasDestinationId;
- (BOOL)hasNamespace;
- (BOOL)hasPayloadType;
- (BOOL)hasPayloadUtf8;
- (BOOL)hasPayloadBinary;


- (CastMessage_Builder*)builder;
+ (CastMessage_Builder*)builder;
+ (CastMessage_Builder*)builderWithPrototype:(CastMessage*)prototype;
- (CastMessage_Builder*)toBuilder;

@end


@interface CastMessage_Builder : PBGeneratedMessage_Builder

- (CastMessage*)defaultMessageInstance;

- (CastMessage*)build;
- (CastMessage*)buildPartial;

- (instancetype)mergeFrom:(CastMessage*)other;

- (BOOL)hasProtocolVersion;
- (CastMessage_ProtocolVersion)protocolVersion;
- (instancetype)setProtocolVersion:(CastMessage_ProtocolVersion)value;
- (instancetype)clearProtocolVersion;

- (BOOL)hasSourceId;
- (NSString *)sourceId;
- (instancetype)setSourceId:(NSString *) value;
- (instancetype)clearSourceId;

- (BOOL)hasDestinationId;
- (NSString *)destinationId;
- (instancetype)setDestinationId:(NSString *) value;
- (instancetype)clearDestinationId;

- (BOOL)hasNamespace;
- (NSString *)namespace;
- (instancetype)setNamespace:(NSString *) value;
- (instancetype)clearNamespace;

- (BOOL)hasPayloadType;
- (CastMessage_PayloadType)payloadType;
- (instancetype)setPayloadType:(CastMessage_PayloadType)value;
- (instancetype)clearPayloadType;

- (BOOL)hasPayloadUtf8;
- (NSString *)payloadUtf8;
- (instancetype)setPayloadUtf8:(NSString *) value;
- (instancetype)clearPayloadUtf8;

- (BOOL)hasPayloadBinary;
- (NSData *)payloadBinary;
- (instancetype)setPayloadBinary:(NSData *) value;
- (instancetype)clearPayloadBinary;

@end


#pragma mark - AuthChallenge

@interface AuthChallenge : PBGeneratedMessage




- (AuthChallenge_Builder*)builder;
+ (AuthChallenge_Builder*)builder;
+ (AuthChallenge_Builder*)builderWithPrototype:(AuthChallenge*)prototype;
- (AuthChallenge_Builder*)toBuilder;

@end


@interface AuthChallenge_Builder : PBGeneratedMessage_Builder

- (AuthChallenge*)defaultMessageInstance;

- (AuthChallenge*)build;
- (AuthChallenge*)buildPartial;

- (instancetype)mergeFrom:(AuthChallenge*)other;

@end


#pragma mark - AuthResponse

@interface AuthResponse : PBGeneratedMessage

@property (readonly, strong) NSData * signature;
@property (readonly, strong) NSData * clientAuthCertificate;

- (BOOL)hasSignature;
- (BOOL)hasClientAuthCertificate;


- (AuthResponse_Builder*)builder;
+ (AuthResponse_Builder*)builder;
+ (AuthResponse_Builder*)builderWithPrototype:(AuthResponse*)prototype;
- (AuthResponse_Builder*)toBuilder;

@end


@interface AuthResponse_Builder : PBGeneratedMessage_Builder

- (AuthResponse*)defaultMessageInstance;

- (AuthResponse*)build;
- (AuthResponse*)buildPartial;

- (instancetype)mergeFrom:(AuthResponse*)other;

- (BOOL)hasSignature;
- (NSData *)signature;
- (instancetype)setSignature:(NSData *) value;
- (instancetype)clearSignature;

- (BOOL)hasClientAuthCertificate;
- (NSData *)clientAuthCertificate;
- (instancetype)setClientAuthCertificate:(NSData *) value;
- (instancetype)clearClientAuthCertificate;

@end


#pragma mark - AuthError

@interface AuthError : PBGeneratedMessage

@property (readonly) AuthError_ErrorType errorType;

- (BOOL)hasErrorType;


- (AuthError_Builder*)builder;
+ (AuthError_Builder*)builder;
+ (AuthError_Builder*)builderWithPrototype:(AuthError*)prototype;
- (AuthError_Builder*)toBuilder;

@end


@interface AuthError_Builder : PBGeneratedMessage_Builder

- (AuthError*)defaultMessageInstance;

- (AuthError*)build;
- (AuthError*)buildPartial;

- (instancetype)mergeFrom:(AuthError*)other;

- (BOOL)hasErrorType;
- (AuthError_ErrorType)errorType;
- (instancetype)setErrorType:(AuthError_ErrorType)value;
- (instancetype)clearErrorType;

@end


#pragma mark - DeviceAuthMessage

@interface DeviceAuthMessage : PBGeneratedMessage

@property (readonly, strong)  AuthChallenge* challenge;
@property (readonly, strong)  AuthResponse* response;
@property (readonly, strong)  AuthError* error;

- (BOOL)hasChallenge;
- (BOOL)hasResponse;
- (BOOL)hasError;


- (DeviceAuthMessage_Builder*)builder;
+ (DeviceAuthMessage_Builder*)builder;
+ (DeviceAuthMessage_Builder*)builderWithPrototype:(DeviceAuthMessage*)prototype;
- (DeviceAuthMessage_Builder*)toBuilder;

@end


@interface DeviceAuthMessage_Builder : PBGeneratedMessage_Builder

- (DeviceAuthMessage*)defaultMessageInstance;

- (DeviceAuthMessage*)build;
- (DeviceAuthMessage*)buildPartial;

- (instancetype)mergeFrom:(DeviceAuthMessage*)other;

- (BOOL)hasChallenge;
- (AuthChallenge*)challenge;
- (instancetype)setChallenge:(AuthChallenge*)value;
- (instancetype)setChallengeBuilder:(AuthChallenge_Builder*)builderForValue;
- (instancetype)mergeChallenge:(AuthChallenge*)value;
- (instancetype)clearChallenge;

- (BOOL)hasResponse;
- (AuthResponse*)response;
- (instancetype)setResponse:(AuthResponse*)value;
- (instancetype)setResponseBuilder:(AuthResponse_Builder*)builderForValue;
- (instancetype)mergeResponse:(AuthResponse*)value;
- (instancetype)clearResponse;

- (BOOL)hasError;
- (AuthError*)error;
- (instancetype)setError:(AuthError*)value;
- (instancetype)setErrorBuilder:(AuthError_Builder*)builderForValue;
- (instancetype)mergeError:(AuthError*)value;
- (instancetype)clearError;

@end


// @@protoc_insertion_point(global_scope)