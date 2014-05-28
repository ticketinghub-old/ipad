//
//  TXHOrderCell.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 28/05/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHOrderCell.h"

@interface TXHOrderCell ()

@property (weak, nonatomic) IBOutlet UILabel *orderReferenceLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *atendeessLabel;
@property (weak, nonatomic) IBOutlet UILabel *attendingLabel;

@end

@implementation TXHOrderCell

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

- (void)setOrderReference:(NSString *)reference
{
    self.orderReferenceLabel.text = reference;
}

- (void)setPrice:(NSString *)string
{
    self.priceLabel.text = string;
}
- (void)setGuestCount:(NSInteger)guestCount
{
    self.atendeessLabel.text = [NSString stringWithFormat:NSLocalizedString(@"DOORMAN_TICKETS_LIST_ATTENDEES_FORMAT",nil),guestCount];
}

- (void)setAttendingCount:(NSInteger)attendingCount
{
    self.attendingLabel.text = [NSString stringWithFormat:NSLocalizedString(@"DOORMAN_TICKETS_LIST_ATTENDING_FORMAT",nil),attendingCount];

}


@end
