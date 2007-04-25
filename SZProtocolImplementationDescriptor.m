//
//	===========================================================================
//
//	Title:		SZProtocolImplementationDescriptor.m
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

#import "SZProtocolImplementationDescriptor.h"

#import "SZRuntime.h"

#import <Foundation/Foundation.h>

#import <objc/objc-class.h>
#import <objc/Protocol.h>

//	===========================================================================
//	Class "variable(s)"
//	---------------------------------------------------------------------------

static NSMapTable*	_map = NULL;

//	===========================================================================
//	Private method(s)
//	---------------------------------------------------------------------------

@interface SZProtocolImplementationDescriptor(PrivateMethods)

+ (NSMapTable*) _map;
+ (void) _invalidateMap;

@end

@implementation SZProtocolImplementationDescriptor(PrivateMethods)

+ (NSMapTable*) _map
{
	if ( _map == NULL )
	{
		NSAutoreleasePool*	aPool = [[NSAutoreleasePool alloc] init];
		NSSet*			aClassSet = [SZRuntime classes];
		NSEnumerator*		aClassEnumerator = [aClassSet objectEnumerator];
		NSValue*		aClassValue = nil;
	
		//NSLog( @"SZProtocolImplementationDescriptor._classMap " );

		_map = NSCreateMapTableWithZone(NSObjectMapKeyCallBacks, NSNonOwnedPointerMapValueCallBacks, 0, [(NSObject*)self zone]);
		
		while ( ( aClassValue = [aClassEnumerator nextObject] ) != nil )
		{
			Class		aClass = (Class) [aClassValue pointerValue];
			const char*	aClassName = aClass -> name;
			NSSet*		aProtocolSet = [SZRuntime protocolsForClass: aClass];
		
			if ( aProtocolSet != nil )
			{
				NSEnumerator*	aProtocolEnumerator = [aProtocolSet objectEnumerator];
				Protocol*	aProtocol = nil;

				while ( ( aProtocol = [aProtocolEnumerator nextObject] ) != nil )
				{
					const char*	aName = [aProtocol name];
					
					if ( aName != NULL )
					{
						NSString*	aProtocolName = [NSString stringWithCString: aName];
						NSHashTable*	aTable = NSMapGet( _map, aProtocolName );
	
						if ( aTable == NULL )
						{
							aTable = NSCreateHashTableWithZone( NSNonOwnedPointerHashCallBacks, 0, [(NSObject*)self zone] );
		
							NSMapInsertKnownAbsent( _map, aProtocolName, aTable );
						}
	
						NSHashInsertIfAbsent( aTable, aClassName );
					}
				}
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

@implementation SZProtocolImplementationDescriptor

+ (void) initialize
{
	[super initialize];
	
	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(bundleDidLoad:) name: NSBundleDidLoadNotification object: nil];
}

+ (void) bundleDidLoad: (NSNotification*) aNotification
{
	[self _invalidateMap];
}

+ (NSArray*) classNamesWithProtocolName: (NSString*) aProtocolName
{
	if ( aProtocolName != nil )
	{
		NSMapTable*	aMap = [self _map];
		NSHashTable*	aTable = NSMapGet(aMap, aProtocolName);
		
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
	
	return nil;
}

@end
