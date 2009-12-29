#import "MachOSegmentCommandMO.h"
#import "ASSIGN.h"
#import "stuff/bytesex.h"
#import "MachOSegmentSectionMO.h"

@implementation MachOSegmentCommandMO

- (void)setLoadCommand:(struct load_command*)swappedLoadCommand swap:(BOOL)swap {
    [super setLoadCommand:swappedLoadCommand swap:swap];
    switch (swappedLoadCommand->cmd) {
        case LC_SEGMENT: {
            struct segment_command *segmentCommand = (struct segment_command*)swappedLoadCommand;
            
            self.segname = [NSString stringWithUTF8String:segmentCommand->segname];
            ASSIGN_ATTR(self, vmaddr, segmentCommand);
            ASSIGN_ATTR(self, vmsize, segmentCommand);
            ASSIGN_ATTR(self, fileoff, segmentCommand);
            ASSIGN_ATTR(self, filesize, segmentCommand);
            ASSIGN_ATTR(self, maxprot, segmentCommand);
            ASSIGN_ATTR(self, initprot, segmentCommand);
            ASSIGN_ATTR(self, nsects, segmentCommand);
            ASSIGN_ATTR(self, flags, segmentCommand);
            
            struct section *sections = (struct section*)(((char*)segmentCommand)+sizeof(struct segment_command));
            if (swap) {
                swap_section(sections, segmentCommand->nsects, get_host_byte_sex());
            }
            for(uint32_t sectionIndex = 0; sectionIndex < segmentCommand->nsects; sectionIndex++) {
                struct section *sectionIter = &sections[sectionIndex];
                MachOSegmentSectionMO *section = [MachOSegmentSectionMO insertInManagedObjectContext:[self managedObjectContext]];
                
                section.sectname = [NSString stringWithUTF8String:sectionIter->sectname];
                section.segname = [NSString stringWithUTF8String:sectionIter->segname];
                ASSIGN_ATTR(section, addr, sectionIter);
                ASSIGN_ATTR(section, size, sectionIter);
                ASSIGN_ATTR(section, offset, sectionIter);
                ASSIGN_ATTR(section, align, sectionIter);
                ASSIGN_ATTR(section, reloff, sectionIter);
                ASSIGN_ATTR(section, nreloc, sectionIter);
                ASSIGN_ATTR(section, flags, sectionIter);
                ASSIGN_ATTR(section, reserved1, sectionIter);
                ASSIGN_ATTR(section, reserved2, sectionIter);
                
                NSLog(@"section: %@", section);
                [self addSectionsObject:section];
            }
        }   break;
        case LC_SEGMENT_64: {
            struct segment_command_64 *segmentCommand = (struct segment_command_64*)swappedLoadCommand;
            
            self.segname = [NSString stringWithUTF8String:segmentCommand->segname];
            ASSIGN_ATTR(self, vmaddr, segmentCommand);
            ASSIGN_ATTR(self, vmsize, segmentCommand);
            ASSIGN_ATTR(self, fileoff, segmentCommand);
            ASSIGN_ATTR(self, filesize, segmentCommand);
            ASSIGN_ATTR(self, maxprot, segmentCommand);
            ASSIGN_ATTR(self, initprot, segmentCommand);
            ASSIGN_ATTR(self, nsects, segmentCommand);
            ASSIGN_ATTR(self, flags, segmentCommand);
            
            struct section_64 *sections = (struct section_64*)(((char*)segmentCommand)+sizeof(struct segment_command_64));
            if (swap) {
                swap_section_64(sections, segmentCommand->nsects, get_host_byte_sex());
            }
            for(uint32_t sectionIndex = 0; sectionIndex < segmentCommand->nsects; sectionIndex++) {
                struct section_64 *sectionIter = &sections[sectionIndex];
                MachOSegmentSectionMO *section = [MachOSegmentSectionMO insertInManagedObjectContext:[self managedObjectContext]];
                
                section.sectname = [NSString stringWithUTF8String:sectionIter->sectname];
                section.segname = [NSString stringWithUTF8String:sectionIter->segname];
                ASSIGN_ATTR(section, addr, sectionIter);
                ASSIGN_ATTR(section, size, sectionIter);
                ASSIGN_ATTR(section, offset, sectionIter);
                ASSIGN_ATTR(section, align, sectionIter);
                ASSIGN_ATTR(section, reloff, sectionIter);
                ASSIGN_ATTR(section, nreloc, sectionIter);
                ASSIGN_ATTR(section, flags, sectionIter);
                ASSIGN_ATTR(section, reserved1, sectionIter);
                ASSIGN_ATTR(section, reserved2, sectionIter);
                ASSIGN_ATTR(section, reserved3, sectionIter);
                
                NSLog(@"section: %@", section);
                [self addSectionsObject:section];
            }
        }   break;
        default:
            assert(!"unknown swappedLoadCommand->cmd code");
    }
}

@end
