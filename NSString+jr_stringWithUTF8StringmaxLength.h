//
//  NSString+jr_stringWithUTF8StringmaxLength.h
//  MagicHat
//
//  Created by wolf on 12/28/09.
//  Copyright 2009 Red Shed Software Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (jr_stringWithUTF8StringmaxLength)

+ (id)jr_stringWithUTF8String:(const char*)bytes maxLength:(NSUInteger)length;

@end
