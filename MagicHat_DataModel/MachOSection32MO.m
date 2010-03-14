#import "MachOSection32MO.h"
/*#import "MachOSegmentCommandMO.h"
#import "MachOClassesSectionMO.h"
#import "NSString+jr_stringWithUTF8StringmaxLength.h"*/
#import "ASSIGN.h"

@implementation MachOSection32MO

+ (id)sectionWithSection32:(struct section*)swappedSection segment:(MachOSegmentCommandMO*)segment {
    assert(!"TODO");
    return nil;
    /*NSString *sectionName = [NSString jr_stringWithUTF8String:swappedSection->sectname maxLength:sizeof(swappedSection->sectname)];
    Class   section_class = [sectionName isEqualToString:@"__objc_classlist"] ? [MachOClassesSectionMO class] : [MachOSectionMO class];
    
    MachOSectionMO *section = [section_class insertInManagedObjectContext:[segment managedObjectContext]];
    [segment addSectionsObject:section];
    [section setSection:swappedSection];
    return section;*/
}

- (void)setSection32:(struct section*)swappedSection {
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
}

@end
