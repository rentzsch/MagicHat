#import "_MachOHeaderMO.h"
#include "stuff/ofile.h"

@interface MachOHeaderMO : _MachOHeaderMO {}
@property BOOL swap;

- (void)processOFile:(struct ofile*)ofile;

@end
