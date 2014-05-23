//
//  TXHSalesSummaryHeader.m
//  TicketingHub
//
//  Created by Mark on 13/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesSummaryHeader.h"

@interface TXHSalesSummaryHeader ()

@property (weak, nonatomic) IBOutlet UILabel *headerTitle;
@property (weak, nonatomic) IBOutlet UILabel *headerTotalPrice;

@end

@implementation TXHSalesSummaryHeader

- (void)setTicketTitle:(NSString *)ticketTitle
{
    self.headerTitle.text = ticketTitle;
}

- (void)setTicketTotalPrice:(NSString *)ticketTotalPrice
{
    self.headerTotalPrice.text = ticketTotalPrice;
}

@end
