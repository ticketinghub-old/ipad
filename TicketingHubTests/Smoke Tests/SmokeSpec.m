//
//  SmokeSpec.m
//

#define EXP_SHORTHAND

#import <Specta/Specta.h>
#import <Expecta/Expecta.h>

SpecBegin(SmokeTest)

describe(@"Smoke Test", ^{
    it(@"should fail at first", ^{
        NSString *str = @"Hello";

        // Uncomment the following line to make the test pass
        str = @"Goodbye";

        expect(str).to.equal(@"Goodbye");
    });
});


SpecEnd
