//
//	===========================================================================
//
//	Title:		NSMutableAttributedStringAdditions.m
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

#import "NSMutableAttributedStringAdditions.h"

#import <Cocoa/Cocoa.h>

unsigned int			MagicHatMaximumNumberOfLinks = 100;

static unsigned int		_MagicHatDefaultFontSize = 12;
static NSString* const		_MagicHatTab = @"\t";
static NSString* const		_MagicHatNewLine = @"\n";

static NSString* const		_MagicHatReferenceClassName = @"MHController";

static NSFont*			_defaultMagicHatFont = nil;

static NSDictionary*		_defaultMagicHatAttributes = nil;
static NSDictionary*		_defaultMagicHatCommentAttributes = nil;

@implementation NSMutableAttributedString(MagicHatAdditions)

+ (NSMutableAttributedString*) _attributedString
{
	return [[[self alloc] init] autorelease];
}

+ (NSFont*) _defaultMagicHatFont
{
	if ( _defaultMagicHatFont == nil )
	{
		_defaultMagicHatFont = [NSFont fontWithName: @"Courier" size: _MagicHatDefaultFontSize];
	}
	
	return _defaultMagicHatFont;
}

+ (NSColor*) _defaultMagicHatTextColor
{
	return [NSColor blackColor];
}

+ (NSColor*) _defaultMagicHatCommentColor
{
	return [NSColor darkGrayColor];
}

+ (NSColor*) _defaultMagicHatLinkColor
{
	return [NSColor blueColor];
}

+ (NSDictionary*) _defaultMagicHatAttributes
{
	if ( _defaultMagicHatAttributes == nil )
	{
		_defaultMagicHatAttributes = [[NSDictionary alloc] initWithObjectsAndKeys: 
						[self _defaultMagicHatFont], NSFontAttributeName, 
						[self _defaultMagicHatTextColor], NSForegroundColorAttributeName, nil];
	}
	
	return _defaultMagicHatAttributes;
}

+ (NSDictionary*) _defaultMagicHatCommentAttributes
{
	if ( _defaultMagicHatCommentAttributes == nil )
	{
		_defaultMagicHatCommentAttributes = [[NSDictionary alloc] initWithObjectsAndKeys: 
							[self _defaultMagicHatFont], NSFontAttributeName, 
							[self _defaultMagicHatCommentColor], NSForegroundColorAttributeName, nil];
	}
	
	return _defaultMagicHatCommentAttributes;
}

- (void) _appendString: (NSString*) aString withAttributes: (NSDictionary*) someAttributes
{
	if ( aString != nil )
	{
		NSAttributedString*	anAttributedString = [[[NSAttributedString alloc] initWithString: aString attributes: someAttributes] autorelease];
		
		[self appendAttributedString: anAttributedString];
	}
}

- (void) _appendString: (NSString*) aString
{
	if ( aString != nil )
	{
		NSDictionary*	someAttributes = [[self class] _defaultMagicHatAttributes];

		[self _appendString: aString withAttributes: someAttributes];
	}
}

- (void) _appendComment: (NSString*) aString
{
	if ( aString != nil )
	{
		NSDictionary*	someAttributes = [[self class] _defaultMagicHatCommentAttributes];

		[self _appendString: aString withAttributes: someAttributes];
	}
}

- (void) _appendTab
{
	[self _appendString: _MagicHatTab];
}

- (void) _appendNewLine
{
	[self _appendString: _MagicHatNewLine];
}

- (void) _appendLinkWithPath: (NSString*) aPath
{
	NSString*	aName = [aPath lastPathComponent];

	[self _appendLinkWithPath: aPath displayName: aName];
}

- (void) _appendLinkWithPath: (NSString*) aPath displayName: (NSString*) aName
{
	NSURL*		anURL = [NSURL fileURLWithPath: aPath];
	NSDictionary*	someAttributes = [NSDictionary dictionaryWithObjectsAndKeys: 
						[[self class] _defaultMagicHatFont], NSFontAttributeName, 
						[[self class] _defaultMagicHatLinkColor], NSForegroundColorAttributeName, 
						[NSNumber numberWithInt: NSSingleUnderlineStyle], NSUnderlineStyleAttributeName,
						anURL, NSLinkAttributeName, nil];
						
	[self _appendString: aName withAttributes: someAttributes];
}

@end
