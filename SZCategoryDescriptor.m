//
//	===========================================================================
//
//	Title:		SZCategoryDescriptor.m
//	Description:	[Description]
//	Author:		Raphael Szwarc
//	Creation Date:	Tue 23-Nov-1999
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

#import <Foundation/Foundation.h>
#import <objc/objc-runtime.h>

#import "SZCategoryDescriptor.h"

#import "SZRuntime.h"
#import "SZRuntimeAdditions.h"
#import "SZProtocolDescriptor.h"
#import "SZMethodDescriptor.h"

//	===========================================================================
//	Constant(s)
//	---------------------------------------------------------------------------

//	===========================================================================
//	Class "variable(s)"
//	---------------------------------------------------------------------------

static NSMapTable*	_map = NULL;
static NSMapTable*	_categoryMap = NULL;

//	===========================================================================
//	Private method(s)
//	---------------------------------------------------------------------------

@interface SZCategoryDescriptor(PrivateMethods)

+ (NSMapTable*) _map;
+ (NSMapTable*) _categoryMap;
+ (void) _invalidateMap;
+ (SZCategoryDescriptor*) _descriptorWithReference: (Category) aReference;

@end

@implementation SZCategoryDescriptor(PrivateMethods)

+ (NSMapTable*) _map
{
	if ( _map == NULL )
	{
		_map = NSCreateMapTableWithZone(NSNonOwnedPointerMapKeyCallBacks, NSObjectMapValueCallBacks, 0, [(NSObject*)self zone]);
	}
	
	return _map;
}

+ (void) _invalidateMap
{
	if ( _map != NULL )
	{
		NSFreeMapTable( _map );
		
		_map = NULL;
	}
	
	if ( _categoryMap != NULL )
	{
		NSFreeMapTable( _categoryMap );
		
		_categoryMap = NULL;
	}
}

+ (NSMapTable*) _categoryMap
{
	if ( _categoryMap == NULL )
	{
		NSSet*		aSet = [SZRuntime categories];
		NSEnumerator*	anEnumerator = [aSet objectEnumerator];
		NSValue*	aValue = nil;
		
		//NSLog( @"%@ %d", NSStringFromSelector( _cmd ), [aSet count] );
		//NSLog( @"SZCategoryDescriptor._categoryMap" );
	
		_categoryMap = NSCreateMapTableWithZone( NSNonOwnedPointerMapKeyCallBacks, NSNonOwnedPointerMapValueCallBacks, 0, [(NSObject*)self zone] );

		while ( ( aValue = [anEnumerator nextObject] ) != nil )
		{
			Category	aCategory = (Category) [aValue pointerValue];
			char*		aClassName = aCategory -> class_name;
			NSHashTable*	aTable = NSMapGet( _categoryMap, aClassName );
			
			if ( aTable == NULL )
			{
				aTable = NSCreateHashTableWithZone( NSNonOwnedPointerHashCallBacks, 0, [(NSObject*)self zone] );

				NSMapInsertKnownAbsent( _categoryMap, aClassName, aTable );
			}

			NSHashInsertIfAbsent( aTable, aCategory );
		}

		//NSLog( @"SZCategoryDescriptor._categoryMap done" );
	}
	
	return _categoryMap;
}

- (void) _setReference: (Category) aValue
{
	_reference = aValue;
}

- (id) _initWithReference: (Category) aReference
{
	[self init];
	
	[self _setReference: aReference];

	return self;
}

+ (SZCategoryDescriptor*) _descriptorWithReference: (Category) aReference
{
	if ( aReference != NULL )
	{
		NSMapTable*		aMap = [self _map];
		SZCategoryDescriptor*	aDescriptor = NSMapGet( aMap, aReference );
		
		if ( aDescriptor == nil )
		{
			aDescriptor = [[[self alloc] _initWithReference: aReference] autorelease];

			NSMapInsertKnownAbsent( aMap, aReference, aDescriptor );
		}
		
		return aDescriptor;
	}
	
	return nil;
}

@end

//	===========================================================================
//	Implementation
//	---------------------------------------------------------------------------

@implementation SZCategoryDescriptor

+ (void) initialize
{
	[super initialize];

	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(bundleDidLoad:) name: NSBundleDidLoadNotification object: nil];
}

