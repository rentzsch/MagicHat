//
//	===========================================================================
//
//	Title:		SZProtocolDescriptor.m
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

#import "SZProtocolDescriptor.h"

#import "SZRuntime.h"
#import "SZProtocolImplementationDescriptor.h"
#import "SZMethodDescriptor.h"
#import "SZClassDescriptor.h"
#import "SZFrameworkDescriptor.h"

#import <Foundation/Foundation.h>

#import <objc/Protocol.h>

//	===========================================================================
//	Constant(s)
//	---------------------------------------------------------------------------

NSString* const	SZProtocolNamePrefix = @"<";
NSString* const	SZProtocolNameSuffix = @">";

static NSString* const	_DefaultHeaderPath = @"Headers";
static NSString* const	_DefaultHeaderPathExtension = @"h";
static NSString* const	_DefaultDocumentationPath = @"English.lproj/Documentation/Reference/ObjC_classic/Protocols";
static NSString* const	_DefaultDocumentationPathExtension = @"html";

//	===========================================================================
//	Class "variable(s)"
//	---------------------------------------------------------------------------

static NSMapTable*	_map = NULL;
static NSMapTable*	_nameMap = NULL;

//	===========================================================================
//	Private method(s)
//	---------------------------------------------------------------------------

@interface SZProtocolDescriptor(PrivateMethods)

+ (NSMapTable*) _map;
+ (NSMapTable*) _nameMap;
+ (void) _invalidateMap;

@end

@implementation SZProtocolDescriptor(PrivateMethods)

+ (NSMapTable*) _map
{
	if ( _map == NULL )
	{
		_map = NSCreateMapTableWithZone(NSNonRetainedObjectMapKeyCallBacks, NSObjectMapValueCallBacks, 0, [(NSObject*)self zone]);
	}
	
	return _map;
}

+ (NSMapTable*) _nameMap
{
	if ( _nameMap == NULL )
	{
		NSSet*		aSet = [SZRuntime protocols];
		NSEnumerator*	anEnumerator = [aSet objectEnumerator];
		Protocol*	aProtocol = nil;
		
		_nameMap = NSCreateMapTableWithZone(NSObjectMapKeyCallBacks, NSNonRetainedObjectMapValueCallBacks, 0, [(NSObject*)self zone]);

		while ( ( aProtocol = [anEnumerator nextObject] ) != nil )
		{
			const char*	aName = [aProtocol name];
					
			if ( aName != NULL )
			{
				NSString*	aProtocolName = [NSString stringWithCString: aName];

				NSMapInsertIfAbsent(_nameMap, aProtocolName, aProtocol);
			}
		}
	}
	
	return _nameMap;
}

+ (void) _invalidateMap
{
	if ( _nameMap != NULL )
	{
		NSFreeMapTable(_nameMap);
		
		_nameMap = NULL;
	}
}

- (void) _setReference: (Protocol*) aValue
{
	_reference = aValue;
}

- (id) _initWithReference: (Protocol*) aReference
{
	[self init];
	
	[self _setReference: aReference];

	return self;
}

@end

//	===========================================================================
//	Implementation method(s)
//	---------------------------------------------------------------------------

@implementation SZProtocolDescriptor

+ (void) initialize
{
	[super initialize];
	
	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(bundleDidLoad:) name: NSBundleDidLoadNotification object: nil];
}

+ (void) bundleDidLoad: (NSNotification*) aNotification
{
	[self _invalidateMap];
}

+ (unsigned int) protocolCount
{
	return NSCountMapTable( [self _nameMap] );
}

+ (NSArray*) protocolNames
{
	NSArray*	someNames = NSAllMapTableKeys( [self _nameMap] );
	
	if ( someNames != nil )
	{
		unsigned int	count = [someNames count];
		NSMutableArray*	anArray = [NSMutableArray arrayWithCapacity: count];
		unsigned int	index = 0;
		
		for ( index = 0; index < count; index++ )
		{
			NSString*	aName = [someNames objectAtIndex: index];
			NSString*	aProtocolName = [NSString stringWithFormat: @"%@%@%@", SZProtocolNamePrefix, aName, SZProtocolNameSuffix];
				
			[anArray addObject: aProtocolName];
		}

		return [anArray sortedArrayUsingSelector: @selector(compare:)];
	}
	
	return nil;
}

