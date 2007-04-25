//
//  NSURLAdditions.m
//  MagicHat
//
//  Created by Raphael Szwarc on Wed Mar 19 2003.
//  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "NSURLAdditions.h"


@implementation NSURL (MagicHatAdditions)

- (NSAttributedString*) attributedDescription
{
	NSMutableDictionary*		someAttributes = nil;
	NSMutableAttributedString*	aString = [[[NSMutableAttributedString alloc] initWithURL: self documentAttributes: &someAttributes ] autorelease];
	
	if ( [[someAttributes objectForKey: @"DocumentType"] isEqual: @"NSPlainText"] == YES )
	{
		[someAttributes setObject: [NSMutableAttributedString _defaultMagicHatFont] forKey: NSFontAttributeName];
		
		[aString setAttributes: someAttributes range: NSMakeRange( 0, [aString length] )];
	}
	
	return aString;
}

@end
