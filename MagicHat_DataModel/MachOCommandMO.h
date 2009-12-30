#import "_MachOCommandMO.h"
#import <mach-o/loader.h>

@interface MachOCommandMO : _MachOCommandMO {}

+ (id)commandWithOriginalLoadCommand:(struct load_command*)originalLoadCommand header:(MachOHeaderMO*)header;

- (void)setLoadCommand:(struct load_command*)swappedLoadCommand; // Implemented by subclasses.

@end
