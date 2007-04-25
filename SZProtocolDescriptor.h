//
//	===========================================================================
//
//	Title:		SZProtocolDescriptor.h
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

#import <Foundation/NSObject.h>

@class Protocol;
@class NSArray;
@class SZFrameworkDescriptor;

extern NSString* const SZProtocolNamePrefix;
extern NSString* const SZProtocolNameSuffix;

@interface SZProtocolDescriptor : NSObject
{
	@private
	Protocol*	_reference;

	BOOL		_didCheckFramework;
	BOOL		_didCheckHeader;
	BOOL		_didCheckDocumentation;
	
	NSString*	_runtimePath;

	NSString*	_frameworkName;
	NSString*	_headerPath;
	NSString*	_documentationPath;
}

+ (unsigned int) protocolCount;

+ (NSArray*) protocolNames;
+ (NSArray*) protocolNamesLike: (NSString*) aString;

+ (SZProtocolDescriptor*) descriptorWithReference: (Protocol*) aProtocol;
+ (SZProtocolDescriptor*) descriptorWithName: (NSString*) aName;

- (Protocol*) reference;

- (NSComparisonResult) compare: (SZProtocolDescriptor*) aDescriptor;

@end

@interface SZProtocolDescriptor(DescriptionMethods)

- (NSString*) name;

- (NSArray*) classMethodDescriptors;
- (NSArray*) instanceMethodDescriptors;

- (NSArray*) implementationDescriptors;

@end

@interface SZProtocolDescriptor(ResourceMethods)

- (NSString*) moduleName;
- (NSString*) frameworkName;
- (SZFrameworkDescriptor*) frameworkDescriptor;

- (NSString*) headerPath;

- (NSString*) documentationPath;

@end