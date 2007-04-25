//
//  MHController.h
//  MagicHat
//
//  Created by Raphael Szwarc on Mon Mar 17 2003.
//  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
//

#import <Foundation/NSObject.h>

@class NSArray;
@class NSCountedSet;
@class NSString;
@class NSUndoManager;
@class MHCache;
@class MHComboBoxDelegate;
@class MHTextViewDelegate;
@class MHDrawer;
@class MHOpenPanel;
@class NSProgressIndicator;
@class NSButton;
@class NSPopUpButton;
@class NSWindow;

@interface MHController : NSObject 
{
	@private
	NSArray*			_dataSource;
	id				_currentObject;
	id				_currentDescriptor;
	NSCountedSet*			_set;
	NSUndoManager*			_undoManager;
	MHCache*			_cache;
	IBOutlet MHComboBoxDelegate*	_comboBoxDelegate;
	IBOutlet MHTextViewDelegate*	_textViewDelegate;
	IBOutlet MHDrawer*		_drawer;
	IBOutlet MHOpenPanel*		_openPanel;
	IBOutlet NSProgressIndicator*	_progressIndicator;
	IBOutlet NSButton*		_previousButton;
	IBOutlet NSButton*		_nextButton;
	IBOutlet NSButton*		_runtimeButton;
	IBOutlet NSButton*		_headerButton;
	IBOutlet NSButton*		_documentationButton;
	IBOutlet NSPopUpButton*		_popUpButton;
	IBOutlet NSWindow*		_window;
}

- (NSArray*) dataSource;
- (void) setDataSource: (NSArray*) aValue;

- (id) currentObject;
- (void) setCurrentObject: (id) aValue;

- (NSUndoManager*) undoManager;

- (id) objectWithName: (NSString*) aName;
- (NSString*) titleForObject: (id) anObject;
- (id) descriptorForObject: (id) anObject;

- (void) displayObject: (id) anObject;
- (void) displaySimilarObject: (id) anObject;

@end

@interface MHController (UIComponents)

- (MHComboBoxDelegate*) comboBoxDelegate;
- (MHTextViewDelegate*) textViewDelegate;
- (MHDrawer*) drawer;
- (MHOpenPanel*) openPanel;
- (NSProgressIndicator*) progressIndicator;
- (NSButton*) previousButton;
- (NSButton*) nextButton;
- (NSPopUpButton*) popUpButton;
- (NSWindow*) window;

@end

@interface MHController (UIValidation)

- (void) validatePopUp: (id) anObject;
- (void) validateButtons: (id) anObject;
- (void) validateTitle: (id) anObject;

@end

@interface MHController (UIActions)

- (IBAction) displayRuntime: (id) aSender;
- (IBAction) displayHeader: (id) aSender;
- (IBAction) displayDocumentation: (id) aSender;

- (IBAction) undo: (id) aSender;
- (IBAction) redo: (id) aSender;

- (IBAction) open: (id) aSender;
- (IBAction) about: (id) aSender;
- (IBAction) preferences: (id) aSender;

@end
