//
//	===========================================================================
//
//	Title:		SZFrameworkDescriptor.m
//	Description:	[Description]
//	Author:		Raphael Szwarc
//	Creation Date:	Thu 04-Nov-1999
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

#import "SZFrameworkDescriptor.h"

#import "SZRuntime.h"
#import "SZClassDescriptor.h"

#import <Foundation/Foundation.h>

#import <objc/objc-class.h>
#import <objc/objc-runtime.h>

//	===========================================================================
//	Constant(s)
//	---------------------------------------------------------------------------

NSString* const		SZFrameworkPathExtension = @"framework";
NSString* const		SZFrameworkNamePrefix = @"#";
NSString* const		SZFrameworkNameSuffix = @" ";

static NSString*	_DefaultFrameworkPath = @"Frameworks";
static NSString*	_DefaultPrivateFrameworkPath = @"PrivateFrameworks";
static NSString*	_UnknownFramework = @"*Unknown*";

static NSString*	_DefaultHeaderPath = @"Headers";
static NSString*	_DefaultHeaderPathExtension = @"h";
static NSString*	_DefaultDocumentationPath = @"Resources/English.lproj/Documentation/Reference/ObjC_classic";
static NSString*	_DefaultDocumentationPathExtension = @"html";
static NSString*	_DefaultDocumentationNameSuffix = @"TOC";
static NSString*	_DefaultDocumentationNamePrefix = @"index";

//	===========================================================================
//	Class "variable(s)"
//	---------------------------------------------------------------------------

static NSMapTable*	_map = NULL;
static NSMapTable*	_classMap = NULL;

//	===========================================================================
//	Private method(s)
//	---------------------------------------------------------------------------

@interface SZFrameworkDescriptor(PrivateMethods)

+ (NSMapTable*) _map;
+ (NSMapTable*) _classMap;
+ (void) _invalidateMap;

@end

@implementation SZFrameworkDescriptor(PrivateMethods)

+ (NSMapTable*) _map
{
	if ( _map == NULL )
	{
		_map = NSCreateMapTableWithZone(NSObjectMapKeyCallBacks, NSObjectMapValueCallBacks, 0, [(NSObject*)self zone]);
	}
	
	return _map;
}

+ (NSMapTable*) _classMap
{
	if ( _classMap == NULL )
	{
		NSAutoreleasePool*	aPool = [[NSAutoreleasePool alloc] init];
		NSSet*			aClassSet = [SZRuntime classes];
		NSEnumerator*		anEnumerator = [aClassSet objectEnumerator];
		NSValue*		aValue = nil;
	
		//NSLog( @"SZFrameworkDescriptor._classMap " );

		_classMap = NSCreateMapTableWithZone(NSObjectMapKeyCallBacks, NSNonOwnedPointerMapValueCallBacks, 0, [(NSObject*)self zone]);

		while ( ( aValue = [anEnumerator nextObject] ) != nil )
		{
			Class		aClass = (Class) [aValue pointerValue];
			const char*	aClassName = aClass -> name;
			NSString*	aFrameworkName = [self frameworkNameForClass: aClass];
			
			if ( aFrameworkName == nil )
			{
				aFrameworkName = _UnknownFramework;
			}
			
			if ( aFrameworkName != nil )
			{
				NSHashTable*	aTable = NSMapGet(_classMap, aFrameworkName);
	
				if ( aTable == NULL )
				{
					aTable = NSCreateHashTableWithZone(NSNonOwnedPointerHashCallBacks, 0, [(NSObject*)self zone]);
		
					NSMapInsertKnownAbsent(_classMap, aFrameworkName, aTable);
				}
	
				NSHashInsertIfAbsent(aTable, aClassName);
			}
		}
	
		[aPool release];
	}
	
	return _classMap;
}

+ (void) _invalidateMap
{
	if ( _classMap != NULL )
	{
		NSFreeMapTable(_classMap);
		
		_classMap = NULL;
	}
}

- (void) _setName: (NSString*) aValue
{
	[_name autorelease];
	_name = [aValue retain];
}

- (id) _initWithName: (NSString*) aName
{
	[self init];
	
	[self _setName: aName];

	return self;
}

@end

//	===========================================================================
//	Implementation
//	---------------------------------------------------------------------------

@implementation SZFrameworkDescriptor

+ (void) initialize
{
	[super initialize];
	
	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(bundleDidLoad:) name: NSBundleDidLoadNotification object: nil];
}

+ (void) bundleDidLoad: (NSNotification*) aNotification
{
	[self _invalidateMap];
}

