#import "MachOFileMO.h"
#include "stuff/ofile.h"
#include "stuff/allocate.h"
#include "otool/ofile_print.h"
#import "MachOHeaderMO.h"
#import "MachOCommandMO.h"

char *progname = "my_progname";

@interface MachOFileMO ()
- (void)processOFile:(struct ofile*)ofile archName:(char*)archName;
@end

void ofile_processor(struct ofile *ofile, char *arch_name, void *cookie) {
    [(MachOFileMO*)cookie processOFile:ofile archName:arch_name];
}

@implementation MachOFileMO

- (BOOL)setFileURL:(NSURL*)url_ error:(NSError**)error_ {
#define kArchFlagCount  64
    struct arch_flag arch_flags[kArchFlagCount];
    
    ofile_process(
        (char*)[[url_ path] fileSystemRepresentation], //  name
        arch_flags,       //  arch_flags
        kArchFlagCount,   //  narch_flags
        TRUE,             //  all_archs
        TRUE,             //  process_non_objects
        TRUE,             //  dylib_flat
        TRUE,             //  use_member_syntax
        ofile_processor,  //  processor
        self);            //  cookie
    
    return YES;
}

#define ASSIGN(RECEIVER, KEY, SOURCE) RECEIVER.KEY = [NSNumber numberWithUnsignedInt:(SOURCE)->KEY]

- (void)processOFile:(struct ofile*)ofile archName:(char*)arch_name {
    if(ofile->mh == NULL && ofile->mh64 == NULL)
	    return;
    
    MachOHeaderMO *header = [MachOHeaderMO insertInManagedObjectContext:[self managedObjectContext]];
    [self addHeadersObject:header];
    header.archName = [NSString stringWithUTF8String:arch_name];
    
    assert(ofile->mh || ofile->mh64);
    uint32_t ncmds, sizeofcmds;
    if (ofile->mh) {
        ASSIGN(header, magic, ofile->mh);
        ASSIGN(header, cputype, ofile->mh);
        ASSIGN(header, cpusubtype, ofile->mh);
        ASSIGN(header, filetype, ofile->mh);
        ASSIGN(header, flags, ofile->mh);
        ncmds = ofile->mh->ncmds;
        sizeofcmds = ofile->mh->sizeofcmds;
    } else {
        ASSIGN(header, magic, ofile->mh64);
        ASSIGN(header, cputype, ofile->mh64);
        ASSIGN(header, cpusubtype, ofile->mh64);
        ASSIGN(header, filetype, ofile->mh64);
        ASSIGN(header, flags, ofile->mh64);
        ncmds = ofile->mh64->ncmds;
        sizeofcmds = ofile->mh64->sizeofcmds;
    }
    
    enum byte_sex host_byte_sex = get_host_byte_sex();
    BOOL swap = ofile->object_byte_sex != host_byte_sex;
    
    //--
    
    struct load_command *load_command_iter = ofile->load_commands;
    for (uint32_t cmdIndex = 0; cmdIndex < ncmds; cmdIndex++) {
        MachOCommandMO *command = [MachOCommandMO commandWithLoadCommand:load_command_iter swap:swap inManagedObjectContext:[self managedObjectContext]];
        NSLog(@"command: %@", command);
        [header addCommandsObject:command];
        load_command_iter = (struct load_command*)(((char*)load_command_iter) + [command cmdsizeValue]);
    }
    
    //--
    NSLog(@"header: %@", header);
}

@end
