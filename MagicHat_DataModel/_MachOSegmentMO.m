// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MachOSegmentMO.m instead.

#import "_MachOSegmentMO.h"

@implementation MachOSegmentMOID
@end

@implementation _MachOSegmentMO

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MachOSegment" inManagedObjectContext:moc_];
}

- (MachOSegmentMOID*)objectID {
	return (MachOSegmentMOID*)[super objectID];
}




@dynamic command;

	

@dynamic sections;

	

- (void)addSections:(NSSet*)value_ {
	[self willChangeValueForKey:@"sections" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value_];
	[[self primitiveValueForKey:@"sections"] unionSet:value_];
	[self didChangeValueForKey:@"sections" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value_];
}

-(void)removeSections:(NSSet*)value_ {
	[self willChangeValueForKey:@"sections" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value_];
	[[self primitiveValueForKey:@"sections"] minusSet:value_];
	[self didChangeValueForKey:@"sections" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value_];
}
	
- (void)addSectionsObject:(MachOSectionMO*)value_ {
	NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value_ count:1];
	[self willChangeValueForKey:@"sections" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
	[[self primitiveValueForKey:@"sections"] addObject:value_];
	[self didChangeValueForKey:@"sections" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
	[changedObjects release];
}

- (void)removeSectionsObject:(MachOSectionMO*)value_ {
	NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value_ count:1];
	[self willChangeValueForKey:@"sections" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
	[[self primitiveValueForKey:@"sections"] removeObject:value_];
	[self didChangeValueForKey:@"sections" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
	[changedObjects release];
}

- (NSMutableSet*)sectionsSet {
	[self willAccessValueForKey:@"sections"];
	NSMutableSet *result = [self mutableSetValueForKey:@"sections"];
	[self didAccessValueForKey:@"sections"];
	return result;
}

	



@end
