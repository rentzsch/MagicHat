// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MachOFileMO.m instead.

#import "_MachOFileMO.h"

@implementation MachOFileMOID
@end

@implementation _MachOFileMO

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MachOFile" inManagedObjectContext:moc_];
}

- (MachOFileMOID*)objectID {
	return (MachOFileMOID*)[super objectID];
}




@dynamic headers;

	

- (void)addHeaders:(NSSet*)value_ {
	[self willChangeValueForKey:@"headers" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value_];
	[[self primitiveValueForKey:@"headers"] unionSet:value_];
	[self didChangeValueForKey:@"headers" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value_];
}

-(void)removeHeaders:(NSSet*)value_ {
	[self willChangeValueForKey:@"headers" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value_];
	[[self primitiveValueForKey:@"headers"] minusSet:value_];
	[self didChangeValueForKey:@"headers" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value_];
}
	
- (void)addHeadersObject:(MachOHeaderMO*)value_ {
	NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value_ count:1];
	[self willChangeValueForKey:@"headers" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
	[[self primitiveValueForKey:@"headers"] addObject:value_];
	[self didChangeValueForKey:@"headers" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
	[changedObjects release];
}

- (void)removeHeadersObject:(MachOHeaderMO*)value_ {
	NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value_ count:1];
	[self willChangeValueForKey:@"headers" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
	[[self primitiveValueForKey:@"headers"] removeObject:value_];
	[self didChangeValueForKey:@"headers" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
	[changedObjects release];
}

- (NSMutableSet*)headersSet {
	[self willAccessValueForKey:@"headers"];
	NSMutableSet *result = [self mutableSetValueForKey:@"headers"];
	[self didAccessValueForKey:@"headers"];
	return result;
}

	



@end
