//
//	===========================================================================
//
//	Title:		SZClassDescriptor.m
//	Description:	[Description]
//	Author:		Raphael Szwarc
//	Creation Date:	Tue 02-Nov-1999
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

#import "SZClassDescriptor.h"

#import "SZRuntime.h"
#import "SZClassHierarchyDescriptor.h"
#import "SZCategoryDescriptor.h"
#import "SZProtocolDescriptor.h"
#import "SZVariableDescriptor.h"
#import "SZMethodDescriptor.h"
#import "SZFrameworkDescriptor.h"

#import <Foundation/Foundation.h>

#import <objc/objc-class.h>

//	===========================================================================
//	Constant(s)
//	---------------------------------------------------------------------------

static NSString*	_DefaultHeaderPath = @"Headers";
static NSString*	_DefaultHeaderPathExtension = @"h";
static NSString*	_DefaultDocumentationPath = @"English.lproj/Documentation/Reference/ObjC_classic/Classes";
static NSString*	_DefaultDocumentationPathExtension = @"html";
static NSString*	_DefaultDocumentationNameSuffix = @"ClassCluster";

//	===========================================================================
//	Class "variable(s)"
//	---------------------------------------------------------------------------

static NSMapTable*	_map = NULL;

//	===========================================================================
//	Private method(s)
//	---------------------------------------------------------------------------

@interface SZClassDescriptor(PrivateMethods)

+ (NSMapTable*) _map;
+ (void) _invalidateMap;

@end

@implementation SZClassDescriptor(PrivateMethods)

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
		NSFreeMapTable(_map);
		
		_map = NULL;
	}
}

- (void) _setReference: (Class) aValue
{
	_reference = aValue;
}

- (id) _initWithReference: (Class) aReference
{
	[self init];
	
	[self _setReference: aReference];

	return self;
}

@end

//	===========================================================================
//	Implementation
//	---------------------------------------------------------------------------

@implementation SZClassDescriptor

+ (void) initialize
{
	[super initialize];
	
	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(bundleDidLoad:) name: NSBundleDidLoadNotification object: nil];
}

+ (void) bundleDidLoad: (NSNotification*) aNotification
{
	//NSLog(@"%@ %@ %@", self, NSStringFromSelector( _cmd ), [aNotification object]);

	[self _invalidateMap];
}

+ (unsigned int) classCount
{
	return [SZRuntime classCount];
}

+ (NSArray*) classNames
{
	NSSet*	aNameSet = [SZRuntime classNames];
	
	if ( aNameSet != nil )
	{
		NSArray*	anArray = [[aNameSet allObjects] sortedArrayUsingSelector: @selector(compare:)];
		
		return anArray;
	}
	
	return nil;
}

+ (NSArray*) classNamesLike: (NSString*) aString
{
	if ( aString != nil )
	{
		NSSet*	aNameSet = [SZRuntime classNames];
	
		if ( aNameSet != nil )
		{
			NSMutableSet*	someNames = [NSMutableSet set];
			NSEnumerator*	anEnumerator = [aNameSet objectEnumerator];
			NSString*	aName = nil;
		
			while ( ( aName = [anEnumerator nextObject] ) != nil )
			{
				NSRange	aRange = [aName rangeOfString: aString options: NSCaseInsensitiveSearch];
			
				if ( aRange.location != NSNotFound )
				{
					[someNames addObject: aName];
				}
			}
		
			if ( [someNames count] > 0 )
			{
				return [[someNames allObjects] sortedArrayUsingSelector: @selector(compare:)];
			}
		}
	}
	
	return nil;
}

+ (NSArray*) classNamesWithMethodNameLike: (NSString*) aString
{
	if ( aString != nil )
	{
		NSSet*	aClassSet = [SZRuntime classes];
	
		if ( aClassSet != nil )
		{
			NSMutableSet*	someNames = [NSMutableSet set];
			NSEnumerator*	anEnumerator = [aClassSet objectEnumerator];
			NSValue*	aValue = nil;
		
			while ( ( aValue = [anEnumerator nextObject] ) != nil )
			{
				Class	aClass = [aValue pointerValue];
				NSSet*	aMethodSet = [SZRuntime methodNamesForClass: aClass];
				
				if ( aMethodSet != nil )
				{
					NSString*	aClassName = NSStringFromClass(aClass);
					NSEnumerator*	aMethodEnumerator = [aMethodSet objectEnumerator];
					NSString*	aMethodName = nil;
					
					while ( ( aMethodName = [aMethodEnumerator nextObject] ) != nil )
					{
						NSRange	aRange = [aMethodName rangeOfString: aString options: NSCaseInsensitiveSearch];
			
						if ( aRange.location != NSNotFound )
						{
							//NSLog(@"%@ %@", aClassName, aMethodName);
						
							[someNames addObject: aClassName];
						}
					}
				}
			}
		
			if ( [someNames count] > 0 )
			{
				return [[someNames allObjects] sortedArrayUsingSelector: @selector(compare:)];
			}
		}
	}
	
	return nil;
}


