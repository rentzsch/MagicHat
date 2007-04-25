//
//  MHController.m
//  MagicHat
//
//  Created by Raphael Szwarc on Mon Mar 17 2003.
//  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "SZClassDescriptor.h"
#import "SZProtocolDescriptor.h"
#import "SZFrameworkDescriptor.h"
#import "SZMethodDescriptor.h"

#import "MHCache.h"
#import "MHComboBoxDelegate.h"
#import "MHTextViewDelegate.h"
#import "MHOpenPanel.h"
#import "MagicHatPreference.h"

#import "MHController.h"


//	===========================================================================
//	Class "variable(s)"
//	---------------------------------------------------------------------------

@implementation MHController

- (id) init
{
	self = [super init];
		
	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(bundleDidLoad:) name: NSBundleDidLoadNotification object: nil];
	
	return self;
}

- (void) bundleDidLoad: (NSNotification*) aNotification
{
	//NSLog(@"Did load bundle: %@", [aNotification object]);

	[self setDataSource: nil];
	[self setCurrentDescriptor: nil];
	[[self cache] removeAllObjects];
}

- (NSArray*) dataSource
{
	if ( _dataSource == nil )
	{
		NSMutableArray*	anArray = [NSMutableArray arrayWithArray: [SZClassDescriptor classNames]]; 

		[anArray addObjectsFromArray: [SZProtocolDescriptor protocolNames]];
		
		[self setDataSource: anArray];
	}
	
	return _dataSource;
}

- (void) setDataSource: (NSArray*) aValue
{
	[_dataSource autorelease];
	
	_dataSource = [aValue retain];
}

- (NSUndoManager*) undoManager
{
	if ( _undoManager == nil )
	{
		_undoManager = [[NSUndoManager alloc] init];
		
		[_undoManager setGroupsByEvent: NO];
		[_undoManager setLevelsOfUndo: 1000];
	}
	
	return _undoManager;
}

- (id) currentDescriptor
{
	return _currentDescriptor;
}

- (void) setCurrentDescriptor: (id) aValue
{
	[_currentDescriptor autorelease];
	_currentDescriptor = [aValue retain];
}

- (id) currentObject
{
	return _currentObject;
}

- (void) setCurrentObject: (id) aValue
{
	if ( [aValue isEqual: _currentObject] == NO )
	{
		if ( _currentObject != nil )
		{
			NSUndoManager*	aManager = [self undoManager];
			
			[aManager beginUndoGrouping];
			[aManager setActionName: [_currentObject description]];
			[aManager registerUndoWithTarget: self selector: @selector(displayObject:) object: _currentObject];
			[aManager endUndoGrouping];
		}

		[_currentObject autorelease];
		_currentObject = [aValue retain];
	}
	
	[self setCurrentDescriptor: [self descriptorForObject: _currentObject]];
}

- (id) objectWithName: (NSString*) aName
{
	if ( aName != nil )
	{
		if ( [aName hasPrefix: SZProtocolNamePrefix] == YES )
		{
			return [SZProtocolDescriptor descriptorWithName: aName];
		}

		if ( [aName hasPrefix: SZFrameworkNamePrefix] == YES )
		{
			return [SZFrameworkDescriptor descriptorWithName: aName];
		}

		return [SZClassDescriptor descriptorWithName: aName];
	}
	
	return nil;
}

- (NSString*) titleForObject: (id) anObject
{
	if ( [anObject isKindOfClass: [NSURL class]] == YES )
	{
		NSString*	aName = [[anObject path] lastPathComponent];
		
		return aName;
	}
	
	return [anObject description];
}

- (id) descriptorForObject: (id) anObject
{
	if ( [anObject isKindOfClass: [NSURL class]] == YES )
	{
		NSString*	aName = [[[anObject path] lastPathComponent] stringByDeletingPathExtension];
		
		if ( [[anObject path] rangeOfString: @"/Protocols/"].location != NSNotFound )
		{
			return [SZProtocolDescriptor descriptorWithName: aName];
		}
		
		return [self objectWithName: aName];
	}
	
	return anObject;
}

- (MHCache*) cache
{
	if ( _cache == nil )
	{
		_cache = [[MHCache alloc] initWithCapacity: 150];
	}
	
	return _cache;
}

- (id) cacheKeyForObject: (id) anObject
{
	if ( [anObject isKindOfClass: [NSURL class]] == YES )
	{
		return [anObject path];
	}

	return [anObject description];
}

