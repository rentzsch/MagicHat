//
//  SZReferenceDescriptor.h
//  MagicHat
//
//  Created by Raphael Szwarc on Mon Mar 24 2003.
//  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
//

#import <Foundation/NSObject.h>


@interface SZReferenceDescriptor : NSObject 
{

}

+ (NSArray*) classNamesWithReferenceName: (NSString*) aReferenceName;

@end
