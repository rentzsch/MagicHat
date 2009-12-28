// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MachOSectionMO.h instead.

#import <CoreData/CoreData.h>


@class MachOSegmentMO;

@interface MachOSectionMOID : NSManagedObjectID {}
@end

@interface _MachOSectionMO : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (MachOSectionMOID*)objectID;



@property (nonatomic, retain) NSString *name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) MachOSegmentMO* segment;
//- (BOOL)validateSegment:(id*)value_ error:(NSError**)error_;



@end
