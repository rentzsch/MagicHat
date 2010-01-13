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




@dynamic reserved2;



- (int)reserved2Value {
	NSNumber *result = [self reserved2];
	return result ? [result intValue] : 0;
}

- (void)setReserved2Value:(int)value_ {
	[self setReserved2:[NSNumber numberWithInt:value_]];
}






@dynamic segname;






@dynamic sectname;






@dynamic size;



- (long long)sizeValue {
	NSNumber *result = [self size];
	return result ? [result longLongValue] : 0;
}

- (void)setSizeValue:(long long)value_ {
	[self setSize:[NSNumber numberWithLongLong:value_]];
}






@dynamic flags;



- (int)flagsValue {
	NSNumber *result = [self flags];
	return result ? [result intValue] : 0;
}

- (void)setFlagsValue:(int)value_ {
	[self setFlags:[NSNumber numberWithInt:value_]];
}






@dynamic offset;



- (int)offsetValue {
	NSNumber *result = [self offset];
	return result ? [result intValue] : 0;
}

- (void)setOffsetValue:(int)value_ {
	[self setOffset:[NSNumber numberWithInt:value_]];
}






@dynamic reserved1;



- (int)reserved1Value {
	NSNumber *result = [self reserved1];
	return result ? [result intValue] : 0;
}

- (void)setReserved1Value:(int)value_ {
	[self setReserved1:[NSNumber numberWithInt:value_]];
}






@dynamic nreloc;



- (int)nrelocValue {
	NSNumber *result = [self nreloc];
	return result ? [result intValue] : 0;
}

- (void)setNrelocValue:(int)value_ {
	[self setNreloc:[NSNumber numberWithInt:value_]];
}






@dynamic addr;



- (long long)addrValue {
	NSNumber *result = [self addr];
	return result ? [result longLongValue] : 0;
}

- (void)setAddrValue:(long long)value_ {
	[self setAddr:[NSNumber numberWithLongLong:value_]];
}






@dynamic reloff;



- (int)reloffValue {
	NSNumber *result = [self reloff];
	return result ? [result intValue] : 0;
}

- (void)setReloffValue:(int)value_ {
	[self setReloff:[NSNumber numberWithInt:value_]];
}






@dynamic align;



- (int)alignValue {
	NSNumber *result = [self align];
	return result ? [result intValue] : 0;
}

- (void)setAlignValue:(int)value_ {
	[self setAlign:[NSNumber numberWithInt:value_]];
}






@dynamic data;






@dynamic segment;

	



@end
