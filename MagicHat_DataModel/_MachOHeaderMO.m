// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MachOHeaderMO.m instead.

#import "_MachOHeaderMO.h"

@implementation MachOHeaderMOID
@end

@implementation _MachOHeaderMO

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MachOHeader" inManagedObjectContext:moc_];
}

- (MachOHeaderMOID*)objectID {
	return (MachOHeaderMOID*)[super objectID];
}




@dynamic size;



- (long long)sizeValue {
	NSNumber *result = [self size];
	return result ? [result longLongValue] : 0;
}

- (void)setSizeValue:(long long)value_ {
	[self setSize:[NSNumber numberWithLongLong:value_]];
}






@dynamic archName;






@dynamic magic;



- (int)magicValue {
	NSNumber *result = [self magic];
	return result ? [result intValue] : 0;
}

- (void)setMagicValue:(int)value_ {
	[self setMagic:[NSNumber numberWithInt:value_]];
}






@dynamic filetype;



- (int)filetypeValue {
	NSNumber *result = [self filetype];
	return result ? [result intValue] : 0;
}

- (void)setFiletypeValue:(int)value_ {
	[self setFiletype:[NSNumber numberWithInt:value_]];
}






@dynamic cpusubtype;



- (int)cpusubtypeValue {
	NSNumber *result = [self cpusubtype];
	return result ? [result intValue] : 0;
}

- (void)setCpusubtypeValue:(int)value_ {
	[self setCpusubtype:[NSNumber numberWithInt:value_]];
}






@dynamic offset;



- (long long)offsetValue {
	NSNumber *result = [self offset];
	return result ? [result longLongValue] : 0;
}

- (void)setOffsetValue:(long long)value_ {
	[self setOffset:[NSNumber numberWithLongLong:value_]];
}






@dynamic cputype;



- (int)cputypeValue {
	NSNumber *result = [self cputype];
	return result ? [result intValue] : 0;
}

- (void)setCputypeValue:(int)value_ {
	[self setCputype:[NSNumber numberWithInt:value_]];
}






@dynamic flags;



- (int)flagsValue {
	NSNumber *result = [self flags];
	return result ? [result intValue] : 0;
}

- (void)setFlagsValue:(int)value_ {
	[self setFlags:[NSNumber numberWithInt:value_]];
}






@dynamic file;

	

@dynamic commands;

	
- (NSMutableSet*)commandsSet {
	[self willAccessValueForKey:@"commands"];
	NSMutableSet *result = [self mutableSetValueForKey:@"commands"];
	[self didAccessValueForKey:@"commands"];
	return result;
}
	



@end
