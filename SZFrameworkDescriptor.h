//
//	===========================================================================
//
//	Title:		SZFrameworkDescriptor.h
//	Description:	[Description]
//	Author:		Raphael Szwarc
//	Creation Date:	Thu 04-Nov-1999
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
@class NSString;

extern NSString* const SZFrameworkPathExtension;
extern NSString* const SZFrameworkNamePrefix;
extern NSString* const SZFrameworkNameSuffix;

@interface SZFrameworkDescriptor : NSObject
{
	@private
	NSString*	_name;
	NSString*	_path;
	
	BOOL		_didCheckModule;
	BOOL		_didCheckHeader;
	BOOL		_didCheckDocumentation;
	
	NSString*	_moduleName;
	NSString*	_headerPath;
	NSString*	_documentationPath;
}

+ (NSArray*) allFrameworkPaths;

+ (NSArray*) frameworkNames;

+ (NSArray*) classNamesWithFrameworkName: (NSString*) aFrameworkName;

+ (NSString*) frameworkNameForClass: (Class) aClass;

+ (SZFrameworkDescriptor*) descriptorWithName: (NSString*) aName;

@end

@interface SZFrameworkDescriptor(DescriptionMethods)

- (NSString*) name;

- (NSArray*) classDescriptors;

@end

@interface SZFrameworkDescriptor(ResourceMethods)

- (NSString*) path;

- (NSString*) headerPath;

- (NSString*) documentationPath;

@end