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




@dynamic name;






@dynamic cmdsize;



- (int)cmdsizeValue {
	NSNumber *result = [self cmdsize];
	return result ? [result intValue] : 0;
}

- (void)setCmdsizeValue:(int)value_ {
	[self setCmdsize:[NSNumber numberWithInt:value_]];
}






@dynamic cmdoffset;



- (long long)cmdoffsetValue {
	NSNumber *result = [self cmdoffset];
	return result ? [result longLongValue] : 0;
}

- (void)setCmdoffsetValue:(long long)value_ {
	[self setCmdoffset:[NSNumber numberWithLongLong:value_]];
}






@dynamic cmd;



- (int)cmdValue {
	NSNumber *result = [self cmd];
	return result ? [result intValue] : 0;
}

- (void)setCmdValue:(int)value_ {
	[self setCmd:[NSNumber numberWithInt:value_]];
}






@dynamic header;

	



@end
