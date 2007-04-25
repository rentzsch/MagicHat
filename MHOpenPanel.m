//
//  MHOpenPanel.m
//  MagicHat
//
//  Created by Raphael Szwarc on Thu Mar 20 2003.
//  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "SZClassDescriptor.h"
#import "SZClassHierarchyDescriptor.h"

#import "MHController.h"

#import "MHOpenPanel.h"

@implementation MHOpenPanel

- (id) init
{
	self = [super init];
		
	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(bundleDidLoad:) name: NSBundleDidLoadNotification object: nil];
		
	return self;
}

- (void) bundleDidLoad: (NSNotification*) aNotification
{
	//NSLog(@"Did load bundle: %@", [aNotification object]);

	[[self browser] loadColumnZero];
}

- (MHController*) controller
{
	return _controller;
}

- (NSString*) path
{
	MHController*	aController = [self controller];
	id		aDescriptor = [aController descriptorForObject: [aController currentObject]];
	
	if ( ( aDescriptor != nil ) && ( [aDescriptor isKindOfClass: [SZClassDescriptor class]] == YES ) )
	{
		NSMutableString*	aString = [NSMutableString stringWithFormat: @"/%@", [aDescriptor description]];
		SZClassDescriptor*	aSuperClass = nil;
		
		while ( ( aSuperClass = [aDescriptor superClassDescriptor] ) != nil )
		{
			[aString insertString: [aSuperClass description] atIndex: 0];
			[aString insertString: @"/" atIndex: 0];
			
			aDescriptor = aSuperClass;
		}
		
		//NSLog( @"path: %@", aString );
		
		return aString;
	}
	
	return @"/NSObject";
}

- (void) openInWindow: (NSWindow*) aWindow
{
	NSPanel*	aPanel = [self panel];
	NSBrowser*	aBrowser = [self browser];
	NSString*	aPath = [self path];
	
	[aBrowser setPath: aPath];
	[aBrowser scrollColumnToVisible: [aBrowser selectedColumn]];
	[[self textField] setStringValue: [aPath lastPathComponent]];

	[NSApp beginSheet: aPanel
		modalForWindow: aWindow
		modalDelegate: nil
		didEndSelector: nil
		contextInfo: nil];
		
	[NSApp runModalForWindow: aPanel];
	
	[NSApp endSheet: aPanel];
	[aPanel orderOut: self];
}

@end

@implementation MHOpenPanel(NSNibAwaking)

- (void) awakeFromNib
{
	NSBrowser*	aBrowser = [self browser];
	
	[[self panel] setFrameAutosaveName: @"MagicHatOpenPanelFrame"];

	[aBrowser setTarget: self];
	[aBrowser setDoubleAction: @selector(open:)];

	[aBrowser setMaxVisibleColumns: 4];
	[aBrowser setMinColumnWidth: NSWidth( [aBrowser bounds] ) / (float) 3 ];
}

@end

@implementation MHOpenPanel(UIComponents)

- (NSPanel*) panel
{
	return _panel;
}

- (NSBrowser*) browser
{
	return _browser;
}

- (NSTextField*) textField
{
	return _textField;
}

- (NSButton*) cancelButton
{
	return _cancelButton;
}

- (NSButton*) openButton
{
	return _openButton;
}

@end

@implementation MHOpenPanel(UIActions)

- (IBAction) cancel: (id) aSender
{
	[NSApp stopModal];
}

- (IBAction) open: (id) aSender
{
	NSString*	aName = [[[self browser] path] lastPathComponent];
	id		anObject = [[self controller] objectWithName: aName];

	[self cancel: self];
	
	if ( anObject != nil )
	{
		[[self controller] performSelector: @selector(displaySimilarObject:) withObject: anObject afterDelay: 0];

		//[[self controller] displaySimilarObject: anObject];
	}
}

- (IBAction) didSelect: (id) aSender
{
	[[self textField] setStringValue: [[[self browser] path] lastPathComponent]];
}

@end

@implementation MHOpenPanel(NSBrowserDelegate)

- (int) browser: (NSBrowser*) aBrowser numberOfRowsInColumn: (int) aColumn
{
	if ( aColumn == 0 )
	{
		return [[SZClassHierarchyDescriptor rootClassNames] count];
	}
	else
	{
		NSString*	aName = [[aBrowser pathToColumn: aColumn] lastPathComponent];
		NSArray*	someDescriptors = [[SZClassDescriptor descriptorWithName: aName] subClassDescriptors];
		
		if ( someDescriptors != nil )
		{
			return [someDescriptors count];
		}
	}

	return 0;
}

- (void) browser: (NSBrowser*) aBrowser willDisplayCell: (id) aCell atRow: (int) aRow column: (int) aColumn
{
	if ( aColumn == 0 )
	{
		NSString*		aName = [[SZClassHierarchyDescriptor rootClassNames] objectAtIndex: aRow];
		SZClassDescriptor*	aDescriptor = [SZClassDescriptor descriptorWithName: aName];
		
		[aCell setStringValue: aName];

		if ( [aDescriptor subClassDescriptors] == nil )
		{
			[aCell setLeaf: YES];
		}
	}
	else
	{
		NSString*		aName = [[aBrowser pathToColumn: aColumn] lastPathComponent];
		NSArray*		someDescriptors = [[SZClassDescriptor descriptorWithName: aName] subClassDescriptors];
		SZClassDescriptor*	aDescriptor = [someDescriptors objectAtIndex: aRow];
		
		[aCell setStringValue: [aDescriptor description]];
		
		if ( [aDescriptor subClassDescriptors] == nil )
		{
			[aCell setLeaf: YES];
		}
	}
}

@end
