// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MachOSectionMO.h instead.

#import <CoreData/CoreData.h>


@class MachOSegmentCommandMO;

@interface MachOSectionMOID : NSManagedObjectID {}
@end

@interface _MachOSectionMO : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (MachOSectionMOID*)objectID;



@property (nonatomic, retain) NSNumber *reserved2;

@property int reserved2Value;
- (int)reserved2Value;
- (void)setReserved2Value:(int)value_;

//- (BOOL)validateReserved2:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *segname;

//- (BOOL)validateSegname:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *sectname;

//- (BOOL)validateSectname:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *size;

@property long long sizeValue;
- (long long)sizeValue;
- (void)setSizeValue:(long long)value_;

//- (BOOL)validateSize:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *flags;

@property int flagsValue;
- (int)flagsValue;
- (void)setFlagsValue:(int)value_;

//- (BOOL)validateFlags:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *reserved3;

@property int reserved3Value;
- (int)reserved3Value;
- (void)setReserved3Value:(int)value_;

//- (BOOL)validateReserved3:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *offset;

@property int offsetValue;
- (int)offsetValue;
- (void)setOffsetValue:(int)value_;

//- (BOOL)validateOffset:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *reserved1;

@property int reserved1Value;
- (int)reserved1Value;
- (void)setReserved1Value:(int)value_;

//- (BOOL)validateReserved1:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *nreloc;

@property int nrelocValue;
- (int)nrelocValue;
- (void)setNrelocValue:(int)value_;

//- (BOOL)validateNreloc:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *addr;

@property long long addrValue;
- (long long)addrValue;
- (void)setAddrValue:(long long)value_;

//- (BOOL)validateAddr:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *reloff;

@property int reloffValue;
- (int)reloffValue;
- (void)setReloffValue:(int)value_;

//- (BOOL)validateReloff:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *align;

@property int alignValue;
- (int)alignValue;
- (void)setAlignValue:(int)value_;

//- (BOOL)validateAlign:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSData *data;

//- (BOOL)validateData:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) MachOSegmentCommandMO* segment;
//- (BOOL)validateSegment:(id*)value_ error:(NSError**)error_;



@end

@interface _MachOSectionMO (CoreDataGeneratedAccessors)

@end
