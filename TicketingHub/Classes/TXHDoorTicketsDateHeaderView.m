//
//  TXHDoorTicketsDateHeaderView.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 14/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHDoorTicketsDateHeaderView.h"
#import "NSDate+Additions.h"


@interface TXHDoorTicketsDateHeaderView ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation TXHDoorTicketsDateHeaderView

- (void)setDate:(NSDate *)date
{
    self.dateFormatter.dateFormat = [NSString stringWithFormat:@"d'%@' MMMM YYYY, HH:MM", [date daySuffix]];
    NSString *dateString = [self.dateFormatter stringFromDate:date];
    self.dateValueLabel.text = dateString;
}

- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    return _dateFormatter;
}

@end
