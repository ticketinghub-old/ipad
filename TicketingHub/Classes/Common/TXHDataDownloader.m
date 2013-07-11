//
//  TXHDataDownloader.m
//  TicketingHub
//
//  Created by Mark on 09/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHDataDownloader.h"

@interface TXHDataDownloader ()  <NSURLConnectionDelegate>
{
	BOOL isDownloading;
	int bytesRead;
	int expectedLength;
}

@property (strong) NSString *targetPath;
@property (weak) id owner;

@property (strong, nonatomic) NSURLConnection *connection;

@property (strong, nonatomic) NSMutableData   *receivedData;
@property (nonatomic, readwrite) NSInteger    statusCode;

@property (nonatomic, strong) NSString        *errorString;
@property (nonatomic, strong) NSError         *dataError;

@end

@implementation TXHDataDownloader

- (id)initWithOwner:(id)owner {
  self = [super init];
  if (self) {
    self.owner = owner;
    self.methodType = @"GET";
  }
  return self;
}

- (void)execute {
  NSURL *url = [NSURL URLWithString:self.urlString];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                         cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                     timeoutInterval:60.0];
  [request setHTTPMethod:self.methodType];
  [request setValue:@"en-US" forHTTPHeaderField:@"Accept-Language"];
  [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
  if ([self.methodType isEqualToString:@"GET"]) {
    for (NSString *headerKey in [self.headerFields allKeys]) {
      [request setValue:self.headerFields[headerKey] forHTTPHeaderField:headerKey];
    }
  } else {
    NSError *error = nil;
    NSData *payload = [NSJSONSerialization dataWithJSONObject:self.httpPOSTBody options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
      NSLog(@"JSON parsing error with:%@", self.httpPOSTBody.description);
    }
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [request setHTTPBody:payload];
  }
  self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
  if (self.connection) {
    // Create NSMutable data to hold received data
    self.receivedData = [NSMutableData data];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
  }
}

#pragma mark - NSURLConnection delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
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
    }
  } else {
    NSLog(@"status:%@", httpResponse.allHeaderFields[@"Status"]);
  }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
#pragma unused (connection)
  [self.receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
#pragma unused (connection)
  NSLog(@"%s - data length:%d", __FUNCTION__, self.receivedData.length);
  NSMutableDictionary *dataPackage = [NSMutableDictionary dictionary];
  
  if (self.receivedData.length > 0) {
    id resultsData = [NSJSONSerialization
                      JSONObjectWithData:self.receivedData
                      options:NSJSONReadingMutableContainers
                      error:nil];
    if (([resultsData isKindOfClass:[NSDictionary class]]) || ([resultsData isKindOfClass:[NSArray class]])) {
      dataPackage[@"data"] = resultsData;
    } else {
      NSString *resultString = [[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding];
      dataPackage[@"dataString"] = resultString;
    }
    dataPackage[@"status"] = @(self.statusCode);
  }

  NSDictionary *payload = @{@"payload": dataPackage};
  
  [self cleanup];

  if (self.completionHandler) {
    self.completionHandler(payload);
  }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
#pragma unused (connection)
  NSLog(@"%s - AN ERROR OCCURRED:%@", __FUNCTION__, error.userInfo.description);
  self.dataError = [error copy];
  [self cleanup];
  if (self.errorHandler) {
    self.errorHandler(self.dataError);
  }
}

- (void) cleanup {
  if (self.connection) {
    [self.connection cancel];
    self.connection = nil;
  }
  
  self.receivedData = nil;
  
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

@end
