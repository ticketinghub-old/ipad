//
//  TXHDoorTicketsDateHeaderView.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 14/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHDoorTicketsDateHeaderView.h"
#import "NSDateFormatter+DisplayFormat.h"

@interface TXHDoorTicketsDateHeaderView ()

@end

@implementation TXHDoorTicketsDateHeaderView

- (void)setDate:(NSDate *)date
{
    self.dateValueLabel.text = [NSDateFormatter txh_fullDateStringFromDate:date];
}

@end
