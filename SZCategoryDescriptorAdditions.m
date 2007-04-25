//
//	===========================================================================
//
//	Title:		SZCategoryDescriptorAdditions.m
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

#import "SZCategoryDescriptorAdditions.h"

#import "SZProtocolDescriptorAdditions.h"
#import "SZAbstractMethodDescriptorAdditions.h"

#import "NSMutableAttributedStringAdditions.h"

#import <Foundation/NSAttributedString.h>
#import <Foundation/NSArray.h>

//	===========================================================================
//	Constant(s)
//	---------------------------------------------------------------------------

//	===========================================================================
//	Class "variable(s)"
//	---------------------------------------------------------------------------

//	===========================================================================
//	MagicHatAdditions
//	---------------------------------------------------------------------------

@implementation SZCategoryDescriptor(MagicHatAdditions)

- (void) _appendInterfaceToString: (NSMutableAttributedString*) aMutableString
{
	[aMutableString _appendString: @"@interface "];
	[aMutableString _appendString: [self name]];
}

- (void) _appendProtocolsToString: (NSMutableAttributedString*) aMutableString
{
	NSArray*	someProtocols = [self protocolDescriptors];
	
	if ( someProtocols != nil )
	{
		unsigned int	count = [someProtocols count];
		unsigned int	index = 0;
		
		[aMutableString _appendString: @" <"];
	
		for ( index = 0; index < count; index++ )
		{
			SZProtocolDescriptor*	aDescriptor = [someProtocols objectAtIndex: index];
			NSString*		aName = [aDescriptor name];
			NSString*		aPath = [aDescriptor description];
			
			[aMutableString _appendLinkWithPath: aPath displayName: aName];
			
			if ( index < count-1 )
			{
				[aMutableString _appendString: @", "];
			}
		}

		[aMutableString _appendString: @">"];
	}

	[aMutableString _appendNewLine];
}

- (void) _appendClassMethodsToString: (NSMutableAttributedString*) aMutableString
{
	NSArray*	someMethods = [self classMethodDescriptors];
	
	if ( someMethods != nil )
	{
		unsigned int	count = [someMethods count];
		unsigned int	index = 0;
		
		[aMutableString _appendNewLine];

		for ( index = 0; index < count; index++ )
		{
			SZAbstractMethodDescriptor*	aDescriptor = [someMethods objectAtIndex: index];
			
			[aMutableString appendAttributedString: [aDescriptor attributedDescription]];
			[aMutableString _appendNewLine];
		}
	}
}

- (void) _appendInstanceMethodsToString: (NSMutableAttributedString*) aMutableString
{
	NSArray*	someMethods = [self instanceMethodDescriptors];
	
	if ( someMethods != nil )
	{
		unsigned int	count = [someMethods count];
		unsigned int	index = 0;
		
		[aMutableString _appendNewLine];

		for ( index = 0; index < count; index++ )
		{
			SZAbstractMethodDescriptor*	aDescriptor = [someMethods objectAtIndex: index];
			
			[aMutableString appendAttributedString: [aDescriptor attributedDescription]];
			[aMutableString _appendNewLine];
		}
	}
}

- (NSAttributedString*) attributedDescription
{
	NSMutableAttributedString*	aMutableString = [NSMutableAttributedString _attributedString];

	[self _appendInterfaceToString: aMutableString];
	[self _appendProtocolsToString: aMutableString];
	[self _appendClassMethodsToString: aMutableString];
	[self _appendInstanceMethodsToString: aMutableString];

	[aMutableString _appendString: @"\n@end\n"];

	return aMutableString;
}

@end
