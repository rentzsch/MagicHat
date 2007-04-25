//
//	===========================================================================
//
//	Title:		SZTypeDescriptor.m
//	Description:	[Description]
//	Author:		Raphael Szwarc
//	Creation Date:	Tue 09-Nov-1999
//	Legal:		Copyright (C) 1999 Raphael Szwarc. 
//
//	This program is free software; you can redistribute it and/or modify
//	it under the terms of the GNU General Public License as published by
//	the Free Software Foundation; either version 2 of the License, or
//	(at your option) any later version.
//
//	This program is distributed in the hope that it will be useful,
//	but WITHOUT ANY WARRANTY; without even the implied warranty of
//	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//	GNU General Public License for more details.
//
//	---------------------------------------------------------------------------
//

//	===========================================================================
//	Import(s)
//	---------------------------------------------------------------------------

#import "SZTypeDescriptor.h"

#import "SZClassDescriptor.h"

#import <Foundation/Foundation.h>

#import <objc/objc-class.h>

//	===========================================================================
//	"Class" variable(s)
//	---------------------------------------------------------------------------

static NSMapTable*	_map = NULL;
static NSMapTable*	_typeMap = NULL;
static NSMapTable*	_structureMap = NULL;

static NSCharacterSet*	_encodingCharacterSet = nil;

//	===========================================================================
//	Private method(s)
//	---------------------------------------------------------------------------

@interface SZTypeDescriptor(PrivateMethods)

+ (NSMapTable*) _map;
+ (NSString*) _normalizeReference: (NSString*) aReference;

@end

@implementation SZTypeDescriptor(PrivateMethods)

+ (NSMapTable*) _map
{
	if ( _map == NULL )
	{
		_map = NSCreateMapTableWithZone(NSObjectMapKeyCallBacks, NSObjectMapValueCallBacks, 0, [(NSObject*)self zone]);
	}
	
	return _map;
}

+ (NSMapTable*) _typeMap
{
	if ( _typeMap == NULL )
	{
		_typeMap = NSCreateMapTableWithZone(NSIntMapKeyCallBacks, NSObjectMapValueCallBacks, 0, [(NSObject*)self zone]);

		NSMapInsertKnownAbsent(_typeMap, (void*) _C_ID, @"id");
		NSMapInsertKnownAbsent(_typeMap, (void*) _C_CLASS, @"Class");
		NSMapInsertKnownAbsent(_typeMap, (void*) _C_SEL, @"SEL");
		NSMapInsertKnownAbsent(_typeMap, (void*) _C_CHR, @"char");
		NSMapInsertKnownAbsent(_typeMap, (void*) _C_UCHR, @"unsigned char");
		NSMapInsertKnownAbsent(_typeMap, (void*) _C_SHT, @"short");
		NSMapInsertKnownAbsent(_typeMap, (void*) _C_USHT, @"unsigned short");
		NSMapInsertKnownAbsent(_typeMap, (void*) _C_INT, @"int");
		NSMapInsertKnownAbsent(_typeMap, (void*) _C_UINT, @"unsigned int");
		NSMapInsertKnownAbsent(_typeMap, (void*) _C_LNG, @"long");
		NSMapInsertKnownAbsent(_typeMap, (void*) _C_ULNG, @"unsigned long");
		NSMapInsertKnownAbsent(_typeMap, (void*) _C_FLT, @"float");
		NSMapInsertKnownAbsent(_typeMap, (void*) _C_DBL, @"double");
		NSMapInsertKnownAbsent(_typeMap, (void*) _C_BFLD, @"BOOL");
		NSMapInsertKnownAbsent(_typeMap, (void*) _C_VOID, @"void");
		NSMapInsertKnownAbsent(_typeMap, (void*) _C_UNDEF, @"?");
		NSMapInsertKnownAbsent(_typeMap, (void*) _C_PTR, @"*");
		NSMapInsertKnownAbsent(_typeMap, (void*) _C_CHARPTR, @"char*");
		NSMapInsertKnownAbsent(_typeMap, (void*) _C_ARY_B, @"[?]");
		NSMapInsertKnownAbsent(_typeMap, (void*) _C_ARY_E, @"]");
		NSMapInsertKnownAbsent(_typeMap, (void*) _C_UNION_B, @"union (?)");
		NSMapInsertKnownAbsent(_typeMap, (void*) _C_UNION_E, @")");
		NSMapInsertKnownAbsent(_typeMap, (void*) _C_STRUCT_B, @"struct {?}");
		NSMapInsertKnownAbsent(_typeMap, (void*) _C_STRUCT_E, @"}");
	}
	
	return _typeMap;
}

