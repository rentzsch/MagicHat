//
//  MHDrawer.m
//  MagicHat
//
//  Created by Raphael Szwarc on Thu Mar 20 2003.
//  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "SZClassDescriptor.h"
#import "SZClassHierarchyDescriptor.h"
#import "SZReferenceDescriptor.h"
#import "SZProtocolDescriptor.h"
#import "SZProtocolImplementationDescriptor.h"
#import "SZFrameworkDescriptor.h"
#import "MHController.h"
#import "MHDrawer.h"

//	===========================================================================
//	Constant(s)
//	---------------------------------------------------------------------------

static NSString* const	ProtocolKey = @"Conforms to";
static NSString* const	SuperclassKey = @"Inherits from";
static NSString* const	SubclassKey = @"Extended by";
static NSString* const	ReferenceKey = @"Referenced by";
static NSString* const	ImplementationKey = @"Adopted by";
static NSString* const	ClassKey = @"Classes";

@implementation MHDrawer

- (NSDictionary*) dataSourceForClass: (SZClassDescriptor*) aDescriptor
{
	NSMutableDictionary*	aDataSource = [NSMutableDictionary dictionary];
	NSString*		aName = [aDescriptor name];
	NSArray*		anArray = [aDescriptor protocolNames];
	
	if ( anArray != nil )
	{
		[aDataSource setObject: anArray forKey: ProtocolKey];
	}
	
	anArray = [aDescriptor superClassNames];
	
	if ( anArray != nil )
	{
		[aDataSource setObject: anArray forKey: SuperclassKey];
	}
	
	anArray = [SZClassHierarchyDescriptor classNamesWithSuperClassName: aName];
	
	if ( anArray != nil )
	{
		[aDataSource setObject: anArray forKey: SubclassKey];
	}
	
	anArray = [SZReferenceDescriptor classNamesWithReferenceName: aName];
	
	if ( anArray != nil )
	{
		[aDataSource setObject: anArray forKey: ReferenceKey];
	}
	
	return aDataSource;
}

- (NSDictionary*) dataSourceForProtocol: (SZProtocolDescriptor*) aDescriptor
{
	NSMutableDictionary*	aDataSource = [NSMutableDictionary dictionary];
	NSString*		aName = [aDescriptor name];
	NSArray*		anArray = [SZProtocolImplementationDescriptor classNamesWithProtocolName: aName];
	
	if ( anArray != nil )
	{
		[aDataSource setObject: anArray forKey: ImplementationKey];
	}
	
	return aDataSource;
}

- (NSDictionary*) dataSourceForFramework: (SZFrameworkDescriptor*) aDescriptor
{
	NSMutableDictionary*	aDataSource = [NSMutableDictionary dictionary];
	NSString*		aName = [aDescriptor name];
	NSArray*		anArray = [SZFrameworkDescriptor classNamesWithFrameworkName: aName];
	
	if ( anArray != nil )
	{
		[aDataSource setObject: anArray forKey: ClassKey];
	}
	
	return aDataSource;
}

- (NSDictionary*) dataSource
{
	return _dataSource;
}

- (void) setDataSource: (NSDictionary*) aValue
{
	[_dataSource autorelease];
	_dataSource = [aValue retain];

	[self setKeys: nil];
}

- (NSDictionary*) dataSourceForDescriptor: (id) aDescriptor
{
	if ( [aDescriptor isKindOfClass: [SZClassDescriptor class]] == YES )
	{
		return [self dataSourceForClass: aDescriptor];
	}
	else
	if ( [aDescriptor isKindOfClass: [SZProtocolDescriptor class]] == YES )
	{
		return [self dataSourceForProtocol: aDescriptor];
	}
	else
	if ( [aDescriptor isKindOfClass: [SZFrameworkDescriptor class]] == YES )
	{
		return [self dataSourceForFramework: aDescriptor];
	}

	return nil;
}


- (NSArray*) keys
{
	if ( _keys == nil )
	{
		_keys = [self setKeys: [[[self dataSource] allKeys] sortedArrayUsingSelector: @selector(compare:)]];
	}
	
	return _keys;
}

- (NSArray*) setKeys: (NSArray*) aValue
{
	[_keys autorelease];
	_keys = [aValue retain];
	return _keys;
}