- (NSAttributedString*) attributedDescriptionForObject: (id) anObject
{
	MHCache*		aCache = [self cache];
	NSString*		aKey = [self cacheKeyForObject: anObject];
	NSAttributedString*	aString = [aCache objectForKey: aKey];
	
	if ( aString == nil )
	{
		aString = [anObject attributedDescription];
		[aCache setObject: aString forKey: aKey];
	}
	
	return aString;
}

- (void) displayObject: (id) anObject
{
	//NSLog( @"%@ %@", NSStringFromSelector( _cmd ), anObject );

	[[self window] makeKeyAndOrderFront: self];
	
	if ( ( anObject != nil ) && ( [[self currentObject] isEqual: anObject] == NO ) )
	{
		NSTextView*	aTextView = [[self textViewDelegate] textView];
		NSTextStorage*	aTextStorage = [aTextView textStorage];
		BOOL		didSucceed = YES;
		
		[[self progressIndicator] startAnimation: self];
		
		[aTextStorage beginEditing];

		NS_DURING

		[aTextStorage setAttributedString: [self attributedDescriptionForObject: anObject]];
		
		NS_HANDLER
		
		NSLog( @"%@", localException );
		NSLog( @"%@", anObject );
		
		didSucceed = NO;
		
		NSBeep();
		
		NS_ENDHANDLER

		[aTextStorage endEditing];
		
		[aTextView didChangeText];
		
		if ( didSucceed == YES )
		{
			[aTextView scrollRangeToVisible: NSMakeRange (0, 0)];
	
			if ( [[self currentDescriptor] isEqual: [self descriptorForObject: anObject]] == NO )
			{
				[self validatePopUp: anObject];
				[self validateButtons: anObject];
				[[self drawer] validate: anObject];
			}
			
			[self validateTitle: anObject];
			
			[self setCurrentObject: anObject];
		}
		
		[[self progressIndicator] stopAnimation: self];
	}

	//NSLog( @"displayObject done" );
}

- (void) displaySimilarObject: (id) anObject
{
	id	aCurrentObject = [self currentObject];
	
	if ( ( aCurrentObject != nil ) && ( [aCurrentObject isKindOfClass: [NSURL class]] == YES ) )
	{
		NSString*	anExtension = [[aCurrentObject path] pathExtension];
		NSString*	aPath = nil;
		
		if ( [anExtension isEqualTo: @"h"] == YES )
		{
			aPath = [anObject headerPath];
		}
		else
		if ( [anExtension isEqualTo: @"html"] == YES )
		{
			aPath = [anObject documentationPath];
		}
		
		if ( aPath != nil )
		{
			anObject = [NSURL fileURLWithPath: aPath];
		}
	}
	
	[self displayObject: anObject];
}


@end

@implementation MHController (NSNibAwaking)

- (void) awakeFromNib
{
	NSProgressIndicator*	anIndicator = [self progressIndicator];
	
	_progressIndicator = nil;
	
	[SZFrameworkDescriptor loadAdditionalFrameworks];
	[[self window] setFrameAutosaveName: @"MagicHatMainWindowFrame"];

	[anIndicator setDisplayedWhenStopped: NO];
	[anIndicator setStyle: NSProgressIndicatorSpinningStyle];	
	
	[[[self popUpButton] cell] setBezelStyle: NSSmallIconButtonBezelStyle];
	[[[self popUpButton] cell] setArrowPosition: NSPopUpArrowAtBottom];
	[[[self popUpButton] cell] setBordered: NO];
	[[[self popUpButton] cell] setBezeled: NO];
	[[self popUpButton] sizeToFit];
	[[self popUpButton] setAutoenablesItems: NO];
	
	[self displayObject: [self objectWithName: @"NSObject"]];
	
	_progressIndicator = anIndicator;
}

@end

@implementation MHController (UIComponents)

- (MHComboBoxDelegate*) comboBoxDelegate
{
	return _comboBoxDelegate;
}

- (MHTextViewDelegate*) textViewDelegate
{
	return _textViewDelegate;
}

- (MHDrawer*) drawer
{
	return _drawer;
}

- (MHOpenPanel*) openPanel
{
	return _openPanel;
}

- (NSProgressIndicator*) progressIndicator
{
	return _progressIndicator;
}

- (NSButton*) previousButton
{
	return _previousButton;
}

- (NSButton*) nextButton
{
	return _nextButton;
}

- (NSPopUpButton*) popUpButton
{
	return _popUpButton;
}

- (NSWindow*) window
{
	return _window;
}

@end

@implementation MHController (UIValidation)

