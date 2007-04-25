//
//	===========================================================================
//
//	Title:		SZVariableDescriptorAdditions.m
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

#import "SZVariableDescriptorAdditions.h"

#import "SZTypeDescriptor.h"
#import "SZClassDescriptor.h"

#import <Foundation/NSAttributedString.h>

#import "NSMutableAttributedStringAdditions.h"

@implementation SZVariableDescriptor(MagicHatAdditions)

- (unsigned int) typeDescriptionLength
{
	SZTypeDescriptor*	aTypeDescriptor = [self typeDescriptor];
	int			aLength = 4;
	
	if ( aTypeDescriptor != nil )
	{
		SZClassDescriptor*	aClassDescriptor = [aTypeDescriptor classDescriptor];
	
		if ( aClassDescriptor != nil )
		{
			aLength = aLength + [[aClassDescriptor name] length] + 1;
		}
		else
		{
			aLength = aLength + [[aTypeDescriptor name] length];
		}
	}
	
	return aLength;
}

- (NSAttributedString*) attributedDescription: (int) aCount
{
	NSMutableAttributedString*	aMutableString = [NSMutableAttributedString _attributedString];
	SZTypeDescriptor*		aTypeDescriptor = [self typeDescriptor];
	
	if ( aTypeDescriptor != nil )
	{
		SZClassDescriptor*	aClassDescriptor = [aTypeDescriptor classDescriptor];
	
		if ( aClassDescriptor != nil )
		{
			[aMutableString _appendLinkWithPath: [aClassDescriptor name] displayName: [aClassDescriptor name]];
			[aMutableString _appendString: @"*"];
		}
		else
		{
			[aMutableString _appendString: [aTypeDescriptor name]];
		}
	}
	else
	{
		[aMutableString _appendString: @"?"];
	}
	
	aCount = aCount - [self typeDescriptionLength];
	
	if ( aCount < 4 )
	{
		aCount = 4;
	}
		
	while ( aCount-- )
	{
		[aMutableString _appendString: @" "];
	}
	
	[aMutableString _appendString: [self name]];
	[aMutableString _appendString: @";"];
	
	return aMutableString;
}

@end
