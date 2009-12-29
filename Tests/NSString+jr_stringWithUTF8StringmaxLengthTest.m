#import "NSString+jr_stringWithUTF8StringmaxLengthTest.h"
#import "NSString+jr_stringWithUTF8StringmaxLength.h"

@implementation NSString_jr_stringWithUTF8StringmaxLengthTest

- (void)testMaxLength {
    char *cstr = "ab";
    NSString *str;
    
    str = [NSString jr_stringWithUTF8String:cstr maxLength:0];
    STAssertNotNil(str, nil);
    STAssertEquals([str length], (NSUInteger)0, nil);
    STAssertEqualObjects(str, @"", nil);
    
    str = [NSString jr_stringWithUTF8String:cstr maxLength:1];
    STAssertNotNil(str, nil);
    STAssertEquals([str length], (NSUInteger)1, nil);
    STAssertEqualObjects(str, @"a", nil);
    
    str = [NSString jr_stringWithUTF8String:cstr maxLength:2];
    STAssertNotNil(str, nil);
    STAssertEquals([str length], (NSUInteger)2, nil);
    STAssertEqualObjects(str, @"ab", nil);
    
    str = [NSString jr_stringWithUTF8String:cstr maxLength:3];
    STAssertNotNil(str, nil);
    STAssertEquals([str length], (NSUInteger)2, nil);
    STAssertEqualObjects(str, @"ab", nil);
}

@end