+ (NSArray*) allFrameworkPaths
{
	NSMutableArray*	anArray = [NSMutableArray array];
	NSArray*	defaultFrameworkExtensions = [NSArray arrayWithObjects: SZFrameworkPathExtension, nil];
	NSArray*	defaultFrameworkPaths = [NSArray arrayWithObjects: _DefaultFrameworkPath, _DefaultPrivateFrameworkPath, nil];
	unsigned int	defaultFrameworkPathCount = [defaultFrameworkPaths count];
	NSFileManager*	aFileManager = [NSFileManager defaultManager];
	NSArray*	somePaths = NSSearchPathForDirectoriesInDomains(NSAllLibrariesDirectory, NSAllDomainsMask, YES);
	unsigned int	count = [somePaths count];
	unsigned int	index = 0;
	
	for ( index = 0; index < count; index++ )
	{
		NSString*	aPath = [somePaths objectAtIndex: index];
		unsigned int	defaultFrameworkPathIndex = 0;
		
		for ( defaultFrameworkPathIndex = 0; defaultFrameworkPathIndex < defaultFrameworkPathCount; defaultFrameworkPathIndex ++ )
		{
			NSString*	aDefaultFrameworkPath = [defaultFrameworkPaths objectAtIndex: defaultFrameworkPathIndex];
			NSString*	aFrameworkDirectoryPath = [aPath stringByAppendingPathComponent: aDefaultFrameworkPath];
			BOOL		isDirectory;
		
			if ( ( [aFileManager fileExistsAtPath: aFrameworkDirectoryPath isDirectory: &isDirectory] == YES ) && ( isDirectory == YES ) )
			{
				NSArray*	directoryContents = [aFileManager directoryContentsAtPath: aFrameworkDirectoryPath];
				
				if ( directoryContents != nil )
				{
					NSArray*	matchingPaths = [directoryContents pathsMatchingExtensions: defaultFrameworkExtensions];
					
					if ( matchingPaths != nil )
					{
						unsigned int	matchingPathsCount = [matchingPaths count];
						unsigned int	matchingPathsIndex = 0;
						
						matchingPaths = [matchingPaths sortedArrayUsingSelector: @selector(compare:)];
						
						for ( matchingPathsIndex = 0; matchingPathsIndex <  matchingPathsCount; matchingPathsIndex ++ )
						{
							NSString*	aFrameworkName = [matchingPaths objectAtIndex: matchingPathsIndex];
							NSString*	aFrameworkPath = [aFrameworkDirectoryPath stringByAppendingPathComponent: aFrameworkName];
							
							if ( [anArray containsObject: aFrameworkPath] == NO )
							{
								[anArray addObject: aFrameworkPath];
							}
						}
					}
				}
			}
		}
	}
	
	if ( [anArray count] > 0 )
	{
		return anArray;
	}
	
	return nil;
}

+ (NSArray*) frameworkNames
{
	NSArray*	anArray = NSAllMapTableKeys([self _classMap]);

	return [anArray sortedArrayUsingSelector: @selector(compare:)];
}

