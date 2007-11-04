//
//  MHDrawer.h
//  MagicHat
//
//  Created by Raphael Szwarc on Thu Mar 20 2003.
//  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
//

#import <Foundation/NSObject.h>

@class NSMutableDictionary;
@class NSArray;
@class MHController;
@class NSOutlineView;

@interface MHDrawer : NSObject 
{
	@private
	NSMutableDictionary*		_dataSource;
	NSArray*					_keys;
	IBOutlet MHController*		_controller;
	IBOutlet NSOutlineView*		_outlineView;
}

- (NSDictionary*) dataSource;
- (NSArray*) keys;
- (NSArray*) setKeys:(NSArray*)newKeys;
- (MHController*) controller;
- (void) validate: (id) anObject;

- (IBAction) didSelect: (id) aSender;

@end
