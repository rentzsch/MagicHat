//
//  MHComboBoxDelegate.m
//  MagicHat
//
//  Created by Raphael Szwarc on Wed Mar 19 2003.
//  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "MHController.h"
#import "MHComboBoxDelegate.h"

@implementation MHComboBoxDelegate

- (NSArray*) dataSource
{
	if ( _dataSource == nil )
	{
		[self setDataSource: [[self controller] dataSource]]; 
	}
	
	return _dataSource;
}

- (void) setDataSource: (NSArray*) aValue
{
	[_dataSource autorelease];
	
	_dataSource = [aValue retain];
}

- (MHController*) controller
{
	return _controller;
}

- (NSComboBox*) comboBox
{
	return _comboBox;
}

- (int) length
{
	return _length;
}

- (void) setLength: (int) aValue
{
	_length = aValue;
}

- (void) setString: (NSString*) aValue
{
	[[self comboBox] setStringValue: aValue];
}

- (IBAction) didSelect: (id) aSender
{
	NSString*	aName = [aSender stringValue];
	id		anObject = [[self controller] objectWithName: aName];
	
	if ( anObject != nil )
	{
		[[self controller] performSelector: @selector(displaySimilarObject:) withObject: anObject afterDelay: 0];
	}
}

@end

@implementation MHComboBoxDelegate (NSNibAwaking)

- (void) awakeFromNib
{
	NSComboBox*	aComboBox = [self comboBox];
	
	[[[aComboBox cell] valueForKey: @"_buttonCell"] setEnabled: NO];
	[aComboBox setNumberOfVisibleItems: [aComboBox numberOfVisibleItems] * 2];
}

@end

@implementation MHComboBoxDelegate (NSComboBoxDataSource)

- (NSArray*) valuesInArray: (NSArray*) anArray withString: (NSString*) aString
{
	int		count = [anArray count];
	NSMutableArray*	someValues = [NSMutableArray arrayWithCapacity: count];
	int		index = 0;

	aString = [aString lowercaseString];
	
	for ( index = 0; index < count; index++ )
	{
		NSString*	aValue = [anArray objectAtIndex: index];
		NSRange		aRange = [aValue rangeOfString: aString options: NSCaseInsensitiveSearch];

		if ( aRange.location != NSNotFound )
		{
			[someValues addObject: aValue];
		}
	}
	
	if ( [someValues count] == 0 )
	{
		someValues = nil;
	}
	
	return someValues;
}

- (NSString*) comboBox: (NSComboBox*) aComboBox completedString: (NSString*) aString
{
	NSArray*	someValues = [self dataSource];
	
	if ( someValues != nil )
	{
		int	count = [someValues count];
		int	index = 0;
		
		for ( index = 0; index < count; index++ )
		{
			NSString*	aValue = [someValues objectAtIndex: index];
			NSRange		aRange = [aValue rangeOfString: aString options: NSCaseInsensitiveSearch];
	
			if ( aRange.location == 0 )
			{
				return aValue;
			}
		}
	}

	return aString;
}

- (unsigned int) comboBox: (NSComboBox*) aComboBox indexOfItemWithStringValue: (NSString*) aString
{
	NSArray*	anArray = [self dataSource];
	
	if ( anArray != nil )
	{
		int	count = [anArray count];
		int	index = 0;
		
		for ( index = 0; index < count; index++ )
		{
			id	anObject = [anArray objectAtIndex: index];
			
			if ( [anObject isEqualTo: aString] == YES )
			{
				return index;
			}
		}
	}
	
	return NSNotFound;
}

- (int) numberOfItemsInComboBox: (NSComboBox*) aComboBox
{
	NSArray*	aDataSource = [self dataSource];
	
	if ( aDataSource != nil )
	{
		return [aDataSource count];
	}
	
	return 0;
}

- (id) comboBox: (NSComboBox*) aComboBox objectValueForItemAtIndex: (int) anIndex
{
	if ( anIndex >= 0 )
	{
		NSArray*	aDataSource = [self dataSource];
	
		if ( ( aDataSource != nil ) && ( anIndex < [aDataSource count] ) )
		{
			return [aDataSource objectAtIndex: anIndex];
		}
	}

	return nil;
}

@end

@implementation MHComboBoxDelegate (NSComboBoxNotifications)

- (void) comboBoxWillDismiss: (NSNotification*) aNotification
{
	NSComboBox*	aComboBox = [aNotification object];
	NSString*	aString = [aComboBox stringValue];
	NSCell*		aCell = [aComboBox cell];
	
	[[aCell class] cancelPreviousPerformRequestsWithTarget: aCell selector: @selector(popUp:) object: self];

	if ( [[self dataSource] containsObject: aString] == YES )
	{
		[self didSelect: aComboBox];
	}
}

@end

@implementation MHComboBoxDelegate (NSControlSubclassNotifications)

- (void) controlTextDidChange: (NSNotification*) aNotification
{
	NSComboBox*	aComboBox = [aNotification object];
	NSString*	aString = [aComboBox stringValue];
	NSArray*	someValues = nil;
	
	if ( ( aString == nil ) || ( [aString length] == 0 ) )
	{
		[self setLength: 0];
		
		someValues = nil;
	}
	else
	if ( [self length] > [aString length] )
	{
		someValues = [self valuesInArray: [[self controller] dataSource] withString: aString];
	}
	else
	{
		[self setLength: [aString length]];
		
		someValues = [self valuesInArray: [self dataSource] withString: aString];
	}

	[self setDataSource: someValues];
	[aComboBox noteNumberOfItemsChanged];

	[[aComboBox cell] performSelector: @selector(popUp:) withObject: self afterDelay: 0];
}

@end

@implementation NSComboBoxCell (MHComboBoxDelegateAdditions)

- (float) _buttonHeight
{
	return 0;
}

- (void) drawWithFrame: (NSRect) aFrame inView: (NSView*) aView
{
	[super drawWithFrame: aFrame inView: aView];
}

@end

