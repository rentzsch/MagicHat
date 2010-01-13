// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MachOSection64MO.m instead.

#import "_MachOSection64MO.h"

@implementation MachOSection64MOID
@end

@implementation _MachOSection64MO

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MachOSection64" inManagedObjectContext:moc_];
}

- (MachOSection64MOID*)objectID {
	return (MachOSection64MOID*)[super objectID];
}




@dynamic reserved3;



- (int)reserved3Value {
	NSNumber *result = [self reserved3];
	return result ? [result intValue] : 0;
}

- (void)setReserved3Value:(int)value_ {
	[self setReserved3:[NSNumber numberWithInt:value_]];
}








@end