+ (NSString*) _normalizeReference: (NSString*) aReference
{
	NSMutableString*	aString = [NSMutableString string];
	NSCharacterSet*		aSet = [[self class] encodingCharacterSet];
	unsigned int		count = [aReference length];
	unsigned int		index = 0;
	BOOL			isOpen = NO;

	for ( index = 0; index < count; index++ )
	{
		char	aChar = [aReference characterAtIndex: index];
		
		if ( aChar  == '"' )
		{
			isOpen = !isOpen;
		}
		
		if ( ( isOpen == NO ) && ( [aSet characterIsMember: aChar] == YES ) )
		{
			[aString appendFormat: @"%c", aChar];
		}
	}
			
	return aString;
}

+ (NSMapTable*) _structureMap
{
	if ( _structureMap == NULL )
	{
		_structureMap = NSCreateMapTableWithZone(NSObjectMapKeyCallBacks, NSObjectMapValueCallBacks, 0, [(NSObject*)self zone]);

		NSMapInsertKnownAbsent(_structureMap, [NSString stringWithCString: @encode(id*)], @"id*");
		
		NSMapInsertKnownAbsent(_structureMap, [NSString stringWithCString: @encode(char*)], @"char*");
		
		NSMapInsertKnownAbsent(_structureMap, [NSString stringWithCString: @encode(short*)], @"short*");
		NSMapInsertKnownAbsent(_structureMap, [NSString stringWithCString: @encode(unsigned short*)], @"unsigned short*");
		
		NSMapInsertKnownAbsent(_structureMap, [NSString stringWithCString: @encode(int*)], @"int*");
		NSMapInsertKnownAbsent(_structureMap, [NSString stringWithCString: @encode(unsigned int*)], @"unsigned int*");
		
		NSMapInsertKnownAbsent(_structureMap, [NSString stringWithCString: @encode(long*)], @"long*");
		NSMapInsertKnownAbsent(_structureMap, [NSString stringWithCString: @encode(unsigned long*)], @"unsigned long*");

		NSMapInsertKnownAbsent(_structureMap, [NSString stringWithCString: @encode(float*)], @"float*");
		
		NSMapInsertKnownAbsent(_structureMap, [NSString stringWithCString: @encode(void*)], @"void*");
		NSMapInsertKnownAbsent(_structureMap, [NSString stringWithCString: @encode(void**)], @"void**");
		
		NSMapInsertKnownAbsent(_structureMap, [self _normalizeReference: [NSString stringWithCString: @encode(NSRange)]], @"NSRange");
		NSMapInsertKnownAbsent(_structureMap, [self _normalizeReference: [NSString stringWithCString: @encode(NSPoint)]], @"NSPoint");
		NSMapInsertKnownAbsent(_structureMap, [self _normalizeReference: [NSString stringWithCString: @encode(NSSize)]], @"NSSize");
		NSMapInsertKnownAbsent(_structureMap, [self _normalizeReference: [NSString stringWithCString: @encode(NSRect)]], @"NSRect");
		
		NSMapInsertKnownAbsent(_structureMap, @"^{objc_method}", @"Method");
		NSMapInsertKnownAbsent(_structureMap, @"^{objc_ivar}", @"Ivar");
		NSMapInsertKnownAbsent(_structureMap, @"^{?=}", @"void*");
		NSMapInsertKnownAbsent(_structureMap, @"^?", @"void*");
	}
	
	return _structureMap;
}

- (void) _setReference: (NSString*) aValue
{
	[_reference autorelease];
	_reference = [aValue retain];
}

