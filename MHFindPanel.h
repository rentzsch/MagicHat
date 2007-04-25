//
//  MHFindPanel.h
//  MagicHat
//
//  Created by Raphael Szwarc on Tue Mar 25 2003.
//  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
//

#import <Foundation/NSObject.h>

@class NSPanel;
@class NSTextField;
@class NSButton;
@class NSTextView;

@interface MHFindPanel : NSObject 
{
	@private
	IBOutlet NSPanel*	_panel;
	IBOutlet NSTextField*	_textField;
	IBOutlet NSTextField*	_statusField;
	IBOutlet NSButton*	_previousButton;
	IBOutlet NSButton*	_nextButton;
	IBOutlet NSTextView*	_textView;
}

- (IBAction) previous: (id) aSender;
- (IBAction) next: (id) aSender;
- (IBAction) nextSelection: (id) aSender;
- (IBAction) scroll: (id) aSender;

@end
