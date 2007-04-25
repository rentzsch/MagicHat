//
//	===========================================================================
//
//	Title:		SZMethodDescriptor.m
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

#import "SZMethodDescriptor.h"

#import "SZTypeDescriptor.h"

#import <Foundation/Foundation.h>

//	===========================================================================
//	Class "variable(s)"
//	---------------------------------------------------------------------------

static NSMapTable*	_map = NULL;

//	===========================================================================
//	Private method(s)
//	---------------------------------------------------------------------------

@interface SZMethodDescriptor(PrivateMethods)

+ (NSMapTable*) _map;
+ (void) _invalidateMap;

+ (SZMethodDescriptor*) _descriptorWithReference: (Method) aReference ofType: (SZMethodType) aType;

@end

@implementation SZMethodDescriptor(PrivateMethods)

+ (NSMapTable*) _map
{
	if ( _map == NULL )
	{
		_map = NSCreateMapTableWithZone(NSObjectMapKeyCallBacks, NSObjectMapValueCallBacks, 0, [(NSObject*)self zone]);
	}
	
	return _map;
}

+ (void) _invalidateMap
{
	if ( _map != NULL )
	{
		NSFreeMapTable(_map);
		
		_map = NULL;
	}
}

- (void) _setReference: (Method) aValue
{
	_reference = aValue;
}

- (id) _initWithReference: (Method) aReference ofType: (SZMethodType) aType
{
	[self init];
	
	[self _setReference: aReference];
	[self setType: aType];

	return self;
}

+ (NSString*) _uidForMethod: (Method) aMethod ofType: (SZMethodType) aType
{
	NSString*	anUID = [NSString stringWithFormat: @"%i.%s.%s", aType, sel_getName ( aMethod -> method_name ), aMethod -> method_types];
	
	return anUID;
}

+ (SZMethodDescriptor*) _descriptorWithReference: (Method) aReference ofType: (SZMethodType) aType
{
	if ( aReference != NULL )
	{
		NSString*		anUID = [self _uidForMethod: aReference ofType: aType];
		NSMapTable*		aMap = [self _map];
		SZMethodDescriptor*	aDescriptor = NSMapGet(aMap, anUID);
		
		if ( aDescriptor == nil )
		{
			aDescriptor = [[[self alloc] _initWithReference: aReference ofType: aType] autorelease];
			
			NSMapInsertKnownAbsent(aMap, anUID, aDescriptor);
		}
		
		return aDescriptor;
	}
	
	return nil;
}

@end

//	===========================================================================
//	Implementation
//	---------------------------------------------------------------------------

@implementation SZMethodDescriptor

+ (void) initialize
{
	[super initialize];
	
	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(bundleDidLoad:) name: NSBundleDidLoadNotification object: nil];
}

+ (void) bundleDidLoad: (NSNotification*) aNotification
{
	//NSLog(@"Did load bundle: %@", [aNotification object]);

	[self _invalidateMap];
}

+ (SZMethodDescriptor*) classDescriptorWithReference: (Method) aReference
{
	return [self _descriptorWithReference: aReference ofType: SZClassMethodType];
}

+ (SZMethodDescriptor*) instanceDescriptorWithReference: (Method) aReference
{
	return [self _descriptorWithReference: aReference ofType: SZInstanceMethodType];
}

- (Method) reference
{
	return _reference;
}

@end

//	===========================================================================
//	Primitive method(s)
//	---------------------------------------------------------------------------

@implementation SZMethodDescriptor(PrimitiveMethods)

- (SEL) selector
{
	return [self reference] -> method_name;
}

- (char*) signature
{
	return [self reference] -> method_types;
}

- (NSString*) signatureString
{
	char*	aSignature = [self signature];
	
	if ( aSignature != NULL )
	{
		return [NSString stringWithCString: aSignature];
	}
	
	return nil;
}

- (SZTypeDescriptor*) returnTypeDescriptor
{
	NSString*	aSignatureString = [self signatureString];
	unsigned int	count = method_getNumberOfArguments([self reference]);
	
	if ( ( aSignatureString != nil ) && ( count > 0 ) )
	{
		NSString*		aString = nil;
		int			offset;
		const char*		aType;
	
		method_getArgumentInfo([self reference], 0, &aType, &offset);
		
		if ( aType != NULL )
		{
			SZTypeDescriptor*	aDescriptor = nil;
			
			aString = [NSString stringWithCString: aType];

			aSignatureString = [aSignatureString substringToIndex: [aSignatureString length] - [aString length]];
			aSignatureString = [self normalizeSignatureType: aSignatureString];
	
			aDescriptor = [SZTypeDescriptor descriptorWithReference: aSignatureString];

			return aDescriptor;
		}
	}
	
	return nil;
}

- (NSArray*) parameterTypeDescriptors
{
	unsigned int	count = method_getNumberOfArguments([self reference]);
	
	if ( count > 2 )
	{
		NSString*	aString = nil;
		NSMutableArray*	anArray = [NSMutableArray arrayWithCapacity: count];
		unsigned int	index = count;
		
		while ( ( index-- ) > 2 )
		{
			NSString*		aTypeString = nil;
			int			offset;
			const char*		aType;
			SZTypeDescriptor*	aDescriptor = nil;
			
			method_getArgumentInfo([self reference], index, &aType, &offset);
			
			if ( ( aString != nil ) && ( [aString length] > 0 ) )
			{
				aTypeString = [NSString stringWithFormat: @"%s", aType];
				
				if ( [aTypeString length] > 0 )
				{
					aTypeString = [aTypeString substringToIndex: [aTypeString length] - [aString length]];
				}
			}
			
			aString = [NSString stringWithFormat: @"%s", aType];

			if ( aTypeString == nil )
			{
				aTypeString = aString;
			}
			
			aTypeString = [self normalizeSignatureType: aTypeString];

			aDescriptor = [SZTypeDescriptor descriptorWithReference: aTypeString];
			
			[anArray insertObject: aDescriptor atIndex: 0];
		}
		
		return anArray;
	}
	
	return nil;
}

@end

