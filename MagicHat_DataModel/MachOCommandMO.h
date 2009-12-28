#import "_MachOCommandMO.h"

@interface MachOCommandMO : _MachOCommandMO {}

+ (id)commandWithLoadCommand:(struct load_command*)originalLoadCommand swap:(BOOL)swap inManagedObjectContext:(NSManagedObjectContext*)moc;

- (void)setLoadCommand:(struct load_command*)swappedLoadCommand;

@end
