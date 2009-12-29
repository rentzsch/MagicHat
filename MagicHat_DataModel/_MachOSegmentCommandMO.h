// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MachOSegmentCommandMO.h instead.

#import <CoreData/CoreData.h>
#import "MachOCommandMO.h"

@class MachOSegmentSectionMO;

@interface MachOSegmentCommandMOID : NSManagedObjectID {}
@end

@interface _MachOSegmentCommandMO : MachOCommandMO {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (MachOSegmentCommandMOID*)objectID;



@property (nonatomic, retain) NSString *segname;

//- (BOOL)validateSegname:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *fileoff;

@property long long fileoffValue;
- (long long)fileoffValue;
- (void)setFileoffValue:(long long)value_;

//- (BOOL)validateFileoff:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *flags;

@property int flagsValue;
- (int)flagsValue;
- (void)setFlagsValue:(int)value_;

//- (BOOL)validateFlags:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *maxprot;

@property int maxprotValue;
- (int)maxprotValue;
- (void)setMaxprotValue:(int)value_;

//- (BOOL)validateMaxprot:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *vmsize;

@property long long vmsizeValue;
- (long long)vmsizeValue;
- (void)setVmsizeValue:(long long)value_;

//- (BOOL)validateVmsize:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *vmaddr;

@property long long vmaddrValue;
- (long long)vmaddrValue;
- (void)setVmaddrValue:(long long)value_;

//- (BOOL)validateVmaddr:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *nsects;

@property int nsectsValue;
- (int)nsectsValue;
- (void)setNsectsValue:(int)value_;

//- (BOOL)validateNsects:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *filesize;

@property long long filesizeValue;
- (long long)filesizeValue;
- (void)setFilesizeValue:(long long)value_;

//- (BOOL)validateFilesize:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *initprot;

@property int initprotValue;
- (int)initprotValue;
- (void)setInitprotValue:(int)value_;

//- (BOOL)validateInitprot:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSSet* sections;

- (void)addSections:(NSSet*)value_;
- (void)removeSections:(NSSet*)value_;
- (void)addSectionsObject:(MachOSegmentSectionMO*)value_;
- (void)removeSectionsObject:(MachOSegmentSectionMO*)value_;
- (NSMutableSet*)sectionsSet;



@end
