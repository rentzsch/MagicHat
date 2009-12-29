// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MachOCommandMO.h instead.

#import <CoreData/CoreData.h>


@class MachOSegmentMO;
@class MachOHeaderMO;

@interface MachOCommandMOID : NSManagedObjectID {}
@end

@interface _MachOCommandMO : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (MachOCommandMOID*)objectID;



@property (nonatomic, retain) NSNumber *cmd;

@property int cmdValue;
- (int)cmdValue;
- (void)setCmdValue:(int)value_;

//- (BOOL)validateCmd:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *cmdsize;

@property int cmdsizeValue;
- (int)cmdsizeValue;
- (void)setCmdsizeValue:(int)value_;

//- (BOOL)validateCmdsize:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSSet* segments;

- (void)addSegments:(NSSet*)value_;
- (void)removeSegments:(NSSet*)value_;
- (void)addSegmentsObject:(MachOSegmentMO*)value_;
- (void)removeSegmentsObject:(MachOSegmentMO*)value_;
- (NSMutableSet*)segmentsSet;



@property (nonatomic, retain) MachOHeaderMO* header;
//- (BOOL)validateHeader:(id*)value_ error:(NSError**)error_;



@end
