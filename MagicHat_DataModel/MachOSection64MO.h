#import "_MachOSection64MO.h"
#import <mach-o/loader.h>

@class MachOSegmentCommandMO;

@interface MachOSection64MO : _MachOSection64MO {}

+ (id)sectionWithSection64:(struct section_64*)swappedSection segment:(MachOSegmentCommandMO*)segment;

- (void)setSection64:(struct section_64*)swappedSection;

@end