- (void) validatePopUp: (id) anObject
{
	NSPopUpButton*	aPopUp = [self popUpButton];
	NSString*	aTitle = [aPopUp titleOfSelectedItem];
	id		aDescriptor = [self descriptorForObject: anObject];
	
	//NSLog( @"aTitle: %@", aTitle );
	
	[aPopUp removeAllItems];
	
	if ( ( aDescriptor != nil ) &&
		( [aDescriptor respondsToSelector: @selector(classMethodDescriptors)] == YES ) )
	{
		NSMutableArray*	someMethods = [NSMutableArray array];
		
		 if (  [aDescriptor classMethodDescriptors] != nil )
		 {
			[someMethods addObjectsFromArray: [aDescriptor classMethodDescriptors]];
		 }
		 
		 if (  [aDescriptor instanceMethodDescriptors] != nil )
		 {
			[someMethods addObjectsFromArray: [aDescriptor instanceMethodDescriptors]];
		 }
		 
		 if ( [someMethods count] > 0 )
		 {
			int	count = [someMethods count];
			int	index = 0;
			
			[aPopUp addItemWithTitle: [NSString stringWithFormat: @"%d methods", count]];

			for ( index = 0; index < count; index++ )
			{
				SZMethodDescriptor*	aMethod = [someMethods objectAtIndex: index];
				NSMenuItem*		anItem = nil;
				
				[aPopUp addItemWithTitle: [aMethod description]];
				
				anItem = [aPopUp lastItem];
				[anItem setRepresentedObject: aMethod];
				[anItem setTarget: self];
				[anItem setAction: @selector(didSelectMethod:)];
				[anItem setTag: index];
				[anItem setEnabled: YES];

				if ( [[aMethod description] isEqualTo: aTitle] == YES )
				{
					[aPopUp selectItem: anItem];
				}
			}
		 }
	}
	
	if ( [aPopUp numberOfItems] == 0 )
	{
		[aPopUp setEnabled: NO];
		[aPopUp setTransparent: YES];
	}
	else
	{
		[aPopUp setEnabled: YES];
		[aPopUp setTransparent: NO];
	}

	[aPopUp sizeToFit];
	
	[[[self popUpButton] superview] setNeedsDisplay: YES];
}

- (void) validateButtons: (id) anObject
{
	id	aDescriptor = [self descriptorForObject: anObject];
	
	if ( aDescriptor != nil )
	{
		[_runtimeButton setEnabled: YES];
		
		if ( [aDescriptor headerPath] != nil )
		{
			[_headerButton setEnabled: YES];
		}
		else
		{
			[_headerButton setEnabled: NO];
		}
		
		if ( [aDescriptor documentationPath] != nil )
		{
			[_documentationButton setEnabled: YES];
		}
		else
		{
			[_documentationButton setEnabled: NO];
		}
	}
	else
	{
		[_runtimeButton setEnabled: NO];
		[_headerButton setEnabled: NO];
		[_documentationButton setEnabled: NO];
	}
	
	[[self previousButton] setEnabled: [[self undoManager] canUndo]];
	[[self nextButton] setEnabled: [[self undoManager] canRedo]];
}

- (void) validateTitle: (id) anObject
{
	NSString*	aTitle = [self titleForObject: anObject];
	
	[[self window] setTitle: aTitle];
	[[self comboBoxDelegate] setString: aTitle];
	
	if ( [anObject isKindOfClass: [NSURL class]] == YES )
	{
		[[self window] setRepresentedFilename: [anObject path]];
	}
	else
	if ( [anObject respondsToSelector: @selector(runtimePath)] == YES )
	{
		[[self window] setRepresentedFilename: [anObject runtimePath]];
	}
	else
	if ( [anObject respondsToSelector: @selector(path)] == YES )
	{
		[[self window] setRepresentedFilename: [anObject path]];
	}
	else
	{
		[[self window] setRepresentedFilename: @""];
	}
	
	if ( [[[[self popUpButton] selectedItem] representedObject] isKindOfClass: [SZMethodDescriptor class]] == YES )
	{
		[self selectMethod: [[[self popUpButton] selectedItem] representedObject] inTextView: [[self textViewDelegate] textView]];
	}
}

- (BOOL) validateMenuItem: (NSMenuItem*) anItem
{
	if ( [anItem action] == @selector(undo:) )
	{
		return [[self undoManager] canUndo];
	}
	
	if ( [anItem action] == @selector(redo:) )
	{
		return [[self undoManager] canRedo];
	}
	
	return YES;
}

@end

@implementation MHController (UIActions)