+ (NSArray*) classNamesWithFrameworkName: (NSString*) aFrameworkName
{
	if ( aFrameworkName == nil )
	{
		aFrameworkName = _UnknownFramework;
	}
	
	if ( aFrameworkName != nil )
	{
		NSMapTable*	aMap = [self _classMap];
		NSHashTable*	aTable = NSMapGet(aMap, aFrameworkName);
		
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

+ (NSString*) frameworkNameForClass: (Class) aClass
{
	if ( aClass != NULL )
	{
		NSBundle*	aBundle = [NSBundle bundleForClass: aClass];
			
		if ( aBundle != nil )
		{
			NSString*	aBundlePath = [aBundle bundlePath];
				
			//if ( [[aBundlePath pathExtension] isEqualToString: SZFrameworkPathExtension] == YES )
			{
				return [[aBundlePath lastPathComponent] stringByDeletingPathExtension];
			}
		}
	}
	
	return nil;
}

+ (SZFrameworkDescriptor*) descriptorWithName: (NSString*) aName
{
	if ( ( aName != nil ) && ( [aName hasPrefix: SZFrameworkNamePrefix] == YES ) && ( [aName hasSuffix: SZFrameworkNameSuffix] == YES ) )
	{
		NSRange	aPrefixRange = [aName rangeOfString: SZFrameworkNamePrefix];
		NSRange	aSuffixRange = [aName rangeOfString: SZFrameworkNameSuffix];
		
		aName = [[aName substringFromIndex: aPrefixRange.location + 1] substringToIndex: aSuffixRange.location - 1];
	}

	if ( aName != nil )
	{
		NSMapTable*		aMap = [self _map];
		SZFrameworkDescriptor*	aDescriptor = NSMapGet(aMap, aName);
			
		if ( aDescriptor == nil )
		{
			NSMapTable*	aClassMap = [self _classMap];
			NSHashTable*	aTable = NSMapGet(aClassMap, aName);
		
			if ( aTable != NULL )
			{
				aDescriptor = [[[self alloc] _initWithName: aName] autorelease];
				
				NSMapInsertKnownAbsent(aMap, aName, aDescriptor);
			}
		}
			
		return aDescriptor;
	}

	return nil;
}

- (id) init
{
	[super init];
	
	_didCheckModule = NO;
	_didCheckHeader = NO;
	_didCheckDocumentation = NO;
	
	return self;
}

- (void) dealloc
{
	[_name release];
	[_path release];
	
	[_moduleName release];
	[_headerPath release];
	[_documentationPath release];

	[super dealloc];
}

@end

//	===========================================================================
//	Description method(s)
//	---------------------------------------------------------------------------

@implementation SZFrameworkDescriptor (DescriptionMethods)

- (NSString*) description
{
	return [NSString stringWithFormat: @"%@%@%@", SZFrameworkNamePrefix, [self name], SZFrameworkNameSuffix];
}

- (NSString*) name
{
	return _name;
}

- (NSArray*) classDescriptors
{
	NSArray*	someClassNames = [[self class] classNamesWithFrameworkName: [self name]];
	
	if ( someClassNames != nil )
	{
		unsigned int	count = [someClassNames count];
		unsigned int	index = 0;
		NSMutableArray*	anArray = [NSMutableArray arrayWithCapacity: count];
		
		for ( index = 0; index < count; index++ )
		{
			NSString*		aName = [someClassNames objectAtIndex: index];
			SZClassDescriptor*	aDescriptor = [SZClassDescriptor descriptorWithName: aName];
			
			if ( aDescriptor != nil )
			{
				[anArray addObject: aDescriptor];
			}
		}
		
		if ( [anArray count] > 0 )
		{
			return anArray;
		}
	}
	
	return nil;
}

@end

//	===========================================================================
//	Resource method(s)
//	---------------------------------------------------------------------------

@implementation SZFrameworkDescriptor(ResourceMethods)

- (NSString*) path
{
	if ( _path == nil )
	{
		NSArray*	someClassNames = [[self class] classNamesWithFrameworkName: [self name]];
	
		if ( ( someClassNames != nil ) && ( [someClassNames count] > 0 ) )
		{
			NSString*	aClassName = [someClassNames lastObject];
			Class		aClass = NSClassFromString(aClassName);
			NSBundle*	aBundle = [NSBundle bundleForClass: aClass];
			
			if ( aBundle != nil )
			{
				_path = [[aBundle bundlePath] retain];
			}
		}
	}
	
	return _path;
}

- (NSString*) headerPath
{
	if ( _didCheckHeader == NO )
	{
		NSString*	aFrameworkPath = [self path];
	
		if ( aFrameworkPath != nil )
		{
			NSString*	aPath = [[[aFrameworkPath stringByAppendingPathComponent: _DefaultHeaderPath] stringByAppendingPathComponent: [self name]] stringByAppendingPathExtension: _DefaultHeaderPathExtension];
		
			if ( [[NSFileManager defaultManager] fileExistsAtPath: aPath] == YES )
			{
				_headerPath = [aPath retain];
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
		NSString*	aFrameworkPath = [self path];
	
		if ( aFrameworkPath != nil )
		{
			NSString*	aPath = [[[aFrameworkPath stringByAppendingPathComponent: _DefaultDocumentationPath] stringByAppendingPathComponent: [NSString stringWithFormat: @"%@%@", [self name], _DefaultDocumentationNameSuffix]] stringByAppendingPathExtension: _DefaultDocumentationPathExtension];
		
			if ( [[NSFileManager defaultManager] fileExistsAtPath: aPath] == NO )
			{
				aPath = [[[aFrameworkPath stringByAppendingPathComponent: _DefaultDocumentationPath] stringByAppendingPathComponent: [self name]] stringByAppendingPathExtension: _DefaultDocumentationPathExtension];

				if ( [[NSFileManager defaultManager] fileExistsAtPath: aPath] == NO )
				{
					aPath = [aFrameworkPath stringByAppendingPathComponent: _DefaultDocumentationPath];
					aPath = [[aPath stringByAppendingPathComponent: _DefaultDocumentationNamePrefix] stringByAppendingPathExtension: _DefaultDocumentationPathExtension];

					if ( [[NSFileManager defaultManager] fileExistsAtPath: aPath] == NO )
					{
						aPath = nil;
					}
				}
			}
			
			if ( aPath != nil )
			{
				_documentationPath = [aPath retain];
			}
		}
		
		_didCheckDocumentation = YES;
	}
	
	return _documentationPath;
}

@end