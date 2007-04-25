//
//  SZRuntimeAdditions.h
//  MagicHat
//
//  Created by Raphael Szwarc on Thu Mar 20 2003.
//  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
//

#import "SZRuntime.h"


@interface SZRuntime (CategoryAdditions)

+ (NSSet*) categories;

+ (NSSet*) protocolsForCategory: (Category) aCategory;
+ (NSSet*) classMethodsForCategory: (Category) aCategory;
+ (NSSet*) instanceMethodsForCategory: (Category) aCategory;

@end
