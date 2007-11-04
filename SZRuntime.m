//
//	===========================================================================
//
//	Title:		SZRuntime.m
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

#import "SZRuntime.h"
#import "ProtocolAdditions.h"

#import <Foundation/Foundation.h>

#import <objc/objc-runtime.h>
#import <objc/Protocol.h>

typedef struct header_info*	ObjCHeaderInfo;


//	===========================================================================
//	Class "variable(s)"
//	---------------------------------------------------------------------------

static Class*	_classes = NULL;
static int	_classesCount = 0;

//	===========================================================================
//	Implementation
//	---------------------------------------------------------------------------

@interface SZRuntime(Private)

+ (Class*) _classes;
+ (int) _classesCount;
+ (void) _invalidateClasses;

@end

@implementation SZRuntime

+ (void) initialize
{
	[super initialize];
	
	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(bundleDidLoad:) name: NSBundleDidLoadNotification object: nil];
}

+ (void) bundleDidLoad: (NSNotification*) aNotification
{
	//NSLog(@"%@ %@", NSStringFromSelector( _cmd ), [aNotification object]);

	[self _invalidateClasses];
}

+ (void) _invalidateClasses
{
	if ( _classes != NULL )
	{
		free( _classes );
		_classes = NULL;
		_classesCount = 0;
	}

	[SZRuntime _invalidateCatagories];
}

+ (Class*) _classes
{
	if ( _classes == NULL )
	{
		int	aNewCount = objc_getClassList( NULL, _classesCount );
		
		while ( _classesCount < aNewCount ) 
		{
			_classesCount = aNewCount;
			_classes = realloc( _classes, sizeof( Class ) * _classesCount );
			aNewCount = objc_getClassList( _classes, _classesCount );
		}
	}
	
	return _classes;
}

+ (int) _classesCount
{
	[self _classes];

	return _classesCount;
}


+ (unsigned int) classCount
{
	return [self _classesCount];
}

+ (NSSet*) classes
{
	NSBundle*	aBundle = [NSBundle bundleForClass: self];
	Class*		someClasses = [self _classes];
	int		count = [self _classesCount];
	NSMutableSet*	aSet = [NSMutableSet setWithCapacity: count];
	int		index = 0;
	
	for ( index = 0; index < count; index++ )
	{
		Class	aClass = someClasses[ index ];
		
		if ( aBundle != [NSBundle bundleForClass: aClass] )
		{
			NSValue*	aValue = [NSValue value: &aClass withObjCType: @encode(Class)];
		
			[aSet addObject: aValue];
		}
	}
	
	if ( [aSet count] > 0 )
	{
		return aSet;
	}

	return nil;
}

+ (NSSet*) classNames
{
	NSBundle*	aBundle = [NSBundle bundleForClass: self];
	Class*		someClasses = [self _classes];
	int		count = [self _classesCount];
	NSMutableSet*	aSet = [NSMutableSet setWithCapacity: count];
	int		index = 0;
	
	for ( index = 0; index < count; index++ )
	{
		Class		aClass = someClasses[ index ];

		if ( aBundle != [NSBundle bundleForClass: aClass] )
		{
			const char*	aCharName = aClass -> name;
		
			if ( aCharName != NULL )
			{
				NSString*	aName = [NSString stringWithCString: aCharName];
		
				[aSet addObject: aName];
			}
		}
	}
	
	if ( [aSet count] > 0 )
	{
		return aSet;
	}

	return nil;
}

@end

//	===========================================================================
//	Protocol Runtime method(s)
//	---------------------------------------------------------------------------

@implementation SZRuntime(ProtocolRuntimeMethods)

+ (NSSet*) protocols
{
	Class*		someClasses = [self _classes];
	int		count = [self _classesCount];
	NSMutableSet*	aSet = [NSMutableSet setWithCapacity: count];
	int		index = 0;
	
	for ( index = 0; index < count; index++ )
	{
		Class	aClass = someClasses[ index ];
		NSSet*	someProtocols = [self protocolsForClass: aClass];
		
		if ( someProtocols != nil )
		{
			[aSet unionSet: someProtocols];
		}
	}
	
	if ( [aSet count] > 0 )
	{
		return aSet;
	}

	return nil;
}

