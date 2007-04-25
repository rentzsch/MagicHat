//
//	===========================================================================
//
//	Title:		SZFrameworkDescriptorAdditions.m
//	Description:	[Description]
//	Author:		Raphael Szwarc
//	Creation Date:	Fri 12-Nov-1999
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

#import "SZFrameworkDescriptorAdditions.h"

#import "SZClassDescriptorAdditions.h"
#import "NSMutableAttributedStringAdditions.h"

#import <Foundation/NSArray.h>
#import <Foundation/NSBundle.h>
#import <Foundation/NSString.h>
#import <Foundation/NSUserDefaults.h>

#import <Foundation/NSException.h>

NSString* const	MagicHatAdditionalFrameworksKey = @"MagicHatAdditionalFrameworks";

@implementation SZFrameworkDescriptor(MagicHatAdditions)

+ (void) loadAdditionalFrameworks
{
	//NSArray*	somePaths = [self allFrameworkPaths];
	NSArray*	somePaths = [[NSUserDefaults standardUserDefaults] arrayForKey: MagicHatAdditionalFrameworksKey];
	
	if ( somePaths != nil )
	{
                NSFileManager*  aManager = [NSFileManager defaultManager];
		unsigned int	count = [somePaths count];
		unsigned int	index = 0;
	
		for ( index = 0; index < count; index++ )
		{
			NSString*	aPath = [somePaths objectAtIndex: index];
                        BOOL            isDirectory = NO;
                        
                        if ( ( [aManager fileExistsAtPath: aPath isDirectory: &isDirectory] == YES ) &&
                            ( isDirectory == YES ) )
                        {
                                NS_DURING
                                {
                                        NSBundle*	aBundle = [NSBundle bundleWithPath: aPath];
                                        [aBundle load];
                                }
                                NS_HANDLER
                                {
                                        //NSLog(@"(Warning) %@", localException);
                                }
                                NS_ENDHANDLER;
                        }
		}
	}
}

- (void) _appendHeaderToString: (NSMutableAttributedString*) aMutableString
{
	NSString*	aHeaderPath = [self headerPath];
	NSString*	aDocumentationPath = [self documentationPath];
	
	[aMutableString _appendComment: @"//\tFramework:     \t"];
	[aMutableString _appendComment: [self name]];
	[aMutableString _appendNewLine];
	[aMutableString _appendComment: @"//\tHeader:       \t"];

	if ( aHeaderPath != nil )
	{
		[aMutableString _appendLinkWithPath: aHeaderPath];
	}
	else
	{
		[aMutableString _appendComment: @"Unknown"];
	}
	
	[aMutableString _appendNewLine];

	[aMutableString _appendComment: @"//\tDocumentation:\t"];

	if ( aDocumentationPath != nil )
	{
		[aMutableString _appendLinkWithPath: aDocumentationPath];
	}
	else
	{
		[aMutableString _appendComment: @"Unknown"];
	}

	[aMutableString _appendNewLine];
	[aMutableString _appendNewLine];
}

- (void) _appendClassesToString: (NSMutableAttributedString*) aMutableString
{
	NSArray*	someClasses = [self classDescriptors];
	
	if ( someClasses != nil )
	{
		unsigned int	count = [someClasses count];
		
		[aMutableString _appendComment: [NSString stringWithFormat: @"//\tDefines %d classes", count]];
	}
}

- (NSAttributedString*) attributedDescription
{
	NSMutableAttributedString*	aMutableString = [NSMutableAttributedString _attributedString];
	
	[self _appendHeaderToString: aMutableString];
	[self _appendClassesToString: aMutableString];

	return aMutableString;
}

@end
