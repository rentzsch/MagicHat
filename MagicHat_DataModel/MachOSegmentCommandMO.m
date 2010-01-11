#import "MachOSegmentCommandMO.h"
#import "MachOHeaderMO.h"
#import "ASSIGN.h"
#import "stuff/bytesex.h"
#import "MachOSectionMO.h"
#import "NSString+jr_stringWithUTF8StringmaxLength.h"

@implementation MachOSegmentCommandMO

- (void)setLoadCommand:(struct load_command*)swappedLoadCommand {
    [super setLoadCommand:swappedLoadCommand];
    switch (swappedLoadCommand->cmd) {
        case LC_SEGMENT: {
            struct segment_command *segmentCommand = (struct segment_command*)swappedLoadCommand;
            
            self.segname = [NSString jr_stringWithUTF8String:segmentCommand->segname maxLength:sizeof(segmentCommand->segname)];
            ASSIGN_ATTR(self, vmaddr, segmentCommand);
            ASSIGN_ATTR(self, vmsize, segmentCommand);
            ASSIGN_ATTR(self, fileoff, segmentCommand);
            ASSIGN_ATTR(self, filesize, segmentCommand);
            ASSIGN_ATTR(self, maxprot, segmentCommand);
            ASSIGN_ATTR(self, initprot, segmentCommand);
            ASSIGN_ATTR(self, nsects, segmentCommand);
            ASSIGN_ATTR(self, flags, segmentCommand);
            
            struct section *sections = (struct section*)(((char*)segmentCommand)+sizeof(struct segment_command));
            if (self.header.swap) {
                swap_section(sections, segmentCommand->nsects, get_host_byte_sex());
            }
            for(uint32_t sectionIndex = 0; sectionIndex < segmentCommand->nsects; sectionIndex++) {
                struct section *sectionIter = &sections[sectionIndex];
                [MachOSectionMO sectionWithSection:sectionIter segment:self];
            }
        }   break;
        case LC_SEGMENT_64: {
            struct segment_command_64 *segmentCommand = (struct segment_command_64*)swappedLoadCommand;
            
            self.segname = [NSString jr_stringWithUTF8String:segmentCommand->segname maxLength:sizeof(segmentCommand->segname)];
            ASSIGN_ATTR(self, vmaddr, segmentCommand);
            ASSIGN_ATTR(self, vmsize, segmentCommand);
            ASSIGN_ATTR(self, fileoff, segmentCommand);
            ASSIGN_ATTR(self, filesize, segmentCommand);
            ASSIGN_ATTR(self, maxprot, segmentCommand);
            ASSIGN_ATTR(self, initprot, segmentCommand);
            ASSIGN_ATTR(self, nsects, segmentCommand);
            ASSIGN_ATTR(self, flags, segmentCommand);
            
            struct section_64 *sections = (struct section_64*)(((char*)segmentCommand)+sizeof(struct segment_command_64));
            if (self.header.swap) {
                swap_section_64(sections, segmentCommand->nsects, get_host_byte_sex());
            }
            for(uint32_t sectionIndex = 0; sectionIndex < segmentCommand->nsects; sectionIndex++) {
                struct section_64 *sectionIter = &sections[sectionIndex];
                
                [MachOSectionMO sectionWithSection64:sectionIter segment:self];
            }
        }   break;
        default:
            assert(!"unknown swappedLoadCommand->cmd code");
    }
}

@end