+ (NSSet*) protocolNames
{
	Class*		someClasses = [self _classes];
	int		count = [self _classesCount];
	NSMutableSet*	aSet = [NSMutableSet setWithCapacity: count];
	int		index = 0;
	
	for ( index = 0; index < count; index++ )
	{
		Class	aClass = someClasses[ index ];
		NSSet*	someProtocols = [self protocolNamesForClass: aClass];
		
		if ( someProtocols != nil )
		{
			[aSet unionSet: someProtocols];
		}
	}
	
	if ( [aSet count] > 0 )
	{
		return aSet;
	}

	return nil;
}

+ (NSSet*) protocolsForClass: (Class) aClass
{
	if ( aClass != NULL )
	{
		struct objc_protocol_list*	aProtocolList = aClass -> protocols;
		NSMutableSet*			aSet = [NSMutableSet set];
		
		while ( aProtocolList != NULL )
		{
			unsigned int	count = aProtocolList -> count;
			unsigned int	index = 0;
			
			for ( index = 0; index < count; index++ )
			{
				Protocol*	aProtocol = aProtocolList -> list[index];
				
				[aSet addObject: aProtocol];
			}
			
			aProtocolList = aProtocolList  -> next;
		}

		if ( [aSet count] > 0 )
		{
			return aSet;
		}
	}
	
	return nil;
}

+ (NSSet*) protocolNamesForClass: (Class) aClass
{
	if ( aClass != NULL )
	{
		struct objc_protocol_list*	aProtocolList = aClass -> protocols;
		NSMutableSet*			aSet = [NSMutableSet set];
		
		while ( aProtocolList != NULL )
		{
			unsigned int	count = aProtocolList -> count;
			unsigned int	index = 0;
			
			for ( index = 0; index < count; index++ )
			{
				Protocol*	aProtocol = aProtocolList -> list[index];
				NSString*	aName = [NSString stringWithCString: [aProtocol name]];
				
				[aSet addObject: aName];
			}
			
			aProtocolList = aProtocolList  -> next;
		}

		if ( [aSet count] > 0 )
		{
			return aSet;
		}
	}
	
	return nil;
}

+ (NSSet*) _protocolMethodsWithList: (ObjCMethodDescriptionList) aList
{
	if ( aList != NULL )
	{
		unsigned int	count = aList -> count;
		NSMutableSet*	aSet = [NSMutableSet setWithCapacity: count];
		unsigned int	index = 0;
		
		for ( index = 0; index < count; index++ )
		{
			ObjCMethodDescription	aMethodDescription = &aList -> list[index];
			SEL			aSelector = aMethodDescription -> name;
			
			if ( aSelector != NULL )
			{
				NSString*	aSelectorName = [NSString stringWithCString: sel_getName(aSelector)];
				char*		aType = aMethodDescription -> types;
				
				if ( aType != NULL )
				{
					NSString*	aSignature = [NSString stringWithCString: aType];
					NSDictionary*	aDictionary = [NSDictionary dictionaryWithObjectsAndKeys: aSignature, aSelectorName, nil];

					[aSet addObject: aDictionary];
				}
			}
		}
		
		if ( [aSet count] > 0 )
		{
			return aSet;
		}
	}
	
	return nil;
}

+ (NSSet*) classMethodsForProtocol: (Protocol*) aProtocol
{
	if ( aProtocol != nil )
	{
		return [self _protocolMethodsWithList: [aProtocol _classMethodDescriptionList]];
	}	
	
	return nil;
}

+ (NSSet*) instanceMethodsForProtocol: (Protocol*) aProtocol
{
	if ( aProtocol != nil )
	{
		return [self _protocolMethodsWithList: [aProtocol _instanceMethodDescriptionList]];
	}	
	
	return nil;
}

@end

//	===========================================================================
//	Variable Runtime method(s)
//	---------------------------------------------------------------------------

@implementation SZRuntime(VariableRuntimeMethods)

