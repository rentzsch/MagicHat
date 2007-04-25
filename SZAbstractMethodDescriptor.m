//
//	===========================================================================
//
//	Title:		SZAbstractMethodDescriptor.m
//	Description:	[Description]
//	Author:		Raphael Szwarc
//	Creation Date:	Thu 11-Nov-1999
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

#import "SZAbstractMethodDescriptor.h"

#import "SZTypeDescriptor.h"

#import <Foundation/Foundation.h>

//	===========================================================================
//	Constant(s)
//	---------------------------------------------------------------------------

NSString* const	SZMethodNameSeparator = @":";

//	===========================================================================
//	Implementation
//	---------------------------------------------------------------------------

@implementation SZAbstractMethodDescriptor

- (SZMethodType) type
{
	return _type;
}

- (void) setType: (SZMethodType) aValue
{
	_type = aValue;
}

- (NSComparisonResult) compare: (SZAbstractMethodDescriptor*) aDescriptor
{
	if ( aDescriptor != nil )
	{
		return [[self description] compare: [aDescriptor description]];
	}
	
	return NSOrderedDescending;
}

@end

//	===========================================================================
//	Private method(s)
//	---------------------------------------------------------------------------

@implementation SZAbstractMethodDescriptor (PrimitiveMethods)

- (SEL) selector
{
	return NULL;
}

- (char*) signature
{
	return NULL;
}

- (NSString*) normalizeSignatureType: (NSString*) aString
{
	NSMutableString*	aNormalizedString = [NSMutableString string];
	NSCharacterSet*		aSet = [SZTypeDescriptor encodingCharacterSet];
	unsigned int		count = [aString length];
	unsigned int		index = 0;
	
	for ( index = 0; index < count; index++ )
	{
		char	aChar = [aString characterAtIndex: index];
		
            	if ( [aSet characterIsMember: aChar] == YES )
		{
			[aNormalizedString appendFormat: @"%c", aChar]; 
		}
	}
	
	return aNormalizedString;
}

- (SZTypeDescriptor*) returnTypeDescriptor
{
	return nil;
}

- (NSArray*) parameterTypeDescriptors
{
	return nil;
}

@end

//	===========================================================================
//	Description method(s)
//	---------------------------------------------------------------------------

@implementation SZAbstractMethodDescriptor (DescriptionMethods)

- (NSString*) description
{
	NSString*	aPrefix = [self prefix];
	NSString*	aName = [self name];
	
	if ( ( aPrefix != nil ) && ( aName != nil ) )
	{
		return [NSString stringWithFormat: @"%@ %@", aPrefix, aName];
	}

	return [super description];
}

- (NSString*) prefix
{
	NSString*	aPrefix = @"-";
	
	if ( [self type] == SZClassMethodType )
	{
		aPrefix = @"+";
	}
	
	return aPrefix;
}

- (NSString*) name
{
	SEL	aSelector = [self selector];
	
	if ( aSelector != NULL )
	{
		return [NSString stringWithCString: sel_getName( aSelector )];
	}
	
	return nil;
}

- (NSArray*) methodNameComponents
{
	NSString*	aName = [self name];
	
	if ( aName != nil )
	{
		return [[self name] componentsSeparatedByString: SZMethodNameSeparator];
	}
	
	return nil;
}

@end

