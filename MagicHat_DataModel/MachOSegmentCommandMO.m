#import "MachOSegmentCommandMO.h"
#import "ASSIGN.h"

@implementation MachOSegmentCommandMO

- (void)setLoadCommand:(struct load_command*)swappedLoadCommand {
    [super setLoadCommand:swappedLoadCommand];
    switch (swappedLoadCommand->cmd) {
        case LC_SEGMENT: {
            struct segment_command *segmentCommand = (struct segment_command*)swappedLoadCommand;
            
            char segname[17];
            segname[16] = 0;
            bcopy(segmentCommand->segname, segname, sizeof(char[16]));
            self.segname = [NSString stringWithUTF8String:segname];
            
            ASSIGN_ATTR(self, vmaddr, segmentCommand);
            ASSIGN_ATTR(self, vmsize, segmentCommand);
            ASSIGN_ATTR(self, fileoff, segmentCommand);
            ASSIGN_ATTR(self, filesize, segmentCommand);
            ASSIGN_ATTR(self, maxprot, segmentCommand);
            ASSIGN_ATTR(self, initprot, segmentCommand);
            ASSIGN_ATTR(self, nsects, segmentCommand);
            ASSIGN_ATTR(self, flags, segmentCommand);
            
            
        }   break;
        case LC_SEGMENT_64: {
            struct segment_command_64 *segmentCommand = (struct segment_command_64*)swappedLoadCommand;
            
            char segname[17];
            segname[16] = 0;
            bcopy(segmentCommand->segname, segname, sizeof(char[16]));
            self.segname = [NSString stringWithUTF8String:segname];
            
            ASSIGN_ATTR(self, vmaddr, segmentCommand);
            ASSIGN_ATTR(self, vmsize, segmentCommand);
            ASSIGN_ATTR(self, fileoff, segmentCommand);
            ASSIGN_ATTR(self, filesize, segmentCommand);
            ASSIGN_ATTR(self, maxprot, segmentCommand);
            ASSIGN_ATTR(self, initprot, segmentCommand);
            ASSIGN_ATTR(self, nsects, segmentCommand);
            ASSIGN_ATTR(self, flags, segmentCommand);
            
            
        }   break;
        default:
            assert(!"unknown swappedLoadCommand->cmd code");
    }
}

@end
