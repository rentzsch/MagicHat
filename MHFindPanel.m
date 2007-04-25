//
//  MHFindPanel.m
//  MagicHat
//
//  Created by Raphael Szwarc on Tue Mar 25 2003.
//  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "MHFindPanel.h"

@interface NSString (MHFindPanelTextFindingAdditions)

- (NSRange) findString: (NSString*) aString aSelectedRange: (NSRange) aSelectedRange options: (unsigned int) aMask wrap: (BOOL) shouldWrap;

@end

@implementation NSString (MHFindPanelTextFindingAdditions)

- (NSRange) findString: (NSString*) aString aSelectedRange: (NSRange) aSelectedRange options: (unsigned) options wrap: (BOOL) shouldWrap 
{
	BOOL		forwards = ( options & NSBackwardsSearch ) == 0;
	unsigned	length = [self length];
	NSRange		searchRange;
	NSRange		range;
	
	if ( forwards == YES ) 
	{
		searchRange.location = NSMaxRange( aSelectedRange );
		searchRange.length = length - searchRange.location;
		
		range = [self rangeOfString: aString options: options range: searchRange];
		
		if ( ( range.length == 0 ) && shouldWrap ) 
		{	/* If not found look at the first part of the aString */
			searchRange.location = 0;
			searchRange.length = aSelectedRange.location;
			
			range = [self rangeOfString: aString options: options range: searchRange];
		}
	} 
	else 
	{
		searchRange.location = 0;
		searchRange.length = aSelectedRange.location;
		
		range = [self rangeOfString: aString options: options range: searchRange];
		
		if ( ( range.length == 0 ) && shouldWrap ) 
		{
			searchRange.location = NSMaxRange( aSelectedRange );
			searchRange.length = length - searchRange.location;
			
			range = [self rangeOfString: aString options: options range: searchRange];
		}
	}
	
	return range;
}        

@end

@implementation MHFindPanel

- (NSTextView*) textView
{
	return _textView;
}

- (NSTextField*) textField
{
	return _textField;
}

- (NSTextField*) statusField
{
	return _statusField;
}

- (BOOL) findString: (NSString*) aString inText: (NSTextView*) aTextView options: (unsigned int) aMask
{
	if ( ( aString != nil ) && ( [aString length] > 1 ) )
	{
		NSString*	aText = [aTextView string];
		
		aMask |= NSCaseInsensitiveSearch;
		
		if ( ( aText != nil )  && ( [aText length] > 0 ) )
		{
			NSRange	aSelectedRange = [aTextView selectedRange];
			NSRange	aRange = [aText findString: aString aSelectedRange: aSelectedRange options: aMask wrap: YES];
			
			if ( aRange.length > 0 )
			{
				[aTextView setSelectedRange: aRange];
				[aTextView scrollRangeToVisible: aRange];
				
				return YES;
			}
		}
	}
	
	return NO;
}

- (void) find: (unsigned int) aMask
{
	NSString*	aString = [[self textField] stringValue];
	
	if ( [self findString: aString inText: [self textView] options: aMask] == NO )
	{
		NSBeep();
		
		[[self statusField] setStringValue: @"Not found."];
	}
	else
	{
		[[self statusField] setStringValue: @""];
	}
}

- (IBAction) previous: (id) aSender
{
	[self find: NSBackwardsSearch];
}

- (IBAction) next: (id) aSender
{
	[self find: 0];
}

- (IBAction) nextSelection: (id) aSender
{
	[[self textField] setStringValue: [[self textView] selectedString]];
	
	[self next: self];
}

- (IBAction) scroll: (id) aSender
{
        [[self textView] scrollRangeToVisible: [[self textView] selectedRange] ];
}

@end
