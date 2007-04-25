//
//	===========================================================================
//
//	Title:		SZClassHierarchyDescriptor.m
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

#import "SZClassHierarchyDescriptor.h"

#import "SZRuntime.h"

#import <Foundation/Foundation.h>

#import <objc/objc-class.h>
#import <objc/objc-runtime.h>

//	===========================================================================
//	Constant(s)
//	---------------------------------------------------------------------------

static const char*	_RootClass = "[root class]";

//	===========================================================================
//	Class "variable(s)"
//	---------------------------------------------------------------------------

static NSMapTable*	_map = NULL;

//	===========================================================================
//	Private method(s)
//	---------------------------------------------------------------------------

@interface SZClassHierarchyDescriptor(PrivateMethods)

+ (NSMapTable*) _map;
+ (void) _invalidateMap;

@end

@implementation SZClassHierarchyDescriptor(PrivateMethods)

+ (NSMapTable*) _map
{
	if ( _map == NULL )
	{
		NSAutoreleasePool*	aPool = [[NSAutoreleasePool alloc] init];
		NSSet*			aClassSet = [SZRuntime classes];
		NSEnumerator*		anEnumerator = [aClassSet objectEnumerator];
		NSValue*		aValue = nil;
	
		//NSLog( @"SZClassHierarchyDescriptor._classMap " );

		_map = NSCreateMapTableWithZone(NSNonOwnedPointerMapKeyCallBacks, NSNonOwnedPointerMapValueCallBacks, 0, [(NSObject*)self zone]);
		
		while ( ( aValue = [anEnumerator nextObject] ) != nil )
		{
			Class		aClass = (Class) [aValue pointerValue];
			const char*	aClassName = aClass -> name;
			Class		aSuperClass = aClass -> super_class;
			const char*	aSuperClassName = _RootClass;
		
			if ( aSuperClass != NULL )
			{
				aSuperClassName = aSuperClass -> name;
			}

			if ( aSuperClassName != NULL )
			{
				NSHashTable*	aTable = NSMapGet(_map, aSuperClassName);
	
				if ( aTable == NULL )
				{
					aTable = NSCreateHashTableWithZone(NSNonOwnedPointerHashCallBacks, 0, [(NSObject*)self zone]);
		
					NSMapInsertKnownAbsent(_map, aSuperClassName, aTable);
				}
	
				NSHashInsertIfAbsent( aTable, aClassName );
			}
		}
	
		[aPool release];
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

@end

//	===========================================================================
//	Implementation
//	---------------------------------------------------------------------------

@implementation SZClassHierarchyDescriptor

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

+ (NSArray*) classNamesWithSuperClassName: (NSString*) aClassName
{
	if ( aClassName != nil )
	{
		Class		aClass = objc_lookUpClass([aClassName cString]);
		
		if ( aClass != NULL )
		{
			NSMapTable*	aMap = [self _map];
			NSHashTable*	aTable = NSMapGet(aMap, aClass -> name);
		
			if ( aTable != NULL )
			{
				NSHashEnumerator	anEnumerator = NSEnumerateHashTable(aTable);
				unsigned int		count = NSCountHashTable(aTable);
				NSMutableArray*		anArray = [NSMutableArray arrayWithCapacity: count];
				const char*		aValue = NULL;
			
				while ( ( aValue = NSNextHashEnumeratorItem( &anEnumerator ) ) != NULL )
				{
					NSString*	aString = [NSString stringWithCString: aValue];
				
					[anArray addObject: aString];
				}
			
				if ( [anArray count] > 0 )
				{
					return [anArray sortedArrayUsingSelector: @selector(compare:)];
				}
			}
		}
	}
	
	return nil;
}

+ (NSArray*) rootClassNames
{
	NSMapTable*	aMap = [self _map];
	NSHashTable*	aTable = NSMapGet(aMap, _RootClass);
		
	if ( aTable != NULL )
	{
		NSHashEnumerator	anEnumerator = NSEnumerateHashTable(aTable);
		unsigned int		count = NSCountHashTable(aTable);
		NSMutableArray*		anArray = [NSMutableArray arrayWithCapacity: count];
		const char*		aValue = NULL;
		
		while ( ( aValue = NSNextHashEnumeratorItem( &anEnumerator ) ) != NULL )
		{
			NSString*	aString = [NSString stringWithCString: aValue];
				
			[anArray addObject: aString];
		}
			
		if ( [anArray count] > 0 )
		{
			return [anArray sortedArrayUsingSelector: @selector(compare:)];
		}
	}
	
	return nil;
}

@end
