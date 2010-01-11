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

	
- (NSMutableSet*)headersSet {
	[self willAccessValueForKey:@"headers"];
	NSMutableSet *result = [self mutableSetValueForKey:@"headers"];
	[self didAccessValueForKey:@"headers"];
	return result;
}
	



@end