+ (NSSet*) variablesForClass: (Class) aClass
{
	if ( aClass != NULL )
	{
		struct objc_ivar_list*	aVariableList = aClass -> ivars;

		if ( aVariableList != NULL )
		{
			unsigned int		count = aVariableList -> ivar_count;
		
			if ( count > 0 )
			{
				NSMutableSet*		aSet = [NSMutableSet setWithCapacity: count];
				unsigned int		index = 0;
			
				for ( index = 0; index < count; index++ )
				{
					Ivar		aVariable = &aVariableList -> ivar_list[index];
					NSValue*	aValue = [NSValue value: &aVariable withObjCType: @encode(Ivar)];
				
					[aSet addObject: aValue];
				}

				if ( [aSet count] > 0 )
				{
					return aSet;
				}
			}
		}
	}
	
	return nil;
}

+ (NSSet*) variableNamesForClass: (Class) aClass
{
	if ( aClass != NULL )
	{
		struct objc_ivar_list*	aVariableList = aClass -> ivars;
		
		if ( aVariableList != NULL )
		{
			unsigned int		count = aVariableList -> ivar_count;
		
			if ( count > 0 )
			{
				NSMutableSet*		aSet = [NSMutableSet setWithCapacity: count];
				unsigned int		index = 0;
			
				for ( index = 0; index < count; index++ )
				{
					Ivar		aVariable = &aVariableList -> ivar_list[index];
					char*		anIvarName = aVariable -> ivar_name;
					
					if ( anIvarName != NULL )
					{
						NSString*	aName = [NSString stringWithCString: anIvarName];
				
						[aSet addObject: aName];
					}
				}

				if ( [aSet count] > 0 )
				{
					return aSet;
				}
			}
		}
	}
	
	return nil;
}

@end

//	===========================================================================
//	Method Runtime method(s)
//	---------------------------------------------------------------------------

@implementation SZRuntime(MethodRuntimeMethods)

+ (Method) methodNamed: (NSString*) aMethodName forClass: (Class) aClass
{
	if ( ( aMethodName != nil ) && ( aClass != NULL ) )
	{
		SEL				aMethodSelector = NSSelectorFromString(aMethodName);
		void*				iterator = NULL;
		struct objc_method_list*	aMethodList = NULL;
		
		while ( ( aMethodList = class_nextMethodList( aClass, &iterator) ) != NULL )
		{
			unsigned int	count = aMethodList -> method_count;
			unsigned int	index = 0;
			
			for ( index = 0; index < count; index++ )
			{
				Method	aMethod = &aMethodList -> method_list[index];
				SEL	aSelector = aMethod -> method_name;
				
				if ( aSelector == aMethodSelector )
				{
					return aMethod;
				}
			}
		}
	}
		
	return NULL;
}

+ (NSSet*) methodsForClass: (Class) aClass
{
	if ( aClass != NULL )
	{
		void*				iterator = NULL;
		struct objc_method_list*	aMethodList = NULL;
		NSMutableSet*			aSet = [NSMutableSet set];
		
		while ( ( aMethodList = class_nextMethodList( aClass, &iterator) ) != NULL )
		{
			unsigned int	count = aMethodList -> method_count;
			unsigned int	index = 0;
			
			for ( index = 0; index < count; index++ )
			{
				Method		aMethod = &aMethodList -> method_list[index];
				NSValue*	aValue = [NSValue value: &aMethod withObjCType: @encode(Method)];
				
				[aSet addObject: aValue];
			}
		}

		if ( [aSet count] > 0 )
		{
			return aSet;
		}
	}
	
	return nil;
}

+ (NSSet*) methodNamesForClass: (Class) aClass
{
	if ( aClass != NULL )
	{
		void*				iterator = NULL;
		struct objc_method_list*	aMethodList = NULL;
		NSMutableSet*			aSet = [NSMutableSet set];
		
		while ( ( aMethodList = class_nextMethodList( aClass, &iterator ) ) != NULL )
		{
			unsigned int	count = aMethodList -> method_count;
			unsigned int	index = 0;
			
			for ( index = 0; index < count; index++ )
			{
				Method		aMethod = &aMethodList -> method_list[index];
				SEL		aSelector = aMethod -> method_name;
				
				if ( aSelector != NULL )
				{
					NSString*	aName = [NSString stringWithCString: sel_getName( aSelector )];
				
					[aSet addObject: aName];
				}
			}
		}

		if ( [aSet count] > 0 )
		{
			return aSet;
		}
	}
	
	return nil;
}

@end

