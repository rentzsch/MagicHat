//
//	===========================================================================
//
//	Title:		SZAbstractMethodDescriptor.h
//	Description:	[Description]
//	Author:		Raphael Szwarc
//	Creation Date:	Thu 11-Nov-1999
//
//	---------------------------------------------------------------------------
//

#import <Foundation/NSObject.h>

@class NSString;
@class NSArray;
@class SZTypeDescriptor;

typedef enum 
{
    SZClassMethodType = 1,
    SZInstanceMethodType = 2,
}
SZMethodType;

extern NSString* const SZMethodNameSeparator;

@interface SZAbstractMethodDescriptor : NSObject
{
	@private
	SZMethodType	_type;
}

- (SZMethodType) type;
- (void) setType: (SZMethodType) aValue;

- (NSComparisonResult) compare: (SZAbstractMethodDescriptor*) aDescriptor;

@end

@interface SZAbstractMethodDescriptor (PrimitiveMethods)

- (SEL) selector;
- (char*) signature;

- (NSString*) normalizeSignatureType: (NSString*) aSignature;


- (SZTypeDescriptor*) returnTypeDescriptor;
- (NSArray*) parameterTypeDescriptors;

@end

@interface SZAbstractMethodDescriptor (DescriptionMethods)

- (NSString*) prefix;
- (NSString*) name;

- (NSArray*) methodNameComponents;

@end
