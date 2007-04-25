//
//  SZReferenceDescriptor.m
//  MagicHat
//
//  Created by Raphael Szwarc on Mon Mar 24 2003.
//  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SZClassDescriptor.h"
#import "SZVariableDescriptor.h"
#import "SZTypeDescriptor.h"

#import "SZReferenceDescriptor.h"


//	===========================================================================
//	Class "variable(s)"
//	---------------------------------------------------------------------------

static NSMapTable*	_map = NULL;

//	===========================================================================
//	Private method(s)
//	---------------------------------------------------------------------------

@interface SZReferenceDescriptor(PrivateMethods)

+ (NSMapTable*) _map;
+ (void) _invalidateMap;

@end

@implementation SZReferenceDescriptor(PrivateMethods)

+ (NSMapTable*) _map
{
	if ( _map == NULL )
	{
		NSAutoreleasePool*	aPool = [[NSAutoreleasePool alloc] init];
		NSArray*		someClassNames = [SZClassDescriptor classNames];
		NSEnumerator*		aClassEnumerator = [someClassNames objectEnumerator];
		NSString*		aClassName = nil;
		
		//NSLog( @"SZReferenceDescriptor._map " );
	
		_map = NSCreateMapTableWithZone( NSObjectMapKeyCallBacks, NSOwnedPointerMapValueCallBacks, 0, [(NSObject*)self zone] );
		
		while ( ( aClassName = [aClassEnumerator nextObject] ) != nil )
		{
			SZClassDescriptor*	aClass = [SZClassDescriptor descriptorWithName: aClassName];
			NSArray*		someVariables = [aClass variableDescriptors];
		
			if ( someVariables != nil )
			{
				NSEnumerator*		aVariableEnumerator = [someVariables objectEnumerator];
				SZVariableDescriptor*	aVariable = nil;

				while ( ( aVariable = [aVariableEnumerator nextObject] ) != nil )
				{
					SZTypeDescriptor*	aType = [aVariable typeDescriptor];
					SZClassDescriptor*	aReference = [aType classDescriptor];
					
					if ( aReference != nil )
					{
						NSHashTable*	aTable = NSMapGet( _map, [aReference name] );
	
						if ( aTable == NULL )
						{
							aTable = NSCreateHashTableWithZone( NSObjectHashCallBacks, 0, [(NSObject*)self zone] );
		
							NSMapInsertKnownAbsent( _map, [aReference name], aTable );
						}
	
						NSHashInsertIfAbsent( aTable, aClassName );
					}
				}
			}
		}
	
		[aPool release];

		//NSLog( @"SZReferenceDescriptor._map done " );
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
}

@end

//	===========================================================================
//	Implementation method(s)
//	---------------------------------------------------------------------------

@implementation SZReferenceDescriptor

+ (void) initialize
{
	[super initialize];
	
	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(bundleDidLoad:) name: NSBundleDidLoadNotification object: nil];
}

+ (void) bundleDidLoad: (NSNotification*) aNotification
{
	//NSLog(@"%@ %@", NSStringFromSelector( _cmd ), [aNotification object]);

	[self _invalidateMap];
}

+ (NSArray*) classNamesWithReferenceName: (NSString*) aReferenceName
{
	if ( aReferenceName != nil )
	{
		NSMapTable*	aMap = [self _map];
		NSHashTable*	aTable = NSMapGet( aMap, aReferenceName );
		
		//NSLog( @"classNamesWithReferenceName:" );
	
		if ( aTable != NULL )
		{
			NSHashEnumerator	anEnumerator = NSEnumerateHashTable( aTable );
			unsigned int		count = NSCountHashTable( aTable );
			NSMutableArray*		anArray = [NSMutableArray arrayWithCapacity: count];
			NSString*		aValue = nil;
		
			while ( ( aValue = NSNextHashEnumeratorItem( &anEnumerator ) ) != NULL )
			{
				[anArray addObject: aValue];
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
