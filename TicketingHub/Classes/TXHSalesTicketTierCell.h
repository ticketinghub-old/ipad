//
//  TXHSalesTicketTierCell.h
//  TicketingHub
//
//  Created by Mark on 31/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TXHTicketTier;
@class TXHTicketingHubClient;

@interface TXHSalesTicketTierCell : UITableViewCell

@property (strong, nonatomic) TXHTicketingHubClient *ticketingHubClient;
@property (strong, nonatomic) TXHTicketTier *tier;

// When the quantity of tickets for the cell's tier changes, this handler will be invoked, passing the quantity .
@property (copy) void (^quantityChangedHandler)(NSDictionary *);

@end
