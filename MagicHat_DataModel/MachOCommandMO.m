#import "MachOCommandMO.h"
#import "stuff/bytesex.h"
#import "MachOSegmentCommandMO.h"

typedef void (*load_command_swap_proc)(void *load_command, enum byte_sex target_byte_sex);

@implementation MachOCommandMO

+ (id)commandWithLoadCommand:(struct load_command*)originalLoadCommand swap:(BOOL)swap inManagedObjectContext:(NSManagedObjectContext*)moc {
    struct load_command minimalSwappedLoadCommand;
    bcopy(originalLoadCommand, &minimalSwappedLoadCommand, sizeof(struct load_command));
    if (swap) {
        swap_load_command(&minimalSwappedLoadCommand, get_host_byte_sex());
    }

    NSString                *command_name;
    load_command_swap_proc  command_swapper;
    Class                   command_class = [MachOCommandMO class];
    
    switch (minimalSwappedLoadCommand.cmd) {
        case LC_SEGMENT:
            command_name = @"LC_SEGMENT";
            command_swapper = (load_command_swap_proc)swap_segment_command;
            command_class = [MachOSegmentCommandMO class];
            break;
        case LC_SYMTAB:
            command_name = @"LC_SYMTAB";
            command_swapper = (load_command_swap_proc)swap_symtab_command;
            break;
        case LC_SYMSEG:
            command_name = @"LC_SYMSEG";
            command_swapper = (load_command_swap_proc)swap_symseg_command;
            break;
        case LC_THREAD:
            command_name = @"LC_THREAD";
            command_swapper = (load_command_swap_proc)swap_thread_command;
            break;
        case LC_UNIXTHREAD:
            command_name = @"LC_UNIXTHREAD";
            command_swapper = (load_command_swap_proc)swap_thread_command;
            break;
        case LC_LOADFVMLIB:
            command_name = @"LC_LOADFVMLIB";
            command_swapper = (load_command_swap_proc)swap_fvmlib_command;
            break;
        case LC_IDFVMLIB:
            command_name = @"LC_IDFVMLIB";
            command_swapper = (load_command_swap_proc)swap_fvmlib_command;
            break;
        case LC_IDENT:
            command_name = @"LC_IDENT";
            command_swapper = (load_command_swap_proc)swap_ident_command;
            break;
        case LC_FVMFILE:
            command_name = @"LC_FVMFILE";
            command_swapper = (load_command_swap_proc)swap_fvmfile_command;
            break;
        case LC_PREPAGE:
            command_name = @"LC_PREPAGE";
            command_swapper = (load_command_swap_proc)swap_load_command; // LC_PREPAGE doesn't have an associated public struct.
            break;
        case LC_DYSYMTAB:
            command_name = @"LC_DYSYMTAB";
            command_swapper = (load_command_swap_proc)swap_dysymtab_command;
            break;
        case LC_LOAD_DYLIB:
            command_name = @"LC_LOAD_DYLIB";
            command_swapper = (load_command_swap_proc)swap_dylib_command;
            break;
        case LC_ID_DYLIB:
            command_name = @"LC_ID_DYLIB";
            command_swapper = (load_command_swap_proc)swap_dylib_command;
            break;
        case LC_LOAD_DYLINKER:
            command_name = @"LC_LOAD_DYLINKER";
            command_swapper = (load_command_swap_proc)swap_dylinker_command;
            break;
        case LC_ID_DYLINKER:
            command_name = @"LC_ID_DYLINKER";
            command_swapper = (load_command_swap_proc)swap_dylinker_command;
            break;
        case LC_PREBOUND_DYLIB:
            command_name = @"LC_PREBOUND_DYLIB";
            command_swapper = (load_command_swap_proc)swap_prebound_dylib_command;
            break;
        case LC_ROUTINES:
            command_name = @"LC_ROUTINES";
            command_swapper = (load_command_swap_proc)swap_routines_command;
            break;
        case LC_SUB_FRAMEWORK:
            command_name = @"LC_SUB_FRAMEWORK";
            command_swapper = (load_command_swap_proc)swap_sub_framework_command;
            break;
        case LC_SUB_UMBRELLA:
            command_name = @"LC_SUB_UMBRELLA";
            command_swapper = (load_command_swap_proc)swap_sub_umbrella_command;
            break;
        case LC_SUB_CLIENT:
            command_name = @"LC_SUB_CLIENT";
            command_swapper = (load_command_swap_proc)swap_sub_client_command;
            break;
        case LC_SUB_LIBRARY:
            command_name = @"LC_SUB_LIBRARY";
            command_swapper = (load_command_swap_proc)swap_sub_library_command;
            break;
        case LC_TWOLEVEL_HINTS:
            command_name = @"LC_TWOLEVEL_HINTS";
            command_swapper = (load_command_swap_proc)swap_twolevel_hints_command;
            break;
        case LC_PREBIND_CKSUM:
            command_name = @"LC_PREBIND_CKSUM";
            command_swapper = (load_command_swap_proc)swap_prebind_cksum_command;
            break;
        case LC_LOAD_WEAK_DYLIB:
            command_name = @"LC_LOAD_WEAK_DYLIB";
            command_swapper = (load_command_swap_proc)swap_dylib_command;
            break;
        case LC_SEGMENT_64:
            command_name = @"LC_SEGMENT_64";
            command_swapper = (load_command_swap_proc)swap_segment_command_64;
            command_class = [MachOSegmentCommandMO class];
            break;
        case LC_ROUTINES_64:
            command_name = @"LC_ROUTINES_64";
            command_swapper = (load_command_swap_proc)swap_routines_command_64;
            break;
        case LC_UUID:
            command_name = @"LC_UUID";
            command_swapper = (load_command_swap_proc)swap_uuid_command;
            break;
        case LC_RPATH:
            command_name = @"LC_RPATH";
            command_swapper = (load_command_swap_proc)swap_rpath_command;
            break;
        case LC_CODE_SIGNATURE:
            command_name = @"LC_CODE_SIGNATURE";
            command_swapper = (load_command_swap_proc)swap_linkedit_data_command;
            break;
        case LC_SEGMENT_SPLIT_INFO:
            command_name = @"LC_SEGMENT_SPLIT_INFO";
            command_swapper = (load_command_swap_proc)swap_linkedit_data_command;
            break;
        case LC_REEXPORT_DYLIB:
            command_name = @"LC_REEXPORT_DYLIB";
            command_swapper = (load_command_swap_proc)swap_dylib_command;
            break;
        case LC_LAZY_LOAD_DYLIB:
            command_name = @"LC_LAZY_LOAD_DYLIB";
            command_swapper = (load_command_swap_proc)swap_load_command; // LC_LAZY_LOAD_DYLIB doesn't seem to have an associated struct?
            break;
        case LC_ENCRYPTION_INFO:
            command_name = @"LC_ENCRYPTION_INFO";
            command_swapper = (load_command_swap_proc)swap_encryption_command;
            break;
        case LC_DYLD_INFO:
            command_name = @"LC_DYLD_INFO";
            command_swapper = (load_command_swap_proc)swap_dyld_info_command;
            break;
        case LC_DYLD_INFO_ONLY:
            command_name = @"LC_DYLD_INFO_ONLY";
            command_swapper = (load_command_swap_proc)swap_dyld_info_command;
            break;
        default:
            command_name = [NSString stringWithFormat:@"unknown command (%#lx)", minimalSwappedLoadCommand.cmd];
            command_swapper = (load_command_swap_proc)swap_load_command;
    }
    
    MachOCommandMO *command = [command_class insertInManagedObjectContext:moc];
    
    struct load_command *swappedLoadCommand;
    if (swap) {
        swappedLoadCommand = malloc(originalLoadCommand->cmdsize);
        bcopy(originalLoadCommand, swappedLoadCommand, originalLoadCommand->cmdsize);
        command_swapper(swappedLoadCommand, get_host_byte_sex());
    } else {
        swappedLoadCommand = originalLoadCommand;
    }
    
    [command setName:command_name];
    [command setLoadCommand:swappedLoadCommand swap:swap];
    
    if (swap) {
        free(swappedLoadCommand);
    }
    return command;
}

- (void)setLoadCommand:(struct load_command*)swappedLoadCommand swap:(BOOL)swap {
    [self setCmdValue:swappedLoadCommand->cmd];
    [self setCmdsizeValue:swappedLoadCommand->cmdsize];
}

@end
