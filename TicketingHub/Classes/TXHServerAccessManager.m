//
//  TXHServerAccessManager.m
//  TicketingHub
//
//  Created by Mark on 09/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHServerAccessManager.h"
#import "TXHDataDownloader.h"
#import "TXHVenue.h"

#define TICKETINGHUB_API @"https://api.ticketingHub.com"

@interface TXHServerAccessManager ()

@property (strong, nonatomic) NSString  *accessToken;
@property (strong, nonatomic) NSString  *refreshToken;

@end

@implementation TXHServerAccessManager

#pragma mark - Singleton implementation

+ (TXHServerAccessManager *)sharedInstance {
  static TXHServerAccessManager *instance;
  
  static dispatch_once_t onceToken;
  
  dispatch_once(&onceToken,
                ^{
                  instance = [[super allocWithZone:nil] init];
                });
  
  return instance;
}

+ (id)allocWithZone:(NSZone *)zone {
#pragma unused(zone)
  return [self sharedInstance];
}

- (id)copyWithZone: (NSZone *)zone {
#pragma unused(zone)
  return self;
}

- (id)init {
  self = [super init];
  if (self) {
    self.accessToken = @"Gop3U0x4lkqDdiPaiVqWVw";
    [self registerForNotifications];
  }
  return self;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)registerForNotifications {
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(willEnterForeground:)
                                               name:UIApplicationWillEnterForegroundNotification
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(willResignActive:)
                                               name:UIApplicationWillResignActiveNotification
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(willTerminate:)
                                               name:UIApplicationWillTerminateNotification
                                             object:nil];
}

- (void)getVenuesWithCompletionHandler:(void (^)(NSArray *))completion errorHandler:(void (^)(id))error {
  TXHDataDownloader *downloader = [[TXHDataDownloader alloc] initWithOwner:self];
  downloader.headerFields = @{@"Authorization" : [NSString stringWithFormat:@"Bearer %@", self.accessToken]};
  downloader.urlString = [NSString stringWithFormat:@"%@/venues", TICKETINGHUB_API];
  downloader.completionHandler = ^(id data){
    NSDictionary *dict = data;
    NSDictionary *payload = dict[@"payload"];
    // Check the payload status for success
    NSNumber *statusNum = payload[@"status"];
    NSUInteger status = statusNum.unsignedIntegerValue;
    if (status == 200) {
      // Success
      NSArray *venues = payload[@"data"];
      [self buildVenues:venues];
      completion(self.venues);
    }
    else if (status == 401) {
      // Check for token expiry
    } else {
      // An error occurred
    }
    /*
     On success (i.e. status=200, we should get back payload data containing an array of venues, such as
     [
     {
     "id": 1000,
     "business_name": "London Eye",
     "street_1": "Millennium Pier",
     "street_2": null,
     "city": "London",
     "region": "London Borough of Lambeth",
     "postal_code": "SE1 7PB",
     "country": "GB",
     "latitude": 51.50361,
     "longitude": -0.11943,
     "currency": "GBP",
     "time_zone": "Europe/London",
     "website": "http://www.londoneye.com",
     "email": "support@londoneye.com",
     "telephone": "+448717813000",
     "stripe_publishable_key": "pk_live_g4RfHyJIdBz7Bs2efWP9dHlW"
     }
     ]
     
     otherwise we will get back a status of 401 with the following
     
     payload =     {
     data =         {
     error = "token_expired";
     "error_message" = "access_token has expired.";
     };
     status = 401;
     };
     
     OR we have a genuine error
     
     */
  };
  downloader.errorHandler = error;
  downloader.token = self.accessToken;
  [downloader execute];
}

- (void)buildVenues:(NSArray *)venues {
  NSMutableArray *venuesArray = [NSMutableArray array];
  for (NSDictionary *venueData in venues) {
    TXHVenue *venue = [[TXHVenue alloc] initWithData:venueData];
    if (venue != nil) {
      [venuesArray addObject:venue];
    }
  }
  self.venues = venuesArray;
}

- (void)generateAccessTokenFor:(NSString *)user password:(NSString *)password completion:(void (^)())completion error:(void (^)(id))error {
  TXHDataDownloader *downloader = [[TXHDataDownloader alloc] initWithOwner:self];
  downloader.methodType = @"POST";
  downloader.urlString = [NSString stringWithFormat:@"%@/tokens", TICKETINGHUB_API];
  downloader.httpPOSTBody = @{
                              @"grant_type" : @"password",
                              @"username" : user,
                              @"password" : password
                              };
  downloader.completionHandler = ^(id data){
    NSDictionary *dict = data;
    NSDictionary *payload = dict[@"payload"];
    NSDictionary *tokens = payload[@"data"];
    /*
     On success (i.e. status=200, we should get back payload data containing
     {
     "access_token": "flydy1m16chf2Zj47Emdtw",
     "refresh_token": "aBaoEyxiYhFccmPQgQpB_qbFUfdG_P3gfwscTV71jLs",
     "expires_in": 3600,
     "token_type": "bearer"
     }
     */
    self.accessToken = tokens[@"access_token"];
    self.refreshToken = tokens[@"refresh_token"];
    completion();
  };
  downloader.errorHandler = error;
  downloader.token = self.accessToken;
  [downloader execute];
}

#pragma mark - Notifications

- (void)willEnterForeground:(NSNotification *)notification {
#pragma unused (notification)
}

- (void)willResignActive:(NSNotification *)notification {
#pragma unused (notification)
}

- (void)willTerminate:(NSNotification *)notification {
#pragma unused (notification)
}


@end
