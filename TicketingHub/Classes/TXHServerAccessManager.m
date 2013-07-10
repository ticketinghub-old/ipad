//
//  TXHServerAccessManager.m
//  TicketingHub
//
//  Created by Mark on 09/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHServerAccessManager.h"
#import "TXHDataDownloader.h"

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

- (void)getVenuesForAccessToken {
  TXHDataDownloader *downloader = [[TXHDataDownloader alloc] initWithOwner:self];
  downloader.headerFields = @{@"Authorization" : [NSString stringWithFormat:@"Bearer %@", self.accessToken]};
  downloader.urlString = [NSString stringWithFormat:@"%@/venues", TICKETINGHUB_API];
  downloader.completionHandler = ^(id data){
    NSDictionary *dict = data;
    NSLog(@"getVenues:%@", dict.description);
  };
  downloader.errorHandler = ^(id sender){
    NSError *error = sender;
    NSLog(@"ERROR: getVenues:%@\n%@", error.description, error.userInfo.description);
  };
  downloader.token = self.accessToken;
  [downloader execute];
}

- (void)generateAccessTokenFor:(NSString *)user password:(NSString *)password {
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
    NSLog(@"token:%@", dict.description);
  };
  downloader.errorHandler = ^(id sender){
    NSError *error = sender;
    NSLog(@"ERROR: generateAccessToken:%@\n%@", error.description, error.userInfo.description);
  };
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
