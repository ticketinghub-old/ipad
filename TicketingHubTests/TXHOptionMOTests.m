//
//  TXHOptionMOTests.m
//  TicketingHub
//
//  Created by Abizer Nasir on 20/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>


#import "DCTCoreDataStack.h"
#import "TXHOption.h"
#import "TXHOptionMO.h"
#import "TXHVenue.h"
#import "TXHVenueMO.h"

@interface TXHOptionMOTests : SenTestCase

@property (strong, readonly, nonatomic) TXHOption *option;
@property (strong, readonly, nonatomic) TXHVenueMO *venueMO;
@property (strong, readonly, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

@implementation TXHOptionMOTests

- (void)setUp {
    [super setUp];

    // Stand up the stack
    NSDictionary *options = @{DCTCoreDataStackExcludeFromBackupStoreOption : @YES,
                              NSMigratePersistentStoresAutomaticallyOption : @YES,
                              NSInferMappingModelAutomaticallyOption : @YES};

    NSURL *documentDirectoryURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL = [documentDirectoryURL URLByAppendingPathComponent:@"TicktingHub.sqlite"];

    DCTCoreDataStack *coreDataStack = [[DCTCoreDataStack alloc] initWithStoreURL:storeURL storeType:NSInMemoryStoreType storeOptions:options modelConfiguration:nil modelURL:nil];

    _managedObjectContext = coreDataStack.managedObjectContext;

    // Set up support objects

    NSDictionary *optionDictionary = @{@"wday": @1,
                                       @"time": @"09:00",
                                       @"duration" : @"PT1H"};

    _option = [TXHOption createWithDictionary:optionDictionary];


    NSDictionary *venueDictionary = @{@"city": @"c",
                                      @"country": @"GB",
                                      @"currency": @"GBP",
                                      @"email": [NSNull null],
                                      @"establishment_type": [NSNull null],
                                      @"id": @99,
                                      @"latitude": @55.378050999999999,
                                      @"longitude": @(-3.4359730000000002),
                                      @"name": @"My Venue 1",
                                      @"permissions": @[@"salesman" ,@"doorman"],
                                      @"postcode": @"e",
                                      @"region": @"d",
                                      @"street_1": @"a",
                                      @"street_2": @"b",
                                      @"stripe_publishable_key": @"pk_live_g4RfHyJIdBz7Bs2efWP9dHlW",
                                      @"telephone": [NSNull null],
                                      @"time_zone": @"Europe/London",
                                      @"website": [NSNull null]};

    TXHVenue *venue = [TXHVenue createWithDictionary:venueDictionary];

    _venueMO = [TXHVenueMO venueWithObjectCreateIfNeeded:venue inManagedObjectContext:_managedObjectContext];

}

- (void)tearDown {
    [super tearDown];

    _managedObjectContext = nil;
}


- (void) testCreationFromTXHOption {
    STAssertTrue(self.option, @"Option should exist");
    STAssertTrue(self.venueMO, @"Venue should exist");

    TXHOptionMO *optionMO = [TXHOptionMO createWithOption:self.option forVenue:self.venueMO];

    STAssertTrue(optionMO, @"Should have created an option managed object");

    STAssertTrue(optionMO.weekdayIndexValue == 1, @"Weekday set");
    STAssertEqualObjects(optionMO.duration, self.option.duration, @"Should be equal");
    STAssertEqualObjects(optionMO.timeString, self.option.timeString, @"Time should be set");
    STAssertTrue(optionMO.venue, @"Venue relationship object should exist");

}

@end
