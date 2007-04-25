#import <Foundation/NSObject.h>

@class NSMutableDictionary;

@interface MHCache : NSObject
{
	@private
	unsigned int		_capacity;
	NSMutableDictionary*	_objects; 
	NSMutableDictionary*	_timestamps;
}

- (id) initWithCapacity: (unsigned int) aCapacity;

- (void) setObject: (id) anObject forKey: (id) aKey;
- (id) objectForKey: (id) aKey;

- (void) removeAllObjects;

@end