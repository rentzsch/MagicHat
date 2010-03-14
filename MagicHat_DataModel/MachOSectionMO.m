#import "MachOSectionMO.h"
#import "MachOSegmentCommandMO.h"
#import "MachOHeaderMO.h"
#import "MachOFileMO.h"

@implementation MachOSectionMO

- (NSData*)sectionData {
    const char *fileDataPtr = [self.segment.header.file.fileData bytes];
    const char *sectionDataPtr = fileDataPtr + self.segment.header.offsetValue + self.offsetValue;
    return [NSData dataWithBytesNoCopy:(void*)sectionDataPtr length:self.sizeValue freeWhenDone:NO];
}

@end