- (MHController*) controller
{
	return _controller;
}

- (void) validate: (id) anObject
{
	id	aDescriptor = [[self controller] descriptorForObject: anObject];
	
	[self setDataSource: [self dataSourceForDescriptor: aDescriptor]];
	
	[_outlineView noteNumberOfRowsChanged];
	[_outlineView reloadData];
	[_outlineView expandAllItems];
}

- (IBAction) didSelect: (id) aSender
{
	NSString*	aName = [aSender itemAtRow: [aSender selectedRow]];
	id		anObject = [[self controller] objectWithName: aName];
	
	if ( anObject != nil )
	{
		[aSender deselectAll: self];
		[[self controller] displaySimilarObject: anObject];
	}
	
	//NSLog( @"MHDrawer.didSelect: %@", aName );
}

@end

@implementation MHDrawer(NSOutlineViewDataSource)

- (int) outlineView: (NSOutlineView*) anOutline numberOfChildrenOfItem: (id) anItem
{
	//NSLog( @"numberOfChildrenOfItem: %@", anItem );

	if ( anItem == nil )
	{
		//NSLog( @"numberOfChildrenOfItem: %@", [[self dataSource] allKeys] );
		
		return [[self dataSource] count];
	}
	else
	{
		NSArray*	anArray = [[self dataSource] objectForKey: anItem];
		
		if ( anArray != nil )
		{
			return [anArray count];
		}
	}
	
	return 0;
}

- (BOOL) outlineView: (NSOutlineView*) anOutline isItemExpandable: (id) anItem
{
	//NSLog( @"isItemExpandable: %@", anItem );
	
	if ( anItem == nil )
	{
		return YES;
	}

	if ( [[self keys] containsObject: anItem] == YES )
	{
		return YES;
	}
	
	return NO;
}

- (id) outlineView: (NSOutlineView*) anOutline child: (int) anIndex ofItem: (id) anItem
{
	if ( anItem == nil )
	{
		return [[self keys] objectAtIndex: anIndex];
	}
	else
	{
		NSArray*	anArray = [[self dataSource] objectForKey: anItem];
		
		//NSLog( @"child:ofItem: %@", anItem );
	
		if ( anArray != nil )
		{
			return [anArray objectAtIndex: anIndex];
		}
	}
	
	return nil;
}

- (id) outlineView: (NSOutlineView*) anOutline objectValueForTableColumn: (NSTableColumn*) aColumn byItem: (id) anItem
{
	//NSLog( @"objectValueForTableColumn: %@", anItem );

	return anItem;
}

- (void) outlineView: (NSOutlineView*) anOutline willDisplayCell: (id) aCell forTableColumn: (NSTableColumn*) aColumn item: (id) anItem
{
	if ( [[self keys] containsObject: anItem] == NO )
	{
		NSDictionary*		someAttributes = [NSDictionary dictionaryWithObjectsAndKeys: 
						[NSColor blueColor], NSForegroundColorAttributeName, 
						[NSNumber numberWithInt: NSSingleUnderlineStyle], NSUnderlineStyleAttributeName,
						nil];
		NSAttributedString*	aString = [[[NSAttributedString alloc] initWithString: anItem attributes:someAttributes] autorelease];

		[aCell setAttributedStringValue: aString];
	}
}

@end

@implementation NSOutlineView(MagicHatAdditions)

- (void) expandAllItems
{
	int	count = [self numberOfRows];
	int	index = 0;
	
	//NSLog( @"NSOutlineView.expandAllItems: %d", count );

	for ( index = 0; index < count; index++ )
	{
		[self expandItem: [self itemAtRow: index] expandChildren: YES];
	}
}

/*
- (void) resetCursorRects
{
	NSRect		aVisibleRect = [[self enclosingScrollView] documentVisibleRect];
	NSCursor*	aCursor = [NSTextView handCursor];
	int		count = [self numberOfRows];
	int		index = 0;
	
	//NSLog( @"NSOutlineView.resetCursorRects: %d", count );
	
	for ( index = 0; index < count; index++ )
	{
		NSRect	aCellRect = [self frameOfCellAtColumn: 0 row: index];
		
		[self addCursorRect: NSIntersectionRect( aVisibleRect, aCellRect ) cursor: aCursor];
	}
}
*/

@end

