//
//	===========================================================================
//
//	Title:		SZTypeDescriptor.h
//	Description:	[Description]
//	Author:		Raphael Szwarc
//	Creation Date:	Tue 09-Nov-1999
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

#import <Foundation/NSObject.h>

@class NSCharacterSet;
@class NSString;
@class SZClassDescriptor;

@interface SZTypeDescriptor : NSObject
{
	@private
	NSString*	_reference;
}

+ (NSCharacterSet*) encodingCharacterSet;

+ (SZTypeDescriptor*) descriptorWithReference: (NSString*) aReference;

- (NSString*) reference;

@end

@interface SZTypeDescriptor(DescriptionMethods)

- (NSString*) name;

- (SZClassDescriptor*) classDescriptor;

@end
