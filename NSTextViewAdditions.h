//
//	===========================================================================
//
//	Title:		NSTextViewAdditions.h
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

#import <AppKit/NSTextView.h>

@interface NSTextView(MagicHatAdditions)

- (NSString*) selectedString;

@end
