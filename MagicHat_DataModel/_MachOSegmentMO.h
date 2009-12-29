// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MachOSegmentMO.h instead.

#import <CoreData/CoreData.h>


@class MachOCommandMO;
@class MachOSectionMO;

@interface MachOSegmentMOID : NSManagedObjectID {}
@end

@interface _MachOSegmentMO : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (MachOSegmentMOID*)objectID;



@property (nonatomic, retain) NSNumber *filesize;

@property long long filesizeValue;
- (long long)filesizeValue;
- (void)setFilesizeValue:(long long)value_;

//- (BOOL)validateFilesize:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *fileoff;

@property long long fileoffValue;
- (long long)fileoffValue;
- (void)setFileoffValue:(long long)value_;

//- (BOOL)validateFileoff:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) MachOCommandMO* command;
//- (BOOL)validateCommand:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSSet* sections;

- (void)addSections:(NSSet*)value_;
- (void)removeSections:(NSSet*)value_;
- (void)addSectionsObject:(MachOSectionMO*)value_;
- (void)removeSectionsObject:(MachOSectionMO*)value_;
- (NSMutableSet*)sectionsSet;



@end
