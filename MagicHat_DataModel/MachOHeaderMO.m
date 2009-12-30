#import "MachOHeaderMO.h"
#import "MachOCommandMO.h"
#import "ASSIGN.h"

@implementation MachOHeaderMO
@synthesize swap;

- (void)processOFile:(struct ofile*)ofile; {
    assert(ofile->mh || ofile->mh64);
    uint32_t ncmds, sizeofcmds;
    if (ofile->mh) {
        ASSIGN_ATTR(self, magic, ofile->mh);
        ASSIGN_ATTR(self, cputype, ofile->mh);
        ASSIGN_ATTR(self, cpusubtype, ofile->mh);
        ASSIGN_ATTR(self, filetype, ofile->mh);
        ASSIGN_ATTR(self, flags, ofile->mh);
        ncmds = ofile->mh->ncmds;
        sizeofcmds = ofile->mh->sizeofcmds;
    } else {
        ASSIGN_ATTR(self, magic, ofile->mh64);
        ASSIGN_ATTR(self, cputype, ofile->mh64);
        ASSIGN_ATTR(self, cpusubtype, ofile->mh64);
        ASSIGN_ATTR(self, filetype, ofile->mh64);
        ASSIGN_ATTR(self, flags, ofile->mh64);
        ncmds = ofile->mh64->ncmds;
        sizeofcmds = ofile->mh64->sizeofcmds;
    }
    
    self.swap = ofile->object_byte_sex != get_host_byte_sex();
    
    //--
    
    struct load_command *load_command_iter = ofile->load_commands;
    for (uint32_t cmdIndex = 0; cmdIndex < ncmds; cmdIndex++) {
        MachOCommandMO *command = [MachOCommandMO commandWithOriginalLoadCommand:load_command_iter header:self];
        
        load_command_iter = (struct load_command*)(((char*)load_command_iter) + [command cmdsizeValue]);
    }
}

@end
