#import "_MachOSectionMO.h"
#import <mach-o/loader.h>

@class MachOSegmentCommandMO;

@interface MachOSectionMO : _MachOSectionMO {}

+ (id)sectionWithSection:(struct section*)swappedSection segment:(MachOSegmentCommandMO*)segment;
+ (id)sectionWithSection64:(struct section_64*)swappedSection segment:(MachOSegmentCommandMO*)segment;

- (void)setSection:(struct section*)swappedSection;
- (void)setSection64:(struct section_64*)swappedSection;

- (NSData*)sectionData;

@end
