// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MachOFileMO.h instead.

#import <CoreData/CoreData.h>


@class MachOHeaderMO;

@interface MachOFileMOID : NSManagedObjectID {}
@end

@interface _MachOFileMO : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (MachOFileMOID*)objectID;




@property (nonatomic, retain) NSSet* headers;

- (void)addHeaders:(NSSet*)value_;
- (void)removeHeaders:(NSSet*)value_;
- (void)addHeadersObject:(MachOHeaderMO*)value_;
- (void)removeHeadersObject:(MachOHeaderMO*)value_;
- (NSMutableSet*)headersSet;



@end
