#import "_MachOSection32MO.h"
#import <mach-o/loader.h>

@class MachOSegmentCommandMO;

@interface MachOSection32MO : _MachOSection32MO {}

+ (id)sectionWithSection32:(struct section*)swappedSection segment:(MachOSegmentCommandMO*)segment;
- (void)setSection32:(struct section*)swappedSection;

@end
