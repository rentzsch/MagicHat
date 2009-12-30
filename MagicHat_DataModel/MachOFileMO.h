#import "_MachOFileMO.h"

@interface MachOFileMO : _MachOFileMO {}
@property (retain) NSData *fileData;

- (BOOL)parseFileURL:(NSURL*)url_ error:(NSError**)error_;

@end