- (id) _initWithReference: (NSString*) aReference
{
	[self init];
	
	[self _setReference: aReference];

	return self;
}

@end

//	===========================================================================
//	Implementation
//	---------------------------------------------------------------------------

@implementation SZTypeDescriptor

+ (NSCharacterSet*) encodingCharacterSet
{
	if ( _encodingCharacterSet == nil )
	{
		NSString*	aString = [NSString stringWithFormat: @"%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c=", _C_ID, _C_CLASS, _C_SEL, _C_CHR, _C_UCHR,  _C_SHT, _C_USHT, _C_INT, _C_UINT, _C_LNG, _C_ULNG, _C_FLT, _C_DBL, _C_BFLD, _C_VOID, _C_UNDEF, _C_PTR, _C_CHARPTR, _C_ARY_B, _C_ARY_E, _C_UNION_B, _C_UNION_E, _C_STRUCT_B, _C_STRUCT_E];
		
		_encodingCharacterSet = [[NSCharacterSet characterSetWithCharactersInString: aString] retain];
	}
	
	return _encodingCharacterSet;
}

+ (SZTypeDescriptor*) descriptorWithReference: (NSString*) aReference
{
	if ( ( aReference == nil ) || ( [aReference length] == 0 ) )
	{
		aReference = [NSString stringWithFormat: @"%c", _C_UNDEF];
	}

	if ( ( aReference != nil ) && ( [aReference length] > 0 ) )
	{
		NSMapTable*		aMap = [self _map];
		SZTypeDescriptor*	aDescriptor = NSMapGet(aMap, aReference);
		
		if ( aDescriptor == nil )
		{
			aDescriptor = [[[self alloc] _initWithReference: aReference] autorelease];
			
			NSMapInsertKnownAbsent(aMap, aReference, aDescriptor);
		}
		
		return aDescriptor;
	}

	return nil;
}

- (NSString*) reference
{
	return _reference;
}

- (void) dealloc
{
	[_reference release];
	
	[super dealloc];
}

@end

//	===========================================================================
//	Description method(s)
//	---------------------------------------------------------------------------

@implementation SZTypeDescriptor(DescriptionMethods)

- (NSString*) description
{
	return [self name];
}

- (NSString*) _normalizedReferenceString
{
	return [[self class] _normalizeReference: [self reference]];
}

- (NSString*) name
{
	NSMapTable*	aTypeMap = [[self class] _typeMap];
	NSString*	aType = nil;
	NSString*	aReference = [self reference];
	unsigned int	count = [aReference length];
	
	if ( count > 1 )
	{
		aType = NSMapGet( [[self class] _structureMap], [self _normalizedReferenceString] );
	}
	
	if ( aType == nil )
	{
		aType = NSMapGet( aTypeMap, (void*)(int)[aReference characterAtIndex: 0]) ;
	}

	if ( aType == nil )
	{
		//NSLog(@"(Info) Unknown type '%@'. Defaulting to '?'.", aReference);

		aType = @"?";
	}
	else
	if ( [aType isEqualToString: @"*"] == YES )
	{
		aType = @"void*";
	}
	
	return aType;
}

- (BOOL) _isStaticID
{
	NSString*	aReference = [self reference];

	if ( ( [aReference characterAtIndex: 0] == _C_ID ) && ( [aReference length] > 1 ) )
	{
		return YES;
	}
	
	return NO;
}

- (NSString*) _className
{
	NSMutableString*	aReferenceString = [NSMutableString stringWithString: [self reference]];
	NSRange			aRange = [aReferenceString rangeOfString: @"@\""];
		
	[aReferenceString deleteCharactersInRange: aRange];
	aRange = [aReferenceString rangeOfString: @"\""];
	[aReferenceString deleteCharactersInRange: aRange];
	
	return aReferenceString;
}

- (SZClassDescriptor*) classDescriptor
{
	if ( [self _isStaticID] == YES )
	{
		SZClassDescriptor*	aDescriptor = [SZClassDescriptor descriptorWithName: [self _className]];
		
		return aDescriptor;
	}
	
	return nil;
}

@end
