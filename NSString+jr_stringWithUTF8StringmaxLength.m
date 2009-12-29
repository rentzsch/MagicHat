//
//  NSString+jr_stringWithUTF8StringmaxLength.m
//  MagicHat
//
//  Created by wolf on 12/28/09.
//  Copyright 2009 Red Shed Software Company. All rights reserved.
//

#ifndef CFAutorelease(cf)
    #if MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_4
        #define CFAutorelease(cf) [NSMakeCollectable(cf) autorelease]
    #else
        #define CFAutorelease(cf) [(id)cf autorelease]
    #endif
#endif

#import "NSString+jr_stringWithUTF8StringmaxLength.h"

@implementation NSString (jr_stringWithUTF8StringmaxLength)

+ (id)jr_stringWithUTF8String:(const char*)bytes maxLength:(NSUInteger)maxLength {
    NSParameterAssert(bytes);
    
    NSUInteger scannedLength = 0;
    for (; scannedLength < maxLength; scannedLength++) {
        if (0 == bytes[scannedLength]) {
            break;
        }
    }
    
    return CFAutorelease(CFStringCreateWithBytes(kCFAllocatorDefault, (const UInt8*)bytes, scannedLength, kCFStringEncodingUTF8, false));
}

@end