- (BOOL) string: (NSString*) aString looksLikeMethod: (SZMethodDescriptor*) aMethod
{
	if ( ( [aString hasPrefix: [aMethod prefix]] == YES ) &&
		( [aString rangeOfString: @"("].location != NSNotFound ) &&
		( [aString rangeOfString: @")"].location != NSNotFound ) )
	{
		NSArray*	someComponents = [aMethod methodNameComponents];
		int		count = [someComponents count];
		int		index = 0;
		
		for ( index = 0; index < count; index++ )
		{
			NSString*	aComponent = [someComponents objectAtIndex: index];
			
			if ( ( aComponent != nil ) && ( [aComponent length] > 0 ) )
			{
				NSRange		aRange = [aString rangeOfString: aComponent];

				if ( aRange.location == NSNotFound )
				{
					return NO;
				}
			}
		}
		
		if ( [someComponents count] == 1 )
		{
			NSRange	aRange = [aString rangeOfString: @":"];

			if ( aRange.location == NSNotFound )
			{
				return YES;
			}
			else
			{
				return NO;
			}
		}
		
		return YES;
	}
	
	return NO;
}

- (BOOL) selectMethod: (SZMethodDescriptor*) aMethod inTextView: (NSTextView*) aTextView
{
	NSArray*	someComponents = [aMethod methodNameComponents];
	NSTextStorage*	aTextStorage = [aTextView textStorage];
	NSString*	aText = [aTextStorage string];
	NSString*	aComponent = [someComponents objectAtIndex: 0];
	NSRange		aRange;
	
	if ( [someComponents count] > 1 )
	{
		aComponent = [NSString stringWithFormat: @"%@:", aComponent];
	}
	
	aRange = [aText rangeOfString: aComponent];
		
	if ( aRange.location != NSNotFound )
	{
		NSLayoutManager*	aLayoutManager = [aTextView layoutManager];
		int			aLength = [aText length];
		
		while ( YES )
		{
			NSRange	aLineGlyphRange;
			NSRange	aLineCharRange;
			
			[aLayoutManager lineFragmentRectForGlyphAtIndex: aRange.location effectiveRange: &aLineGlyphRange];        
			aLineCharRange = [aLayoutManager characterRangeForGlyphRange: aLineGlyphRange actualGlyphRange: NULL];
			
			if ( [aTextStorage attribute: NSLinkAttributeName atIndex: aRange.location effectiveRange: NULL] == nil )
			{
				NSAttributedString*	anAttributedString = [aTextStorage attributedSubstringFromRange: aLineCharRange];
				
				NSString*		aString = [anAttributedString string];
				
				if ( [self string: aString looksLikeMethod: aMethod] == YES )
				{
					//NSLog( @"'%@'", aString );
					[aTextView setSelectedRange: aLineCharRange];
					[aTextView scrollRangeToVisible: aLineCharRange];
					
					return YES;
				}
			}
			
			{
				int	aLocation = NSMaxRange( aRange );
				NSRange	aSearchRange = NSMakeRange( aLocation, aLength - aLocation );
				
				aRange = [aText rangeOfString: aComponent options: NSLiteralSearch range: aSearchRange];

				if ( aRange.location == NSNotFound )
				{
					break;
				}
			}
		}
	}
	
	return NO;
}

- (IBAction) didSelectMethod: (id) aSender
{
	//NSLog( @"%@", aSender );
	
	[[self popUpButton] sizeToFit];
	[[[self popUpButton] superview] setNeedsDisplay: YES];
	
	if ( [self selectMethod: [aSender representedObject] inTextView: [[self textViewDelegate] textView]] == NO )
	{
		NSBeep();
	}
}

- (IBAction) displayRuntime: (id) aSender
{
	[self displayObject: [self descriptorForObject: [self currentObject]]];
}

- (IBAction) displayHeader: (id) aSender
{
	id	aDescriptor = [self descriptorForObject: [self currentObject]];
	
	if ( ( aDescriptor != nil ) && ( [aDescriptor headerPath] != nil ) )
	{
		NSURL*	anURL = [NSURL fileURLWithPath: [aDescriptor headerPath]];
		
		[self displayObject: anURL];
	}
}

- (IBAction) displayDocumentation: (id) aSender
{
	id	aDescriptor = [self descriptorForObject: [self currentObject]];
	
	if ( ( aDescriptor != nil ) && ( [aDescriptor documentationPath] != nil ) )
	{
		NSURL*	anURL = [NSURL fileURLWithPath: [aDescriptor documentationPath]];
		
		[self displayObject: anURL];
	}
}

- (IBAction) undo: (id) aSender
{
	[[self undoManager] undo];
}

- (IBAction) redo: (id) aSender
{
	[[self undoManager] redo];
}

- (IBAction) open: (id) aSender
{
	[[self openPanel] openInWindow: [self window]];
}

- (IBAction) about: (id) aSender
{
}

- (IBAction) preferences: (id) aSender
{
	[[MagicHatPreference defaultPreference] display: self];
}


@end

