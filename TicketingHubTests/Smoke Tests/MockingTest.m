//
//  MockingTest.m
// 

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

@interface MockingTest : XCTestCase
@end


@implementation MockingTest

- (void)testOCMockFunctions {
    id mock = [OCMockObject mockForClass:[NSString class]];

    [[mock expect] uppercaseString];

    // Uncomment the following line to make the test pass
    [mock uppercaseString];

    [mock verify];
}

@end