+ (SZClassDescriptor*) descriptorWithName: (NSString*) aClassName
{
	if ( aClassName != nil )
	{
		Class	aClass = NSClassFromString(aClassName);
		
		if ( aClass != NULL )
		{
			NSMapTable*		aMap = [self _map];
			SZClassDescriptor*	aDescriptor = NSMapGet(aMap, aClass);
		
			if ( aDescriptor == nil )
			{
				aDescriptor = [[[self alloc] _initWithReference: aClass] autorelease];
				
				NSMapInsertKnownAbsent( aMap, aClass, aDescriptor );
			}
		
			return aDescriptor;
		}
	}
	
	return nil;
}

- (Class) reference
{
	return _reference;
}

- (NSComparisonResult) compare: (SZClassDescriptor*) aDescriptor
{
	if ( aDescriptor != nil )
	{
		return [[self description] compare: [aDescriptor description]];
	}
	
	return NSOrderedDescending;
}

- (id) init
{
	[super init];
	
	_didCheckFramework = NO;
	_didCheckHeader = NO;
	_didCheckDocumentation = NO;
	
	return self;
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

@implementation SZClassDescriptor(DescriptionMethods)

- (NSString*) description
{
	return [self name];
}

- (NSString*) name
{
	return NSStringFromClass([self reference]);
}

- (SZClassDescriptor*) superClassDescriptor
{
	Class	aClass = [self reference];
	Class	aSuperClass = aClass -> super_class;
	
	if ( aSuperClass != NULL )
	{
		const char*	aClassName = aSuperClass -> name;
		
		if ( aClassName != NULL )
		{
			NSString*	aName = [NSString stringWithCString: aClassName];
		
			return [SZClassDescriptor descriptorWithName: aName];
		}
	}
	
	return nil;
}

- (NSArray*) superClassNames
{
	NSMutableArray*		anArray = [NSMutableArray array];
	SZClassDescriptor*	aSuperClass = [self superClassDescriptor];
	
	while ( aSuperClass != nil )
	{
		[anArray insertObject: [aSuperClass name] atIndex: 0];
		aSuperClass = [aSuperClass superClassDescriptor];
	}
	
	if ( [anArray count] > 0 )
	{
		return anArray;
	}
	
	return nil;
}

- (NSArray*) subClassDescriptors
{
	NSArray*	someClassNames = [SZClassHierarchyDescriptor classNamesWithSuperClassName: [self name]];
	
	if ( someClassNames != nil )
	{
		unsigned int	count = [someClassNames count];
		NSMutableArray*	anArray = [NSMutableArray arrayWithCapacity: count];
		unsigned int	index = 0;
		
		for ( index = 0; index < count; index++ )
		{
			NSString*		aClassName = [someClassNames objectAtIndex: index];
			SZClassDescriptor*	aDescriptor = [SZClassDescriptor descriptorWithName: aClassName];
			
			[anArray addObject: aDescriptor];
		}
		
		if ( [anArray count] > 0 )
		{
			return anArray;
		}
	}
	
	return nil;
}

- (NSArray*) protocolDescriptors
{
	NSSet*	aSet = [SZRuntime protocolsForClass: [self reference]];
	
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
	
	return nil;
}

- (NSArray*) protocolNames
{
	NSArray*	someProtocols = [self protocolDescriptors];
	
	if ( someProtocols != nil )
	{
		int		count = [someProtocols count];
		int		index = 0;
		NSMutableArray*	someNames = [NSMutableArray arrayWithCapacity: count];

		for ( index = 0; index < count; index++ )
		{
			SZProtocolDescriptor*	aProtocol = [someProtocols objectAtIndex: index];
			
			[someNames addObject: [aProtocol description]];
		}
		
		return someNames;
	}
	
	return nil;
}

- (NSArray*) variableDescriptors
{
	NSSet*	aSet = [SZRuntime variablesForClass: [self reference]];
	
	if ( aSet != nil )
	{
		NSMutableArray*	anArray = [NSMutableArray arrayWithCapacity: [aSet count]];
		NSEnumerator*	anEnumerator = [aSet objectEnumerator];
		NSValue*	aValue = nil;
		
		while ( ( aValue = [anEnumerator nextObject] ) != nil )
		{
			Ivar			anIvar = (Ivar) [aValue pointerValue];
			SZVariableDescriptor*	aDescriptor = [SZVariableDescriptor descriptorWithReference: anIvar];
			
			[anArray addObject: aDescriptor];
		}
		
		if ( [anArray count] > 0 )
		{
			return [anArray sortedArrayUsingSelector: @selector(compare:)];
		}
	}
	
	return nil;
}

- (NSArray*) classMethodDescriptors
{
	NSSet*	aSet = [SZRuntime methodsForClass: [self reference] -> isa];
	
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
	NSSet*	aSet = [SZRuntime methodsForClass: [self reference]];
	
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

//	===========================================================================
//	Category description method(s)
//	---------------------------------------------------------------------------

@implementation SZClassDescriptor(CategoryDescriptionMethods)

- (NSArray*) categoryDescriptors
{
	return [SZCategoryDescriptor descriptorsForClass: [self reference]];
}

- (NSArray*) defaultProtocolDescriptors
{
	NSArray*	allProtocols = [self protocolDescriptors];
	
	if ( allProtocols != nil )
	{
		NSArray*	someCategories = [self categoryDescriptors];
		
		if ( someCategories != nil )
		{
			NSMutableSet*	allProtocolSet = [NSMutableSet setWithArray: allProtocols];
			unsigned int	count = [someCategories count];
			unsigned int	index = 0;
			
			for ( index = 0; index < count; index++ )
			{
				SZCategoryDescriptor*	aDescriptor = [someCategories objectAtIndex: index];
				NSArray*		someProtocols = [aDescriptor protocolDescriptors];
				
				if ( someProtocols != nil )
				{
					NSSet*	aProtocolSet = [NSSet setWithArray: someProtocols];
					
					[allProtocolSet minusSet: aProtocolSet];
				}
			}
			
			if ( [allProtocolSet count] > 0 )
			{
				return [[allProtocolSet allObjects] sortedArrayUsingSelector: @selector(compare:)];
			}
			
			return nil;
		}
	}
	
	return allProtocols;
}

- (NSArray*) defaultClassMethodDescriptors
{
	NSArray*	allMethods = [self classMethodDescriptors];
	
	if ( allMethods != nil )
	{
		NSArray*	someCategories = [self categoryDescriptors];
		
		if ( someCategories != nil )
		{
			NSMutableSet*	allMethodSet = [NSMutableSet setWithArray: allMethods];
			unsigned int	count = [someCategories count];
			unsigned int	index = 0;
			
			for ( index = 0; index < count; index++ )
			{
				SZCategoryDescriptor*	aDescriptor = [someCategories objectAtIndex: index];
				NSArray*		someMethods = [aDescriptor classMethodDescriptors];
				
				if ( someMethods != nil )
				{
					NSSet*	aMethodSet = [NSSet setWithArray: someMethods];
					
					[allMethodSet minusSet: aMethodSet];
				}
			}
			
			if ( [allMethodSet count] > 0 )
			{
				return [[allMethodSet allObjects] sortedArrayUsingSelector: @selector(compare:)];
			}
			
			return nil;
		}
	}
	
	return allMethods;
}

- (NSArray*) defaultInstanceMethodDescriptors
{
	NSArray*	allMethods = [self instanceMethodDescriptors];
	
	if ( allMethods != nil )
	{
		NSArray*	someCategories = [self categoryDescriptors];
		
		if ( someCategories != nil )
		{
			NSMutableSet*	allMethodSet = [NSMutableSet setWithArray: allMethods];
			unsigned int	count = [someCategories count];
			unsigned int	index = 0;
			
			for ( index = 0; index < count; index++ )
			{
				SZCategoryDescriptor*	aDescriptor = [someCategories objectAtIndex: index];
				NSArray*		someMethods = [aDescriptor instanceMethodDescriptors];
				
				if ( someMethods != nil )
				{
					NSSet*	aMethodSet = [NSSet setWithArray: someMethods];
					
					[allMethodSet minusSet: aMethodSet];
				}
			}
			
			if ( [allMethodSet count] > 0 )
			{
				return [[allMethodSet allObjects] sortedArrayUsingSelector: @selector(compare:)];
			}
			
			return nil;
		}
	}
	
	return allMethods;
}

@end

//	===========================================================================
//	Resource method(s)
//	---------------------------------------------------------------------------

@implementation SZClassDescriptor(ResourceMethods)

- (NSString*) frameworkName
{
	if ( _didCheckFramework == NO )
	{
		_frameworkName = [[SZFrameworkDescriptor frameworkNameForClass: [self reference]] retain];
		
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
		NSBundle*	aBundle = [NSBundle bundleForClass: [self reference]];
	
		if ( aBundle != nil )
		{
			NSString*	aPath = [[[[aBundle bundlePath] stringByAppendingPathComponent: _DefaultHeaderPath] stringByAppendingPathComponent: [self name]] stringByAppendingPathExtension: _DefaultHeaderPathExtension];
		
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
		NSBundle*	aBundle = [NSBundle bundleForClass: [self reference]];
	
		if ( aBundle != nil )
		{
			NSString*	aPath = [[[[aBundle resourcePath] stringByAppendingPathComponent: _DefaultDocumentationPath] stringByAppendingPathComponent: [self name]] stringByAppendingPathExtension: _DefaultDocumentationPathExtension];
		
			if ( [[NSFileManager defaultManager] fileExistsAtPath: aPath] == NO )
			{
				aPath = [[[[aBundle resourcePath] stringByAppendingPathComponent: _DefaultDocumentationPath] stringByAppendingPathComponent: [NSString stringWithFormat: @"%@%@", [self name], _DefaultDocumentationNameSuffix]] stringByAppendingPathExtension: _DefaultDocumentationPathExtension];

				if ( [[NSFileManager defaultManager] fileExistsAtPath: aPath] == NO )
				{
					aPath = nil;
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
