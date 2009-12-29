// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MachOSegmentCommandMO.m instead.

#import "_MachOSegmentCommandMO.h"

@implementation MachOSegmentCommandMOID
@end

@implementation _MachOSegmentCommandMO

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MachOSegmentCommand" inManagedObjectContext:moc_];
}

- (MachOSegmentCommandMOID*)objectID {
	return (MachOSegmentCommandMOID*)[super objectID];
}




@dynamic segname;






@dynamic fileoff;



- (long long)fileoffValue {
	NSNumber *result = [self fileoff];
	return result ? [result longLongValue] : 0;
}

- (void)setFileoffValue:(long long)value_ {
	[self setFileoff:[NSNumber numberWithLongLong:value_]];
}






@dynamic flags;



- (int)flagsValue {
	NSNumber *result = [self flags];
	return result ? [result intValue] : 0;
}

- (void)setFlagsValue:(int)value_ {
	[self setFlags:[NSNumber numberWithInt:value_]];
}






@dynamic maxprot;



- (int)maxprotValue {
	NSNumber *result = [self maxprot];
	return result ? [result intValue] : 0;
}

- (void)setMaxprotValue:(int)value_ {
	[self setMaxprot:[NSNumber numberWithInt:value_]];
}






@dynamic vmsize;



- (long long)vmsizeValue {
	NSNumber *result = [self vmsize];
	return result ? [result longLongValue] : 0;
}

- (void)setVmsizeValue:(long long)value_ {
	[self setVmsize:[NSNumber numberWithLongLong:value_]];
}






@dynamic vmaddr;



- (long long)vmaddrValue {
	NSNumber *result = [self vmaddr];
	return result ? [result longLongValue] : 0;
}

- (void)setVmaddrValue:(long long)value_ {
	[self setVmaddr:[NSNumber numberWithLongLong:value_]];
}






@dynamic nsects;



- (int)nsectsValue {
	NSNumber *result = [self nsects];
	return result ? [result intValue] : 0;
}

- (void)setNsectsValue:(int)value_ {
	[self setNsects:[NSNumber numberWithInt:value_]];
}






@dynamic filesize;



- (long long)filesizeValue {
	NSNumber *result = [self filesize];
	return result ? [result longLongValue] : 0;
}

- (void)setFilesizeValue:(long long)value_ {
	[self setFilesize:[NSNumber numberWithLongLong:value_]];
}






@dynamic initprot;



- (int)initprotValue {
	NSNumber *result = [self initprot];
	return result ? [result intValue] : 0;
}

- (void)setInitprotValue:(int)value_ {
	[self setInitprot:[NSNumber numberWithInt:value_]];
}








@end
