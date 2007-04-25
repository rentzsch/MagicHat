//
//  MHTextViewDelegate.m
//  MagicHat
//
//  Created by Raphael Szwarc on Wed Mar 19 2003.
//  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "MHTextViewDelegate.h"


@implementation MHTextViewDelegate

- (MHController*) controller
{
	return _controller;
}

- (NSTextView*) textView
{
	return _textView;
}

@end

@implementation MHTextViewDelegate (NSNibAwaking)

- (void) awakeFromNib
{
	//[[[self textView] enclosingScrollView] setDocumentCursor: [NSCursor arrowCursor]];
}

@end


@implementation MHTextViewDelegate (NSTextViewDelegate)

- (void) displayURL: (NSURL*) anURL
{
	if ( anURL != nil )
	{
		NSString*	aName = [[anURL path] lastPathComponent];
		NSString*	aPathExtension = [aName pathExtension];
		id		anObject = anURL;
		
		//NSLog( @"displayURL: aName: %@", aName );
		//NSLog( @"displayURL: aPathExtension: %@", aPathExtension );
	
		if ( ( aPathExtension == nil ) || ( [aPathExtension length] == 0 ) )
		{
			anObject = [[self controller] objectWithName: aName];
		}

		if ( ( [[anURL scheme] isEqual: NSURLFileScheme] == YES ) &&
			( [aPathExtension isEqual: @"pdf"] == NO ) )
		{
			[[self controller] displayObject: anObject];
		}
		else
		{
			[[NSWorkspace sharedWorkspace] openURL: anURL];
		}
	}
}

- (BOOL) textView: (NSTextView*) aTextView clickedOnLink: (id) aLink atIndex: (unsigned) charIndex
{
	//NSLog( @"aLink: '%@'", aLink );
	//NSLog( @"aLink: '%@'", NSStringFromClass( [aLink class] ) );

	if ( [aLink isKindOfClass: [NSURL class]] == YES )
	{
		[self displayURL: aLink];
	}
	else
	{
		NSString*	anAnchor = nil;
		int		anIndex = 0;
				
		if ( [aLink hasPrefix: @"#"] == YES )
		{
			NSTextView*	aText = [self textView];
			NSRange		aRange = NSMakeRange(charIndex, 0);
		
			aRange = [aText selectionRangeForProposedRange: aRange granularity: NSSelectByWord];
	
			anAnchor = [[aText string] substringWithRange: aRange];
		
			anIndex = aRange.location + aRange.length;
		}
		else
		{
			NSURL*	aCurrentURL = [[self controller] currentObject];
			NSURL*	anURL = [[NSURL URLWithString: aLink relativeToURL: aCurrentURL] absoluteURL];
			
			anAnchor = [anURL fragment];
			
			[self displayURL: anURL];
		}
		
		if ( anAnchor != nil )
		{
			NSTextView*	aText = [self textView];
			NSRange		aSearchRange = NSMakeRange(anIndex, [[[self textView] string] length] - anIndex);
			NSRange		aRange = [[aText string] rangeOfString: anAnchor options: NSLiteralSearch range: aSearchRange];
	
			if ( aRange.location == NSNotFound )
			{
				aSearchRange = NSMakeRange( 0, [[[self textView] string] length] );
				aRange = [[aText string] rangeOfString: anAnchor options: NSLiteralSearch range: aSearchRange];
			}
			
			if ( aRange.location != NSNotFound )
			{
				[[self textView] setSelectedRange: aRange];
				[[self textView] scrollRangeToVisible: aRange];
			}
		}
	}
	
	return YES;
}

@end
