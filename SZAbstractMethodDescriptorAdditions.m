//
//	===========================================================================
//
//	Title:		SZAbstractMethodDescriptorAdditions.m
//	Description:	[Description]
//	Author:		Raphael Szwarc
//	Creation Date:	Fri 05-Nov-1999
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

#import "SZAbstractMethodDescriptor.h"

#import "SZTypeDescriptor.h"

#import <Foundation/NSAttributedString.h>
#import <Foundation/NSArray.h>

#import "NSMutableAttributedStringAdditions.h"

@implementation SZAbstractMethodDescriptor(MagicHatAdditions)

- (NSAttributedString*) attributedDescription
{
	NSMutableAttributedString*	aMutableString = [NSMutableAttributedString _attributedString];
	NSString*			aPrefix = [self prefix];
	NSArray*			someNameComponents = [self methodNameComponents];
	unsigned int			nameComponentCount = [someNameComponents count];
	SZTypeDescriptor*		aReturnTypeDescriptor = [self returnTypeDescriptor];
	
	[aMutableString _appendString: aPrefix];

	if ( aReturnTypeDescriptor != nil )
	{
		[aMutableString _appendString: [NSString stringWithFormat: @" (%@) ", [aReturnTypeDescriptor name]]];
	}
	
	if ( nameComponentCount == 1 )
	{
		[aMutableString _appendString: [self name]];
	}
	else
	if ( nameComponentCount > 1 )
	{
		NSArray*	someParameterDescriptors = [self parameterTypeDescriptors];
		unsigned int	parameterCount = [someParameterDescriptors count];
		
		[aMutableString _appendString: [someNameComponents objectAtIndex: 0]];
		[aMutableString _appendString: @":"];
		
		if ( nameComponentCount == ( parameterCount + 1 ) )
		{
			unsigned int	index = 0;
		
			for ( index = 0; index < parameterCount; index++ )
			{
				NSString*		aName = [someNameComponents objectAtIndex: index + 1];
				NSString*		aParameterName = [NSString stringWithFormat: @"parameter%i", index + 1];
				SZTypeDescriptor*	aTypeDescriptor = [someParameterDescriptors objectAtIndex: index];
			
				[aMutableString _appendString: [NSString stringWithFormat: @" (%@)", [aTypeDescriptor name]]];
				[aMutableString _appendComment: [NSString stringWithFormat: @" %@", aParameterName]];
				
				if ( index < ( parameterCount - 1 ) )
				{
					[aMutableString _appendString: [NSString stringWithFormat: @" %@:", aName]];
				}
			}
		}
		else
		{
			//NSLog(@"*** %i != %i ***", nameComponentCount, ( parameterCount + 1 ));
			//NSLog(@"%@", [self name]);
			//NSLog(@"%s", [self signature]);
			//NSLog(@"%@", someNameComponents);
			//NSLog(@"%@", someParameterDescriptors);
			
			[aMutableString _appendComment: @" /* ??? Method signature does not match selector !!! */ "];
		}
	}
	
	[aMutableString _appendString: @";"];
	
	return aMutableString;
}

@end
