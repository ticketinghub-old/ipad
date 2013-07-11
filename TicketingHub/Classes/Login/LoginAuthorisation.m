//
//  LoginAuthorisation.m
//  TicketingHub
//
//  Created by Mark Brindle on 08/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

/*
 Authentication
 Every request must contain the `access_token` parameter which the reseller can find from the venue contract page or once the OAuth2 Handshake has been authorised by the user.
 
 data access endpoint
 https://api.ticketinghub.com
 
 */

#import "LoginAuthorisation.h"
#import "TXHCommonNames.h"

@interface LoginAuthorisation () <NSURLConnectionDelegate>

@property (nonatomic, strong) NSString        *username;
@property (nonatomic, strong) NSString        *clientId;
@property (nonatomic, strong) NSString        *accessToken;
@property (nonatomic, strong) NSString        *refreshToken;

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData   *receivedData;
@property (nonatomic, readwrite) NSInteger    statusCode;

@property (nonatomic, strong) NSString        *errorString;
@property (nonatomic, strong) NSError         *dataError;

@property (nonatomic, strong) NSString        *mode;

@end

@implementation LoginAuthorisation

+ (NSString *)apiEndPoint {
  return @"https://api.ticketingHub.com";
}

- (id)init {
//  NSLog(@"%s", __FUNCTION__);
  self = [super init];
  if (self) {
    [self setup];
  }
  return self;
}

- (void)setup {
//  NSLog(@"%s", __FUNCTION__);
  
  /*
   New info:-
   
   client_id: rmwz93ixi5kos7t0b4gb1x59emyfstx
   redirect_url: http://auth.ticketingHub.com/test_oauth2
   
 */
  
  self.ticketingHubAuthorisation  = @"https://auth.ticketingHub.com";
  self.ticketingHubRedirect       = @"http://auth.ticketingHub.com/test_oauth2";
  
  
  self.ticketingHubAPI            = @"https://api.ticketingHub.com";
  
  self.clientId                   = @"rmwz93ixi5kos7t0b4gb1x59emyfstx";
  self.username                   = @"";
  
  // Fixed for prototyping purposes 
  _accessToken = @"-AhfMlNIR7_UQpYvMP4Yfw";
}

- (NSString *)encodeToPercentEscapeString:(NSString *)string {
  return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                               (CFStringRef) string,
                                                                               NULL,
                                                                               (CFStringRef) @"!*'();:@&=+$,/?%#[]",
                                                                               kCFStringEncodingUTF8));
}

- (void):(NSString *)token {
  NSString *urlString = [NSString stringWithFormat:@"%@?oauth_token=%@",
                         [self.ticketingHubAuthorisation stringByAppendingPathComponent:@"test_oauth2"],
                         token];
  
//  NSLog(@"%s - mode:%@ request:%@", __FUNCTION__, self.mode, urlString);
  
  NSURL *url = [NSURL URLWithString:urlString];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                         cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                     timeoutInterval:60.0];
  
  [request setHTTPMethod:@"GET"];
  
  self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
  if (self.connection) {
    // Create NSMutable data to hold received data
    self.receivedData = [NSMutableData data];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
  }
}

#pragma mark - NSURLConnection delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
//  NSLog(@"%s - mode:%@", __FUNCTION__, self.mode);
  NSHTTPURLResponse *httpResponse;
  self.receivedData.length = 0;

  assert(connection == self.connection);
  
  httpResponse = (NSHTTPURLResponse *) response;
  
  assert( [httpResponse isKindOfClass:[NSHTTPURLResponse class]] );
  
  self.statusCode = [httpResponse statusCode];
  if ((httpResponse.statusCode / 100) != 2) {
    // We got an error - if it's a 403 we should receive data; otherwise trigger a response error
    if (self.statusCode != 403) {
      self.errorString = httpResponse.allHeaderFields[@"Status"];
//      NSLog(@"%s - %@ - We got an error - %@", __FUNCTION__, self.mode, httpResponse.allHeaderFields);
      [[NSNotificationCenter defaultCenter] postNotificationName:@"com.ticketingHub.authentication.didReceiveResponseError" object:self.errorString];
    }
  }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
#pragma unused (connection)
//  NSLog(@"%s - mode:%@", __FUNCTION__, self.mode);
  [self.receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
#pragma unused (connection)
  NSString *authenticationString = @"com.ticketingHub.authentication.didFinishLoading";
  NSMutableDictionary *authenticationObject = [NSMutableDictionary dictionary];
  
  if (self.receivedData.length > 0) {
    id resultsData = [NSJSONSerialization
                      JSONObjectWithData:self.receivedData
                      options:0
                      error:nil];
    if ([resultsData isKindOfClass:[NSDictionary class]]) {
      authenticationObject[@"data"] = resultsData;
    } else {
      NSString *resultString = [[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding];
      authenticationObject[@"dataString"] = resultString;
    }
    authenticationObject[@"mode"] = self.mode;
    authenticationObject[@"status"] = @(self.statusCode);
  }
  [self cleanup];
  
  NSDictionary *payload = @{@"payload": authenticationObject};

  [[NSNotificationCenter defaultCenter] postNotificationName:authenticationString object:payload];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
#pragma unused (connection)
//  NSLog(@"%s", __FUNCTION__);
  self.dataError = [error copy];
  [self cleanup];
  [[NSNotificationCenter defaultCenter] postNotificationName:@"com.ticketingHub.authentication.didFailWithError" object:[error copy]];
}

- (void) cleanup {
//  NSLog(@"%s", __FUNCTION__);
  if (self.connection) {
    [self.connection cancel];
    self.connection = nil;
  }
  
  self.receivedData = nil;
  
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

@end
