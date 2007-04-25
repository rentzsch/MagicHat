//
//	===========================================================================
//
//	Title:		MagicHatPreference.m
//	Description:	[Description]
//	Author:		Raphael Szwarc
//	Creation Date:	Wed 17-Nov-1999
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

#import "MagicHatPreference.h"

#import "SZFrameworkDescriptor.h"

#import <AppKit/AppKit.h>
#import <Foundation/Foundation.h>

static NSString* const		_SZFrameworkDescriptorClassName = @"SZFrameworkDescriptor";
static NSString* const		_SZPrivateFrameworkPath = @"PrivateFrameworks";
static NSString* const		_SZPrivateFrameworkName = @"Private";

static NSString* const		_MagicHatPreferencePanelName = @"MagicHatPreferencePanelFrame";
static NSString* const		_MagicHatAdditionalFrameworksKey = @"MagicHatAdditionalFrameworks";

static unsigned int		_MagicHatDomainCount = 4;
static int			_MagicHatDomains[4] = { NSUserDomainMask, NSLocalDomainMask, NSNetworkDomainMask, NSSystemDomainMask };
static NSString* const		_MagicHatDomainNames[4] = { @"User", @"Local", @"Network", @"System" };
static NSString* const		_MagicHatUnknownDomainName = @"?";

static NSString* const		_MagicHatIsLoadedIndicator = @"*";

static MagicHatPreference*	_defaultPreference = nil;
static BOOL			_didInit = NO;

@implementation MagicHatPreference

+ (MagicHatPreference*) defaultPreference
{
	if ( _defaultPreference == nil )
	{
		_defaultPreference = [[self alloc] init];
	}
	
	return _defaultPreference;
}

+ (id) alloc
{
	if ( _defaultPreference == nil )
	{
		_defaultPreference = [super alloc];
	}
	
	return _defaultPreference;
}

- (void) release
{
}

- (id) autorelease
{
	return self;
}

- (id) init
{
	if ( _didInit == NO )
	{
		[super init];
		
		_didInit = YES;
	}
	
	return self;
}

- (NSArray*) frameworkPaths
{
	if ( _frameworkPaths == nil )
	{
		Class	aClass = NSClassFromString(_SZFrameworkDescriptorClassName);
		
		if ( aClass != NULL )
		{
			_frameworkPaths = [[aClass allFrameworkPaths] retain];
		}
	}
	
	return _frameworkPaths;
}

- (NSMutableArray*) additionalPaths
{
	if ( _additionalPaths == nil )
	{
		NSArray*	somePaths = [[NSUserDefaults standardUserDefaults] arrayForKey: _MagicHatAdditionalFrameworksKey];

		_additionalPaths = [[NSMutableArray alloc] initWithArray: somePaths];
	}
	
	return _additionalPaths;
}

@end

@implementation MagicHatPreference(UIMethods)

- (NSString*) _domainForPath: (NSString*) aPath
{
	if ( aPath != nil )
	{
		unsigned int	index = 0;
		
		aPath = [aPath stringByStandardizingPath];
	
		for ( index = 0; index < _MagicHatDomainCount; index++ )
		{
			NSArray*	someDomainPaths = NSSearchPathForDirectoriesInDomains(NSAllLibrariesDirectory, _MagicHatDomains[index], YES);
		
			if ( someDomainPaths != nil )
			{
				unsigned int	domainPathCount = [someDomainPaths count];
				unsigned int	domainPathIndex = 0;
			
				for ( domainPathIndex = 0; domainPathIndex < domainPathCount; domainPathIndex++ )
				{
					NSString*	aDomainPath = [[someDomainPaths objectAtIndex: domainPathIndex] stringByStandardizingPath];
					
					if ( [aPath hasPrefix: aDomainPath] == YES )
					{
						NSString*	aDomainName = _MagicHatDomainNames[index];
						NSString*	lastPathComponent = [[aPath stringByDeletingLastPathComponent] lastPathComponent];
						
						if ( [lastPathComponent isEqualToString: _SZPrivateFrameworkPath] == YES )
						{
							aDomainName = [NSString stringWithFormat: @"%@: %@", aDomainName, _SZPrivateFrameworkName];
						}
						
						return aDomainName;
					}
				}
			}
		}
	}
	
	return _MagicHatUnknownDomainName;
}


- (BOOL) _isPathLoaded: (NSString*) aPath
{
	if ( aPath != nil )
	{
		NSArray*	someBundles = [NSBundle allFrameworks];
		unsigned int	count = [someBundles count];
		unsigned int	index = 0;
		
		for ( index = 0; index < count; index++ )
		{
			NSBundle*	aBundle = [someBundles objectAtIndex: index];
			NSString*	aBundlePath = [[aBundle bundlePath] stringByStandardizingPath];
			
			if ( [aBundlePath isEqualToString: aPath] == YES )
			{
				return YES;
			}
		}
	}
	
	return NO;
}

- (NSString*) _titleForPath: (NSString*) aPath
{
	if ( aPath != nil )
	{
		NSString*	aName = [[aPath lastPathComponent] stringByDeletingPathExtension];
		NSString*	aDomain = [self _domainForPath: aPath];
		NSString*	aTitle = [NSString stringWithFormat: @"%@: %@", aDomain, aName];
		
		if ( [self _isPathLoaded: aPath] == YES )
		{
			aTitle = [NSString stringWithFormat: @"%@%@", aTitle, _MagicHatIsLoadedIndicator];
		}
		
		return aTitle;
	}

	return nil;
}

- (BOOL) _isPathSelected: (NSString*) aPath
{
	if ( aPath != nil )
	{
		return [[self additionalPaths] containsObject: aPath];
	}
	
	return NO;
}

- (void) awakeFromNib
{
	NSMatrix*	aMatrix = [self matrix];
	NSArray*	somePaths = [self frameworkPaths];
	unsigned int	count = [somePaths count];
	unsigned int	index = 0;
	
	[[self panel] setFrameAutosaveName: _MagicHatPreferencePanelName];

	[aMatrix renewRows: count columns: 1];
	
	for ( index = 0; index < count; index++ )
	{
		NSButtonCell*	aCell = [aMatrix cellAtRow: index column: 0];
		NSString*	aPath = [somePaths objectAtIndex: index];
		NSString*	aTitle = [self _titleForPath: aPath];
		
		[aCell setTitle: aTitle];
		[aCell setAction: @selector(select:)];
		[aCell setTarget: self];
		
		if ( [self _isPathSelected: aPath] == YES )
		{
			[aCell setNextState];
		}
	}
	
	[aMatrix sizeToFit];
}

- (void) select: (id) aSender
{
	NSButtonCell*	aCell = [aSender selectedCell];
	unsigned int	index = [aSender selectedRow];
	NSMutableArray*	somePaths = [self additionalPaths];
	NSString*	aPath = [[self frameworkPaths] objectAtIndex: index];
	
	if ( [aCell state] == YES )
	{
		[somePaths addObject: aPath];
	}
	else
	{
		[somePaths removeObject: aPath];
	}
	
	[[NSUserDefaults standardUserDefaults] setObject: somePaths forKey: _MagicHatAdditionalFrameworksKey];
}

- (NSMatrix*) matrix
{
	return _matrix;
}

- (NSPanel*) panel
{
	if ( _panel == nil )
	{
		[NSBundle loadNibNamed: NSStringFromClass([self class]) owner: self];
	}

	return _panel;
}

- (IBAction) display: (id) aSender
{
	[[self panel] makeKeyAndOrderFront: self];
}

@end