+ (NSArray*) protocolNamesLike: (NSString*) aString
{
	if ( aString != nil )
	{
		NSArray*	someNames = NSAllMapTableKeys( [self _nameMap] );
	
		if ( someNames != nil )
		{
			NSMutableArray*	anArray = [NSMutableArray array];
			unsigned int	count = [someNames count];
			unsigned int	index = 0;
		
			for ( index = 0; index < count; index++ )
			{
				NSString*	aName = [someNames objectAtIndex: index];
				NSRange		aRange = [aName rangeOfString: aString options: NSCaseInsensitiveSearch];
			
				if ( aRange.location != NSNotFound )
				{
					NSString*	aProtocolName = [NSString stringWithFormat: @"%@%@%@", SZProtocolNamePrefix, aName, SZProtocolNameSuffix];
				
					[anArray addObject: aProtocolName];
				}
			}
		
			if ( [anArray count] > 0 )
			{
				return [anArray sortedArrayUsingSelector: @selector(compare:)];
			}
		}
	}
	
	return nil;
}

+ (SZProtocolDescriptor*) descriptorWithReference: (Protocol*) aReference
{
	if ( aReference != nil )
	{
		NSMapTable*		aMap = [self _map];
		SZProtocolDescriptor*	aDescriptor = NSMapGet(aMap, aReference);
		
		if ( aDescriptor == nil )
		{
			aDescriptor = [[[self alloc] _initWithReference: aReference] autorelease];
			
			NSMapInsertKnownAbsent(aMap, aReference, aDescriptor);
		}
		
		return aDescriptor;
	}
	
	return nil;
}

+ (SZProtocolDescriptor*) descriptorWithName: (NSString*) aName
{
	if ( ( aName != nil ) && ( [aName hasPrefix: SZProtocolNamePrefix] == YES ) && ( [aName hasSuffix: SZProtocolNameSuffix] == YES ) )
	{
		NSRange	aPrefixRange = [aName rangeOfString: SZProtocolNamePrefix];
		NSRange	aSuffixRange = [aName rangeOfString: SZProtocolNameSuffix];
		
		aName = [[aName substringFromIndex: aPrefixRange.location + 1] substringToIndex: aSuffixRange.location - 1];
	}

	if ( aName != nil )
	{
		NSMapTable*	aMap = [self _nameMap];
		Protocol*	aProtocol = NSMapGet(aMap, aName);
		
		return [self descriptorWithReference: aProtocol];
	}
	
	return nil;
}

- (id) init
{
	[super init];
	
	_didCheckFramework = NO;
	_didCheckHeader = NO;
	_didCheckDocumentation = NO;
	
	return self;
}

- (Protocol*) reference
{
	return _reference;
}

- (NSComparisonResult) compare: (SZProtocolDescriptor*) aDescriptor
{
	if ( aDescriptor != nil )
	{
		return [[self description] compare: [aDescriptor description]];
	}
	
	return NSOrderedDescending;
}

- (void) dealloc
{
	[_runtimePath release];
	[_frameworkName release];
	[_headerPath release];
	[_documentationPath release];

	[super dealloc];
}

@end

//	===========================================================================
//	Description method(s)
//	---------------------------------------------------------------------------

@implementation SZProtocolDescriptor (DescriptionMethods)

- (NSString*) description
{
	return [NSString stringWithFormat: @"%@%@%@", SZProtocolNamePrefix, [self name], SZProtocolNameSuffix];
}

- (NSString*) name
{
	const char*	aName = [[self reference] name];
	
	if ( aName != NULL )
	{
		return [NSString stringWithCString: aName];
	}
	
	return nil;
}

