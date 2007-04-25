//
//	===========================================================================
//
//	Title:		SZVariableDescriptor.m
//	Description:	[Description]
//	Author:		Raphael Szwarc
//	Creation Date:	Wed 03-Nov-1999
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

#import "SZVariableDescriptor.h"

#import "SZTypeDescriptor.h"

#import <Foundation/Foundation.h>

//	===========================================================================
//	"Class" variable(s)
//	---------------------------------------------------------------------------

static NSMapTable*	_map = NULL;

//	===========================================================================
//	Private method(s)
//	---------------------------------------------------------------------------

@interface SZVariableDescriptor (PrivateMethods)

+ (NSMapTable*) _map;

@end

@implementation SZVariableDescriptor (PrivateMethods)

+ (NSMapTable*) _map
{
	if ( _map == NULL )
	{
		_map = NSCreateMapTableWithZone(NSNonOwnedPointerMapKeyCallBacks, NSObjectMapValueCallBacks, 0, [(NSObject*)self zone]);
	}
	
	return _map;
}

- (void) _setReference: (Ivar) aValue
{
	_reference = aValue;
}

- (id) _initWithReference: (Ivar) aReference
{
	[self init];
	
	[self _setReference: aReference];

	return self;
}

@end

//	===========================================================================
//	Implementation
//	---------------------------------------------------------------------------

@implementation SZVariableDescriptor

+ (SZVariableDescriptor*) descriptorWithReference: (Ivar) aReference
{
	if ( aReference != NULL )
	{
		NSMapTable*		aMap = [self _map];
		SZVariableDescriptor*	aDescriptor = NSMapGet(aMap, aReference);
		
		if ( aDescriptor == nil )
		{
			aDescriptor = [[[self alloc] _initWithReference: aReference] autorelease];
			
			NSMapInsertKnownAbsent(aMap, aReference, aDescriptor);
		}
		
		return aDescriptor;
	}
	
	return nil;
}

- (Ivar) reference
{
	return _reference;
}

- (NSComparisonResult) compare: (SZVariableDescriptor*) aDescriptor
{
	if ( aDescriptor != nil )
	{
		return [[self description] compare: [aDescriptor description]];
	}
	
	return NSOrderedDescending;
}

@end

//	===========================================================================
//	Description method(s)
//	---------------------------------------------------------------------------

@implementation SZVariableDescriptor(DescriptionMethods)

- (NSString*) description
{
	return [self name];
}

- (NSString*) name
{
	char*	aName = [self reference] -> ivar_name;
	
	if ( aName != NULL )
	{
		return [NSString stringWithCString: aName];
	}
	
	return nil;
}

- (SZTypeDescriptor*) typeDescriptor
{
	char*	aType = [self reference] -> ivar_type;
	
	if ( aType != NULL )
	{
		NSString*	aTypeReference = [NSString stringWithCString: aType]; 

		return [SZTypeDescriptor descriptorWithReference: aTypeReference];
	}
	
	return nil;
}

@end
