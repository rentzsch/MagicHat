//
//	===========================================================================
//
//	Title:		SZProtocolDescriptorAdditions.m
//	Description:	[Description]
//	Author:		Raphael Szwarc
//	Creation Date:	Wed 10-Nov-1999
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

#import "SZProtocolDescriptorAdditions.h"

#import "SZFrameworkDescriptorAdditions.h"
#import "SZClassDescriptorAdditions.h"
#import "SZAbstractMethodDescriptorAdditions.h"

#import <Foundation/NSAttributedString.h>
#import <Foundation/NSArray.h>

#import "NSMutableAttributedStringAdditions.h"

@implementation SZProtocolDescriptor(MagicHatAdditions)

- (NSString*) runtimePath
{
	if ( _runtimePath == nil )
	{
		NSString*	aString = [[self attributedDescription] string];
		NSString*	aPath = NSTemporaryDirectory();
		
		aPath = [aPath stringByAppendingPathComponent: @"MagicHat"];
		
		[[NSFileManager defaultManager] createDirectoryAtPath: aPath attributes: nil];
	
		aPath = [aPath stringByAppendingPathComponent: [NSString stringWithFormat: @"%d", [NSUserName() hash]]];
	
		[[NSFileManager defaultManager] createDirectoryAtPath: aPath attributes: nil];
	
		aPath = [aPath stringByAppendingPathComponent: @"Protocols"];
		
		[[NSFileManager defaultManager] createDirectoryAtPath: aPath attributes: nil];
		
		aPath = [aPath stringByAppendingPathComponent: [self name]];
		aPath = [aPath stringByAppendingPathExtension: @"h"];
		
		[aString writeToFile: aPath atomically: NO];
		
		_runtimePath = [aPath retain];
	}
	
	return _runtimePath;
}

- (void) _appendHeaderToString: (NSMutableAttributedString*) aMutableString
{
	SZFrameworkDescriptor*	aFrameworkDescriptor = [self frameworkDescriptor];
	NSString*		aHeaderPath = [self headerPath];
	NSString*		aDocumentationPath = [self documentationPath];
	
	[aMutableString _appendComment: @"//\tFramework:    \t"];
	
	if ( aFrameworkDescriptor != nil )
	{
		NSString*	aName = [aFrameworkDescriptor name];
		NSString*	aPath = [aFrameworkDescriptor description];

		[aMutableString _appendLinkWithPath: aPath displayName: aName];
	}
	else
	{
		[aMutableString _appendComment: @"Unknown"];
	}
	
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

- (void) _appendInterfaceToString: (NSMutableAttributedString*) aMutableString
{
	[aMutableString _appendString: @"@protocol "];
	[aMutableString _appendString: [self name]];
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

- (void) _appendImplementationsToString: (NSMutableAttributedString*) aMutableString
{
	NSArray*	someDescriptors = [self implementationDescriptors];
	
	if ( someDescriptors != nil )
	{
		unsigned int	count = [someDescriptors count];
		
		[aMutableString _appendComment: @"\n/*\nAdopted By:"];

		if ( count <= 10 )
		{
			unsigned int	index = 0;
		
			[aMutableString _appendNewLine];
			
			for ( index = 0; index < count; index++ )
			{
				SZClassDescriptor*	aDescriptor = [someDescriptors objectAtIndex: index];
			
				[aMutableString _appendTab];
				[aMutableString _appendLinkWithPath: [aDescriptor name] displayName: [aDescriptor name]];
				[aMutableString _appendNewLine];
			}
		}
		else
		{
			NSMutableString*	aString = [NSMutableString string];
			unsigned int		index = 0;
			
			[aMutableString _appendComment: @"\ttoo many classes...\n"];

			for ( index = 0; index < count; index++ )
			{
				SZClassDescriptor*	aDescriptor = [someDescriptors objectAtIndex: index];
			
				[aString appendFormat: @"\t%@\n", [aDescriptor name]];
			}
			
			if ( [aString length] > 0 )
			{
				[aMutableString _appendComment: aString];
			}
		}

		[aMutableString _appendComment: @"*/"];
	}
}

- (NSAttributedString*) attributedDescription
{
	NSMutableAttributedString*	aMutableString = [NSMutableAttributedString _attributedString];
	
	[self _appendHeaderToString: aMutableString];
	[self _appendInterfaceToString: aMutableString];
	[self _appendClassMethodsToString: aMutableString];
	[self _appendInstanceMethodsToString: aMutableString];

	[aMutableString _appendString: @"\n@end\n"];

	//[self _appendImplementationsToString: aMutableString];

	return aMutableString;
}

@end
