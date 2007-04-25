//
//	===========================================================================
//
//	Title:		SZMethodDescriptor.h
//	Description:	[Description]
//	Author:		Raphael Szwarc
//	Creation Date:	Wed 03-Nov-1999
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

#import "SZAbstractMethodDescriptor.h"

#import <objc/objc-class.h>

@class NSString;
@class NSArray;

@interface SZMethodDescriptor : SZAbstractMethodDescriptor
{
	@private
	Method	_reference;
}

+ (SZMethodDescriptor*) classDescriptorWithReference: (Method) aReference;
+ (SZMethodDescriptor*) instanceDescriptorWithReference: (Method) aReference;

- (Method) reference;

@end
