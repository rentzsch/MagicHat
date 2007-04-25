//
//	===========================================================================
//
//	Title:		SZClassDescriptorAdditions.m
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

#import "SZClassDescriptorAdditions.h"

#import "SZFrameworkDescriptorAdditions.h"
#import "SZProtocolDescriptorAdditions.h"
#import "SZVariableDescriptorAdditions.h"
#import "SZAbstractMethodDescriptorAdditions.h"
#import "SZCategoryDescriptorAdditions.h"

#import "NSMutableAttributedStringAdditions.h"

#import <Foundation/NSAttributedString.h>
#import <Foundation/NSArray.h>

@implementation SZClassDescriptor(MagicHatAdditions)

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
	
		aPath = [aPath stringByAppendingPathComponent: @"Classes"];
		
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
	
	//NSLog( @"%@ %@", NSStringFromSelector( _cmd), self );

	[aMutableString _appendComment: @"//\tFramework:     \t"];

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
	SZClassDescriptor*	aSuperClass = [self superClassDescriptor];

	//NSLog( @"%@ %@", NSStringFromSelector( _cmd), self );

	[aMutableString _appendString: @"@interface "];
	[aMutableString _appendString: [self name]];
	
	if ( aSuperClass != nil )
	{
		[aMutableString _appendString: @" : "];

		[aMutableString _appendLinkWithPath: [aSuperClass name] displayName: [aSuperClass name]];
	}
}

- (void) _appendProtocolsToString: (NSMutableAttributedString*) aMutableString
{
	NSArray*	someProtocols = [self defaultProtocolDescriptors];
	
	//NSLog( @"%@ %@", NSStringFromSelector( _cmd), self );

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

- (void) _appendVariablesToString: (NSMutableAttributedString*) aMutableString
{
	NSArray*	someVariables = [self variableDescriptors];
	
	//NSLog( @"%@ %@", NSStringFromSelector( _cmd), self );

	[aMutableString _appendString: @"{\n"];
	
	if ( someVariables != nil )
	{
		unsigned int	count = [someVariables count];
		unsigned int	index = 0;
		unsigned int	aLength = 0;
		
		if ( count > 1 )
		{
			for ( index = 0; index < count; index++ )
			{
				SZVariableDescriptor*	aDescriptor = [someVariables objectAtIndex: index];
				unsigned int		aTypeLength = [aDescriptor typeDescriptionLength];
				
				if ( aTypeLength > aLength )
				{
					aLength = aTypeLength;
				}
			}
			
			aLength = aLength + 4;
		}
		
		for ( index = 0; index < count; index++ )
		{
			SZVariableDescriptor*	aDescriptor = [someVariables objectAtIndex: index];
			
			[aMutableString _appendTab];
			[aMutableString appendAttributedString: [aDescriptor attributedDescription: aLength]];
			[aMutableString _appendNewLine];
		}
	}
	
	[aMutableString _appendString: @"}\n"];
}

- (void) _appendClassMethodsToString: (NSMutableAttributedString*) aMutableString
{
	NSArray*	someMethods = [self defaultClassMethodDescriptors];
	
	//NSLog( @"%@ %@", NSStringFromSelector( _cmd), self );

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
	NSArray*	someMethods = [self defaultInstanceMethodDescriptors];
	
	//NSLog( @"%@ %@", NSStringFromSelector( _cmd), self );

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

- (void) _appendCategoriesToString: (NSMutableAttributedString*) aMutableString
{
	NSArray*	someCategories = [self categoryDescriptors];
	
	if ( someCategories != nil )
	{
		unsigned int	count = [someCategories count];
		unsigned int	index = 0;
		
		[aMutableString _appendNewLine];

		for ( index = 0; index < count; index++ )
		{
			SZCategoryDescriptor*	aDescriptor = [someCategories objectAtIndex: index];
			
			[aMutableString appendAttributedString: [aDescriptor attributedDescription]];
			[aMutableString _appendNewLine];
		}
	}
}

- (NSAttributedString*) attributedDescription
{
	NSMutableAttributedString*	aMutableString = [NSMutableAttributedString _attributedString];

	//NSLog( @"%@ %@", NSStringFromSelector( _cmd), self );

	[self _appendHeaderToString: aMutableString];
	[self _appendInterfaceToString: aMutableString];
	[self _appendProtocolsToString: aMutableString];
	[self _appendVariablesToString: aMutableString];
	[self _appendClassMethodsToString: aMutableString];
	[self _appendInstanceMethodsToString: aMutableString];
	
	[aMutableString _appendString: @"\n@end\n"];

	[self _appendCategoriesToString: aMutableString];


	return aMutableString;
}

@end
