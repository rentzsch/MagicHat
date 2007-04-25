#import <Foundation/Foundation.h>
#import "MHCache.h"


@implementation MHCache

- (id) initWithCapacity: (unsigned int) aCapacity
{
	self = [super init];
	
	_capacity = aCapacity;
	_objects = [[NSMutableDictionary allocWithZone:[self zone]] initWithCapacity: aCapacity];
	_timestamps = [[NSMutableDictionary allocWithZone:[self zone]] initWithCapacity: aCapacity];
	
	return self;
}


- (void) setObject: (id) anObject forKey: (id) aKey
{
	while ( [_objects count] >= _capacity )
	{
		id	anOldKey = [[_timestamps keysSortedByValueUsingSelector: @selector(compare:)] objectAtIndex: 0];
		
		[_objects removeObjectForKey: anOldKey];
		[_timestamps removeObjectForKey: anOldKey];
	}
	
	[_objects setObject: anObject forKey: aKey ];
	[_timestamps setObject: [NSDate date] forKey: aKey ];
}


- (id) objectForKey: (id) aKey
{
	id	anObject = [_objects objectForKey: aKey];
	
	if ( anObject != nil )
	{
		[_timestamps setObject: [NSDate date] forKey: aKey];
	}
	
	return anObject;
}

- (void) removeAllObjects
{
	[_objects removeAllObjects];
	[_timestamps removeAllObjects];
}

- (void) dealloc
{
	[_objects release];
	[_timestamps release];
	
	[super dealloc];
}

@end