+ (void) bundleDidLoad: (NSNotification*) aNotification
{
	[self _invalidateMap];
}

+ (NSArray*) descriptorsForClass: (Class) aClass
{
	if ( aClass != NULL )
	{
		NSMapTable*	aCategoryMap = [self _categoryMap];
		NSHashTable*	aTable = NSMapGet( aCategoryMap, aClass -> name );
		
		if ( aTable != NULL )
		{
			NSHashEnumerator	anEnumerator = NSEnumerateHashTable( aTable );
			unsigned int		count = NSCountHashTable( aTable );
			NSMutableArray*		anArray = [NSMutableArray arrayWithCapacity: count];
			Category		aCategory = NULL;
			
			while ( ( aCategory = NSNextHashEnumeratorItem( &anEnumerator ) ) != NULL )
			{
				SZCategoryDescriptor*	aDescriptor = [self _descriptorWithReference: aCategory];
				
				[anArray addObject: aDescriptor];
			}
			
			if ( [anArray count] > 0 )
			{
				return [anArray sortedArrayUsingSelector: @selector(compare:)];
			}
		}
	}
	
	return nil;
}

- (Category) reference
{
	return _reference;
}

- (NSComparisonResult) compare: (SZCategoryDescriptor*) aDescriptor
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

@implementation SZCategoryDescriptor(DescriptionMethods)

- (NSString*) description
{
	return [self name];
}

- (NSString*) name
{
	char*	aClassName = [self reference] -> class_name;
	char*	aCategoryName = [self reference] -> category_name;
	
	return [NSString stringWithFormat: @"%s(%s)", aClassName, aCategoryName];
}

- (NSArray*) protocolDescriptors
{
	/*
	NSSet*	aSet = [SZRuntime protocolsForCategory: [self reference]];
	
	if ( aSet != nil )
	{
		NSMutableArray*	anArray = [NSMutableArray arrayWithCapacity: [aSet count]];
		NSEnumerator*	anEnumerator = [aSet objectEnumerator];
		Protocol*	aProtocol = nil;
		
		while ( ( aProtocol = [anEnumerator nextObject] ) != nil )
		{
			SZProtocolDescriptor*	aDescriptor = [SZProtocolDescriptor descriptorWithReference: aProtocol];
			
			[anArray addObject: aDescriptor];
		}
		
		if ( [anArray count] > 0 )
		{
			return [anArray sortedArrayUsingSelector: @selector(compare:)];
		}
	}
	*/
	
	return nil;
}

- (NSArray*) classMethodDescriptors
{
	NSSet*	aSet = [SZRuntime classMethodsForCategory: [self reference]];
	
	if ( aSet != nil )
	{
		NSMutableArray*	anArray = [NSMutableArray arrayWithCapacity: [aSet count]];
		NSEnumerator*	anEnumerator = [aSet objectEnumerator];
		NSValue*	aValue = nil;
		
		while ( ( aValue = [anEnumerator nextObject] ) != nil )
		{
			Method			aMethod = (Method) [aValue pointerValue];
			SZMethodDescriptor*	aDescriptor = [SZMethodDescriptor classDescriptorWithReference: aMethod];
			
			[anArray addObject: aDescriptor];
		}
		
		if ( [anArray count] > 0 )
		{
			return [anArray sortedArrayUsingSelector: @selector(compare:)];
		}
	}
	
	return nil;
}

- (NSArray*) instanceMethodDescriptors
{
	NSSet*	aSet = [SZRuntime instanceMethodsForCategory: [self reference]];
	
	if ( aSet != nil )
	{
		NSMutableArray*	anArray = [NSMutableArray arrayWithCapacity: [aSet count]];
		NSEnumerator*	anEnumerator = [aSet objectEnumerator];
		NSValue*	aValue = nil;
		
		while ( ( aValue = [anEnumerator nextObject] ) != nil )
		{
			Method			aMethod = (Method) [aValue pointerValue];
			SZMethodDescriptor*	aDescriptor = [SZMethodDescriptor instanceDescriptorWithReference: aMethod];
			
			[anArray addObject: aDescriptor];
		}
		
		if ( [anArray count] > 0 )
		{
			return [anArray sortedArrayUsingSelector: @selector(compare:)];
		}
	}
	
	return nil;
}

@end
