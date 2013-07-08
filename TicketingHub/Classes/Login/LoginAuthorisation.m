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

@synthesize identityToken = _identityToken;

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
  self.ticketingHubManagement     = @"https://api.ticketingHub.com";       // @"http://management.staging.ticketingHub.com";
  self.ticketingHubData           = @"https://data.ticketingHub.com";             // @"http://data.staging.ticketingHub.com";
  
  self.clientId                 = @"rmwz93ixi5kos7t0b4gb1x59emyfstx";         // @"frlidd0bwgrr2qx6hlsica3vwjea1pf";
  
  self.username                 = @"";
}

- (NSUUID *)identityToken {
//  NSLog(@"%s", __FUNCTION__);
  if (_identityToken == nil) {
    _identityToken = [[UIDevice currentDevice] identifierForVendor];
  }
  return _identityToken;
}

- (void)validateUser:(NSString *)user withPassword:(NSString *)password {
//  NSLog(@"%s", __FUNCTION__);
  self.username = user;
  [self fetchAccessTokenFor:password];
}

- (NSString *)encodeToPercentEscapeString:(NSString *)string {
  return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                               (CFStringRef) string,
                                                                               NULL,
                                                                               (CFStringRef) @"!*'();:@&=+$,/?%#[]",
                                                                               kCFStringEncodingUTF8));
}

- (void)fetchAccessTokenFor:(NSString *)password {
//  NSLog(@"%s", __FUNCTION__);
  self.mode = AUTH_MODE_LOGIN;
  NSURL *url = [NSURL URLWithString:[self.ticketingHubAuthorisation stringByAppendingPathComponent:@"get_oauth2_token"]];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                         cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                     timeoutInterval:60.0];
  
  [request setHTTPMethod:@"POST"];
  NSString *postString = [NSString stringWithFormat:@"user[email]=%@&user[password]=%@&response_type=token&client_id=%@&device_id=%@&redirect_uri=%@",
                          [self encodeToPercentEscapeString:self.username],
                          [self encodeToPercentEscapeString:password],
                          [self.clientId stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                          [self.identityToken.UUIDString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                          [self.ticketingHubRedirect stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
  
//  NSLog(@"%s - %@", __FUNCTION__, postString);
  
  [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
  
  self.connection= [[NSURLConnection alloc] initWithRequest:request delegate:self];
  if (self.connection) {
    // Create NSMutable data to hold received data
    self.receivedData = [NSMutableData data];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
  }
}

- (void)verifyToken:(NSString *)token {
  self.mode = AUTH_MODE_VERIFY;
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

- (void)verifyMixPanel:(NSString *)token {
//  NSLog(@"%s", __FUNCTION__);
  self.mode = AUTH_MODE_MIXPANEL;
  
  NSString *urlString = [NSString stringWithFormat:@"%@/?oauth_token=%@",
                         [self.ticketingHubManagement stringByAppendingPathComponent:@"user"],
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

#pragma unused(connection)

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
//    NSLog(@"%s - got results: %@", __FUNCTION__, authenticationObject.description);
    if ((self.statusCode / 100) == 2) {
      if ([self.mode isEqualToString:AUTH_MODE_LOGIN]) {
        NSDictionary *tokens = authenticationObject[@"data"];
        self.accessToken  = tokens[@"access_token"];
        self.refreshToken = tokens[@"refresh_token"];
        authenticationString = @"com.ticketingHub.authentication.getToken";
      } else if ([self.mode isEqualToString:AUTH_MODE_MIXPANEL]) {
        if ([resultsData isKindOfClass:[NSDictionary class]]) {
          authenticationObject = resultsData;
        }
        authenticationString = @"com.ticketingHub.authentication.verifyMixPanel";
      } else {
        // Verify token
        if ([resultsData isKindOfClass:[NSDictionary class]]) {
          authenticationObject[@"data"] = resultsData;
        } else if ([resultsData isKindOfClass:[NSString class]]) {
          authenticationObject[@"dataString"] = resultsData;
        }
        authenticationString = @"com.ticketingHub.authentication.verifyToken";
      }
    } else {
      // Handle the error
      authenticationString = @"com.ticketingHub.authentication.authenticationError";
    }
  }
  
  [self cleanup];
  
  NSDictionary *payload = @{@"payload": authenticationObject};

//  NSLog(@"%s - %@ - payload %@", __FUNCTION__, authenticationString, payload.description);
  
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
