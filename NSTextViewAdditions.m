//
//	===========================================================================
//
//	Title:		NSTextViewAdditions.m
//	Description:	[Description]
//	Author:		Raphael Szwarc
//	Creation Date:	Mon 15-Nov-1999
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

#import "NSTextViewAdditions.h"

static NSCursor*	_handCursor = nil;

@implementation NSTextView(MagicHatAdditions)

+ (NSCursor*) handCursor
{
	if ( _handCursor == nil )
	{
		_handCursor = [[NSCursor alloc] initWithImage: [NSImage imageNamed:@"URLTextViewHand"] hotSpot: NSMakePoint( 5.0, 0.0 )];
	}
	
	return _handCursor;
}

- (NSString*) selectedString
{
	NSRange	aSelectedRange = [self selectedRange];
		
	if ( aSelectedRange.length > 0 )
	{
		NSString*	aString = [self string];
			
		if ( aString != nil )
		{
			NSString*	aSelectedString = [aString substringWithRange: aSelectedRange]; 

			return aSelectedString;
		}
	}
	
	return nil;
}

- (void) resetCursorRects
{
	NSRect		visRect;
	NSRange		glyphRange;
	NSRange		charRange;
	NSRange		linkRange;
	NSRectArray	linkRects;
	int		linkCount;
	int		scanLoc;
	int		index;
	NSCursor*	aCursor = [[self class] handCursor];
	
	// Find the range of visible characters
	visRect = [[self enclosingScrollView] documentVisibleRect];
	glyphRange = [[self layoutManager] glyphRangeForBoundingRect:visRect inTextContainer:[self textContainer]];
	charRange = [[self layoutManager] characterRangeForGlyphRange:glyphRange actualGlyphRange:nil];
	
	// Loop through all the visible characters
	scanLoc = charRange.location;
	while( scanLoc < charRange.location + charRange.length )
	{
		// Find the next range of characters with a link attribute
		if( [[self textStorage] attribute:NSLinkAttributeName atIndex:scanLoc effectiveRange:&linkRange] )
		{
			// Get the array of rects represented by an attribute range
			linkRects = [[self layoutManager] rectArrayForCharacterRange:linkRange withinSelectedCharacterRange:linkRange inTextContainer:[self textContainer] rectCount:&linkCount];
			
			// Loop through these rects adding them as cursor rects
			for( index = 0; index < linkCount; index++ )
				[self addCursorRect: NSIntersectionRect( visRect, linkRects[ index ] ) cursor: aCursor];
		}
		
		// Even if we didn't find a link, the range returned tells us where to check next
		scanLoc = linkRange.location + linkRange.length;
	}
}

@end
