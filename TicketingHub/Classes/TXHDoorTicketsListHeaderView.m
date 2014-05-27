//
//  TXHDoorTicketsListHeaderView.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 27/05/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHDoorTicketsListHeaderView.h"

#import "NSDateFormatter+DisplayFormat.h"

@interface TXHDoorTicketsListHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *attendingLabel;
@property (weak, nonatomic) IBOutlet UILabel *guestsLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;


@end

@implementation TXHDoorTicketsListHeaderView

- (void)setAttending:(NSUInteger)attending
{
    self.attendingLabel.text = [NSString stringWithFormat:NSLocalizedString(@"DOORMAN_TICKETS_LIST_ATTENDING_FORMAT", nil),attending];
}

- (void)setTotal:(NSUInteger)total
{
    self.guestsLabel.text = [NSString stringWithFormat:NSLocalizedString(@"DOORMAN_TICKETS_LIST_ATTENDEES_FORMAT", nil),total];
}

- (void)setDate:(NSDate *)date
{
    self.timeLabel.text = [NSDateFormatter txh_timeStringFromDate:date];
    self.dateLabel.text = [NSDateFormatter txh_dateStringFromDate:date];
}

@end
