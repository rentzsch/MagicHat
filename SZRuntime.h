//
//	===========================================================================
//
//	Title:		SZRuntime.h
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

#import <objc/objc-class.h>

@class NSSet;
@class Protocol;

@interface SZRuntime : NSObject
{
	@private
}

//+ (void) _invalidateCatagories;
+ (unsigned int) classCount;

+ (NSSet*) classes;
+ (NSSet*) classNames;

@end

@interface SZRuntime(ProtocolRuntimeMethods)

+ (NSSet*) protocols;
+ (NSSet*) protocolNames;

+ (NSSet*) protocolsForClass: (Class) aClass;
+ (NSSet*) protocolNamesForClass: (Class) aClass;

+ (NSSet*) classMethodsForProtocol: (Protocol*) aProtocol;
+ (NSSet*) instanceMethodsForProtocol: (Protocol*) aProtocol;

@end

@interface SZRuntime(VariableRuntimeMethods)

+ (NSSet*) variablesForClass: (Class) aClass;
+ (NSSet*) variableNamesForClass: (Class) aClass;

@end

@interface SZRuntime(MethodRuntimeMethods)

+ (Method) methodNamed: (NSString*) aMethodName forClass: (Class) aClass;

+ (NSSet*) methodsForClass: (Class) aClass;
+ (NSSet*) methodNamesForClass: (Class) aClass;

@end

