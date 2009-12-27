// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MachOCommandMO.m instead.

#import "_MachOCommandMO.h"

@implementation MachOCommandMOID
@end

@implementation _MachOCommandMO

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MachOCommand" inManagedObjectContext:moc_];
}

- (MachOCommandMOID*)objectID {
	return (MachOCommandMOID*)[super objectID];
}




@dynamic cmd;



- (int)cmdValue {
	NSNumber *result = [self cmd];
	return result ? [result intValue] : 0;
}

- (void)setCmdValue:(int)value_ {
	[self setCmd:[NSNumber numberWithInt:value_]];
}






@dynamic segments;

	

- (void)addSegments:(NSSet*)value_ {
	[self willChangeValueForKey:@"segments" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value_];
	[[self primitiveValueForKey:@"segments"] unionSet:value_];
	[self didChangeValueForKey:@"segments" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value_];
}

-(void)removeSegments:(NSSet*)value_ {
	[self willChangeValueForKey:@"segments" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value_];
	[[self primitiveValueForKey:@"segments"] minusSet:value_];
	[self didChangeValueForKey:@"segments" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value_];
}
	
- (void)addSegmentsObject:(MachOSegmentMO*)value_ {
	NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value_ count:1];
	[self willChangeValueForKey:@"segments" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
	[[self primitiveValueForKey:@"segments"] addObject:value_];
	[self didChangeValueForKey:@"segments" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
	[changedObjects release];
}

- (void)removeSegmentsObject:(MachOSegmentMO*)value_ {
	NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value_ count:1];
	[self willChangeValueForKey:@"segments" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
	[[self primitiveValueForKey:@"segments"] removeObject:value_];
	[self didChangeValueForKey:@"segments" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
	[changedObjects release];
}

- (NSMutableSet*)segmentsSet {
	[self willAccessValueForKey:@"segments"];
	NSMutableSet *result = [self mutableSetValueForKey:@"segments"];
	[self didAccessValueForKey:@"segments"];
	return result;
}

	

@dynamic header;

	



@end
