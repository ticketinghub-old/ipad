//
//  TXHDoorTicketsTotalHeaderView.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 14/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHDoorTicketsTotalHeaderView.h"

@implementation TXHDoorTicketsTotalHeaderView

- (void)setTotalValueString:(NSString *)total
{
    self.totalValueLabel.text = total;
}

@end
