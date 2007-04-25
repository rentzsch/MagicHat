//
//  MHTextViewDelegate.h
//  MagicHat
//
//  Created by Raphael Szwarc on Wed Mar 19 2003.
//  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
//

#import <Foundation/NSObject.h>

@class MHController;
@class NSTextView;

@interface MHTextViewDelegate : NSObject 
{
	@private
	IBOutlet MHController*	_controller;
	IBOutlet NSTextView*	_textView;
}

- (MHController*) controller;
- (NSTextView*) textView;

@end
