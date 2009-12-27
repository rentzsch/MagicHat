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



@property (nonatomic, retain) NSNumber *magic;

- (int)magicValue;
- (void)setMagicValue:(int)value_;

//- (BOOL)validateMagic:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *filetype;

- (int)filetypeValue;
- (void)setFiletypeValue:(int)value_;

//- (BOOL)validateFiletype:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *cpusubtype;

- (int)cpusubtypeValue;
- (void)setCpusubtypeValue:(int)value_;

//- (BOOL)validateCpusubtype:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *cputype;

- (int)cputypeValue;
- (void)setCputypeValue:(int)value_;

//- (BOOL)validateCputype:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *flags;

- (int)flagsValue;
- (void)setFlagsValue:(int)value_;

//- (BOOL)validateFlags:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) MachOFileMO* file;
//- (BOOL)validateFile:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSSet* commands;

- (void)addCommands:(NSSet*)value_;
- (void)removeCommands:(NSSet*)value_;
- (void)addCommandsObject:(MachOCommandMO*)value_;
- (void)removeCommandsObject:(MachOCommandMO*)value_;
- (NSMutableSet*)commandsSet;



@end
