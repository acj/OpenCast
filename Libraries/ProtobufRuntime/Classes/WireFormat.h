//
//  WireFormat.h
//  Protocol Buffers for Objective C
//
//  Copyright 2014 Ed Preston
//  Copyright 2010 Booyah Inc.
//  Copyright 2008 Cyrus Najmabadi
//


typedef NS_ENUM(NSUInteger, PBWireFormat) {
  PBWireFormatVarint = 0,
  PBWireFormatFixed64 = 1,
  PBWireFormatLengthDelimited = 2,
  PBWireFormatStartGroup = 3,
  PBWireFormatEndGroup = 4,
  PBWireFormatFixed32 = 5,

  PBWireFormatTagTypeBits = 3,
  PBWireFormatTagTypeMask = 7 /* = (1 << PBWireFormatTagTypeBits) - 1*/,

  PBWireFormatMessageSetItem = 1,
  PBWireFormatMessageSetTypeId = 2,
  PBWireFormatMessageSetMessage = 3
};


int32_t PBWireFormatMakeTag(int32_t fieldNumber, int32_t wireType);
int32_t PBWireFormatGetTagWireType(int32_t tag);
int32_t PBWireFormatGetTagFieldNumber(int32_t tag);

#define PBWireFormatMessageSetItemTag (PBWireFormatMakeTag(PBWireFormatMessageSetItem, PBWireFormatStartGroup))
#define PBWireFormatMessageSetItemEndTag (PBWireFormatMakeTag(PBWireFormatMessageSetItem, PBWireFormatEndGroup))
#define PBWireFormatMessageSetTypeIdTag (PBWireFormatMakeTag(PBWireFormatMessageSetTypeId, PBWireFormatVarint))
#define PBWireFormatMessageSetMessageTag (PBWireFormatMakeTag(PBWireFormatMessageSetMessage, PBWireFormatLengthDelimited))
