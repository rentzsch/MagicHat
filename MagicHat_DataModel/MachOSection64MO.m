#import "MachOSection64MO.h"

@implementation MachOSection64MO

+ (id)sectionWithSection64:(struct section_64*)swappedSection segment:(MachOSegmentCommandMO*)segment {
    NSString *sectionName = [NSString jr_stringWithUTF8String:swappedSection->sectname maxLength:sizeof(swappedSection->sectname)];
    Class   section_class = [sectionName isEqualToString:@"__objc_classlist"] ? [MachOClassesSectionMO class] : [MachOSectionMO class];
    
    MachOSectionMO *section = [section_class insertInManagedObjectContext:[segment managedObjectContext]];
    [segment addSectionsObject:section];
    [section setSection64:swappedSection];
    return section;
}

- (void)setSection64:(struct section_64*)swappedSection {
    self.sectname = [NSString jr_stringWithUTF8String:swappedSection->sectname maxLength:sizeof(swappedSection->sectname)];
    self.segname = [NSString jr_stringWithUTF8String:swappedSection->segname maxLength:sizeof(swappedSection->segname)];
    ASSIGN_ATTR(self, addr, swappedSection);
    ASSIGN_ATTR(self, size, swappedSection);
    ASSIGN_ATTR(self, offset, swappedSection);
    ASSIGN_ATTR(self, align, swappedSection);
    ASSIGN_ATTR(self, reloff, swappedSection);
    ASSIGN_ATTR(self, nreloc, swappedSection);
    ASSIGN_ATTR(self, flags, swappedSection);
    ASSIGN_ATTR(self, reserved1, swappedSection);
    ASSIGN_ATTR(self, reserved2, swappedSection);
    ASSIGN_ATTR(self, reserved3, swappedSection); // section_64-only
}

@end
