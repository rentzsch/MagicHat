//
//	===========================================================================
//
//	Title:		MagicHatService.m
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

#import "MagicHatService.h"

#import "MHController.h"

#import <Foundation/Foundation.h>

@implementation MagicHatService

- (id) init
{
	self = [super init];
	
	[NSApp setServicesProvider: self];
	
	return self;
}

- (void) lookUp: (NSPasteboard*) aPasteboard userData: (NSString*) someData error: (NSString**) anError
 {
	NSArray*	someTypes = [aPasteboard types];

	[[_controller window] makeKeyAndOrderFront: self];

	if ( [someTypes containsObject: NSStringPboardType] == YES )
	{
		NSString*	aName = [aPasteboard stringForType: NSStringPboardType];
		id		anObject = [_controller objectWithName: aName];
		
		//NSLog( @"lookUp: %@",  aName );
		//NSLog( @"lookUp: %@",  anObject );
		
		if ( anObject != nil )
		{
			[_controller displaySimilarObject: anObject];
		}
		else
		{
			NSBeep();
		}
	}
}

@end

