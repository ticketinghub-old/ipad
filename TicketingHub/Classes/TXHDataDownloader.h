//
//  TXHDataDownloader.h
//  TicketingHub
//
//  Created by Mark on 09/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXHDataDownloader : NSObject

@property (strong, nonatomic) NSString      *urlString;
@property (strong, nonatomic) NSString      *token;

@property (strong, nonatomic) NSString      *methodType;  // Defaults to GET
@property (strong, nonatomic) NSDictionary  *httpPOSTBody;
@property (strong, nonatomic) NSDictionary  *headerFields;

@property (copy) void (^completionHandler)(id data);
@property (copy) void (^errorHandler)(id sender);

- (id)initWithOwner:(id)owner;

- (void)execute;

@end
