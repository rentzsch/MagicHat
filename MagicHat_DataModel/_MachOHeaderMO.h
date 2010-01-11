// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MachOHeaderMO.h instead.

#import <CoreData/CoreData.h>


@class MachOFileMO;
@class MachOCommandMO;

@interface MachOHeaderMOID : NSManagedObjectID {}
@end

@interface _MachOHeaderMO : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (MachOHeaderMOID*)objectID;



@property (nonatomic, retain) NSNumber *size;

@property long long sizeValue;
- (long long)sizeValue;
- (void)setSizeValue:(long long)value_;

//- (BOOL)validateSize:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *archName;

//- (BOOL)validateArchName:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *magic;

@property int magicValue;
- (int)magicValue;
- (void)setMagicValue:(int)value_;

//- (BOOL)validateMagic:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *filetype;

@property int filetypeValue;
- (int)filetypeValue;
- (void)setFiletypeValue:(int)value_;

//- (BOOL)validateFiletype:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *cpusubtype;

@property int cpusubtypeValue;
- (int)cpusubtypeValue;
- (void)setCpusubtypeValue:(int)value_;

//- (BOOL)validateCpusubtype:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *offset;

@property long long offsetValue;
- (long long)offsetValue;
- (void)setOffsetValue:(long long)value_;

//- (BOOL)validateOffset:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *cputype;

@property int cputypeValue;
- (int)cputypeValue;
- (void)setCputypeValue:(int)value_;

//- (BOOL)validateCputype:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *flags;

@property int flagsValue;
- (int)flagsValue;
- (void)setFlagsValue:(int)value_;

//- (BOOL)validateFlags:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) MachOFileMO* file;
//- (BOOL)validateFile:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSSet* commands;
- (NSMutableSet*)commandsSet;



@end

@interface _MachOHeaderMO (CoreDataGeneratedAccessors)

- (void)addCommands:(NSSet*)value_;
- (void)removeCommands:(NSSet*)value_;
- (void)addCommandsObject:(MachOCommandMO*)value_;
- (void)removeCommandsObject:(MachOCommandMO*)value_;

@end
