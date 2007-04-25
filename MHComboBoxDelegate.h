//
//  MHComboBoxDelegate.h
//  MagicHat
//
//  Created by Raphael Szwarc on Wed Mar 19 2003.
//  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
//

#import <Foundation/NSObject.h>

@class NSArray;
@class MHController;
@class NSComboBox;
@class NSString;

@interface MHComboBoxDelegate : NSObject 
{
	@private
	NSArray*		_dataSource;
	IBOutlet MHController*	_controller;
	IBOutlet NSComboBox*	_comboBox;
	int			_length;
}

- (NSArray*) dataSource;
- (void) setDataSource: (NSArray*) aValue;

- (MHController*) controller;

- (NSComboBox*) comboBox;

- (int) length;
- (void) setLength: (int) aValue;

- (void) setString: (NSString*) aValue;

- (IBAction) didSelect: (id) aSender;

@end

@interface MHComboBoxDelegate (NSComboBoxDataSource)

- (NSArray*) valuesInArray: (NSArray*) anArray withString: (NSString*) aString;

@end

