//
//  MHOpenPanel.h
//  MagicHat
//
//  Created by Raphael Szwarc on Thu Mar 20 2003.
//  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
//

#import <Foundation/NSObject.h>

@class MHController;
@class NSPanel;
@class NSBrowser;
@class NSTextField;
@class NSButton;
@class NSWindow;

@interface MHOpenPanel : NSObject 
{
	@private
	IBOutlet MHController*	_controller;
	IBOutlet NSPanel*	_panel;
	IBOutlet NSBrowser*	_browser;
	IBOutlet NSTextField*	_textField;
	IBOutlet NSButton*	_cancelButton;
	IBOutlet NSButton*	_openButton;
}

- (MHController*) controller;

- (void) openInWindow: (NSWindow*) aWindow;

@end

@interface MHOpenPanel(UIComponents)

- (NSPanel*) panel;
- (NSBrowser*) browser;
- (NSTextField*) textField;
- (NSButton*) cancelButton;
- (NSButton*) openButton;

@end

@interface MHOpenPanel(UIActions)

- (IBAction) cancel: (id) aSender;
- (IBAction) open: (id) aSender;
- (IBAction) didSelect: (id) aSender;

@end
