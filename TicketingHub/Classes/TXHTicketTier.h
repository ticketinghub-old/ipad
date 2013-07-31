//
//  TXHTicketTier.h
//  TicketingHub
//
//  Created by Mark on 30/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXHTicketTier : NSObject

@property (strong, nonatomic) NSNumber          *tierID;
@property (strong, nonatomic) NSString          *tierName;
@property (strong, nonatomic) NSString          *tierDescription;
@property (strong, nonatomic) NSNumber          *commission;
@property (strong, nonatomic) NSNumber          *price;
@property (strong, nonatomic) NSNumber          *limit;
@property (strong, nonatomic) NSNumber          *size;

- (id)initWithData:(NSDictionary *)data numberOfDecimalPlaces:(NSUInteger)decimalPlaces;

@end
