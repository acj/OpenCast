//
//  WireFormat.m
//  Protocol Buffers for Objective C
//
//  Copyright 2014 Ed Preston
//  Copyright 2010 Booyah Inc.
//  Copyright 2008 Cyrus Najmabadi
//

#import "WireFormat.h"

#import "Utilities.h"


int32_t PBWireFormatMakeTag(int32_t fieldNumber, int32_t wireType) {
  return (fieldNumber << PBWireFormatTagTypeBits) | wireType;
}

int32_t PBWireFormatGetTagWireType(int32_t tag) {
  return tag & PBWireFormatTagTypeMask;
}

int32_t PBWireFormatGetTagFieldNumber(int32_t tag) {
  return logicalRightShift32(tag, PBWireFormatTagTypeBits);
}
