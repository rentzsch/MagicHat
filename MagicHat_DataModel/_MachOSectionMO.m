// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MachOSectionMO.m instead.

#import "_MachOSectionMO.h"

@implementation MachOSectionMOID
@end

@implementation _MachOSectionMO

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MachOSection" inManagedObjectContext:moc_];
}

- (MachOSectionMOID*)objectID {
	return (MachOSectionMOID*)[super objectID];
}




@dynamic name;






@dynamic segment;

	



@end
