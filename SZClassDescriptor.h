//
//	===========================================================================
//
//	Title:		SZClassDescriptor.h
//	Description:	[Description]
//	Author:		Raphael Szwarc
//	Creation Date:	Tue 02-Nov-1999
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

@class NSArray;
@class SZFrameworkDescriptor;

@interface SZClassDescriptor : NSObject
{
	@private
	Class		_reference;
	
	BOOL		_didCheckFramework;
	BOOL		_didCheckHeader;
	BOOL		_didCheckDocumentation;
	
	NSString*	_runtimePath;

	NSString*	_frameworkName;
	NSString*	_headerPath;
	NSString*	_documentationPath;
}

+ (unsigned int) classCount;

+ (NSArray*) classNames;
+ (NSArray*) classNamesLike: (NSString*) aString;
+ (NSArray*) classNamesWithMethodNameLike: (NSString*) aString;

+ (SZClassDescriptor*) descriptorWithName: (NSString*) aClassName;

- (Class) reference;

- (NSComparisonResult) compare: (SZClassDescriptor*) aDescriptor;

@end

@interface SZClassDescriptor(DescriptionMethods)

- (NSString*) name;

- (SZClassDescriptor*) superClassDescriptor;
- (NSArray*) superClassNames;
- (NSArray*) subClassDescriptors;

- (NSArray*) protocolDescriptors;
- (NSArray*) protocolNames;

- (NSArray*) variableDescriptors;

- (NSArray*) classMethodDescriptors;
- (NSArray*) instanceMethodDescriptors;

@end

@interface SZClassDescriptor(CategoryDescriptionMethods)

- (NSArray*) categoryDescriptors;

- (NSArray*) defaultProtocolDescriptors;

- (NSArray*) defaultClassMethodDescriptors;
- (NSArray*) defaultInstanceMethodDescriptors;

@end

@interface SZClassDescriptor(ResourceMethods)

- (NSString*) frameworkName;
- (SZFrameworkDescriptor*) frameworkDescriptor;

- (NSString*) headerPath;

- (NSString*) documentationPath;

@end