- (NSArray*) classMethodDescriptors
{
	NSSet*	aSet = [SZRuntime classMethodsForProtocol: [self reference]];
	
	if ( aSet != nil )
	{
		Class		aClass = (Class) [(SZClassDescriptor*)[[self implementationDescriptors] lastObject] reference] -> isa;
		NSMutableArray*	anArray = [NSMutableArray arrayWithCapacity: [aSet count]];
		NSEnumerator*	anEnumerator = [aSet objectEnumerator];
		NSDictionary*	aValue = nil;
		
		while ( ( aValue = [anEnumerator nextObject] ) != nil )
		{
			NSString*	aSelectorName = [[aValue allKeys] lastObject];
			Method		aMethod = [SZRuntime methodNamed: aSelectorName forClass: aClass];
			
			if ( aMethod != NULL )
			{
				SZMethodDescriptor*	aDescriptor = [SZMethodDescriptor classDescriptorWithReference: aMethod];
			
				[anArray addObject: aDescriptor];
			}
			else
			{
				//NSLog(@"(Info) Couldn't find a method for class selector '%@'.", aSelectorName);
			}
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
	NSSet*	aSet = [SZRuntime instanceMethodsForProtocol: [self reference]];
	
	if ( aSet != nil )
	{
		Class		aClass = (Class) [(SZClassDescriptor*)[[self implementationDescriptors] lastObject] reference];
		NSMutableArray*	anArray = [NSMutableArray arrayWithCapacity: [aSet count]];
		NSEnumerator*	anEnumerator = [aSet objectEnumerator];
		NSDictionary*	aValue = nil;
		
		while ( ( aValue = [anEnumerator nextObject] ) != nil )
		{
			NSString*	aSelectorName = [[aValue allKeys] lastObject];
			Method		aMethod = [SZRuntime methodNamed: aSelectorName forClass: aClass];
			
			if ( aMethod != NULL )
			{
				SZMethodDescriptor*	aDescriptor = [SZMethodDescriptor instanceDescriptorWithReference: aMethod];
			
				[anArray addObject: aDescriptor];
			}
			else
			{
				//NSLog(@"(Info) Couldn't find a method for instance selector '%@'.", aSelectorName);
			}
		}
		
		if ( [anArray count] > 0 )
		{
			return [anArray sortedArrayUsingSelector: @selector(compare:)];
		}
	}
	
	return nil;
}

- (NSArray*) implementationDescriptors
{
	NSArray*	someNames = [SZProtocolImplementationDescriptor classNamesWithProtocolName: [self name]];
	
	if ( someNames != nil )
	{
		unsigned int	count = [someNames count];
		unsigned int	index = 0;
		NSMutableArray*	anArray = [NSMutableArray arrayWithCapacity: count];
		
		for ( index = 0; index < count; index++ )
		{
			NSString*		aName = [someNames objectAtIndex: index];
			SZClassDescriptor*	aDescriptor = [SZClassDescriptor descriptorWithName: aName];
			
			[anArray addObject: aDescriptor];
		}
		
		return anArray;
	}
	
	return nil;
}

@end

//	===========================================================================
//	Resource method(s)
//	---------------------------------------------------------------------------

@implementation SZProtocolDescriptor (ResourceMethods)

- (NSString*) moduleName
{
	return nil;
}

- (NSString*) frameworkName
{
	if ( _didCheckFramework == NO )
	{
		NSString*	aPath = [self documentationPath];
		
		if ( aPath == nil )
		{
			aPath = [self headerPath];
		}
	
		if ( aPath != nil )
		{
			while ( [aPath length] > 0 )
			{
				if ( [[aPath pathExtension] isEqualToString: SZFrameworkPathExtension] == NO )
				{
					aPath = [aPath stringByDeletingLastPathComponent];
				}
				else
				{
					_frameworkName = [[[aPath lastPathComponent] stringByDeletingPathExtension] retain];
					
					break;
				}
			}
		}
		
		_didCheckFramework = YES;
	}
	
	return _frameworkName;
}

- (SZFrameworkDescriptor*) frameworkDescriptor
{
	return [SZFrameworkDescriptor descriptorWithName: [self frameworkName]];
}

- (NSString*) headerPath
{
	if ( _didCheckHeader == NO )
	{
		NSString*	aName = [self name];
		NSFileManager*	aFileManager = [NSFileManager defaultManager];
		NSArray*	someBundles = [NSBundle allFrameworks];
		unsigned int	count = [someBundles count];
		unsigned int	index = 0;
	
		for ( index = 0; index < count; index++ )
		{
			NSBundle*	aBundle = [someBundles objectAtIndex: index];
			NSString*	aPath = [[[[aBundle bundlePath] stringByAppendingPathComponent: _DefaultHeaderPath] stringByAppendingPathComponent: aName] stringByAppendingPathExtension: _DefaultHeaderPathExtension];
		
			if ( [aFileManager fileExistsAtPath: aPath] == YES )
			{
				_headerPath = [aPath retain];
				
				break;
			}
		}
		
		_didCheckHeader = YES;
	}
	
	return _headerPath;
}

- (NSString*) documentationPath
{
	if ( _didCheckDocumentation == NO )
	{
		NSString*	aName = [self name];
		NSFileManager*	aFileManager = [NSFileManager defaultManager];
		NSArray*	someBundles = [NSBundle allFrameworks];
		unsigned int	count = [someBundles count];
		unsigned int	index = 0;
	
		for ( index = 0; index < count; index++ )
		{
			NSBundle*	aBundle = [someBundles objectAtIndex: index];
			NSString*	aPath = [[[[aBundle resourcePath] stringByAppendingPathComponent: _DefaultDocumentationPath] stringByAppendingPathComponent: aName] stringByAppendingPathExtension: _DefaultDocumentationPathExtension];
		
			if ( [aFileManager fileExistsAtPath: aPath] == YES )
			{
				_documentationPath = [aPath retain];
				
				break;
			}
		}
		
		_didCheckDocumentation = YES;
	}
	
	return _documentationPath;
}

@end
