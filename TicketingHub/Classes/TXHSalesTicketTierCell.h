//
//  TXHSalesTicketTierCell.h
//  TicketingHub
//
//  Created by Mark on 31/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXHSalesTicketTierCell : UITableViewCell

@property (strong, nonatomic) TXHTier *tier;

@property (copy) void (^quantityChangedHandler)(NSDictionary *);

@end
