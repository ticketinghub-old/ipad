//
//  TXHVenueCell.m
//  TicketingHub
//
//  Created by Mark on 09/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHVenueCell.h"
#import "TXHVenue.h"

@interface TXHVenueCell ()

@property (weak, nonatomic) IBOutlet UILabel *businessName;

@end

@implementation TXHVenueCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setVenue:(TXHVenue *)venue {
  _venue = venue;
  self.businessName.text = venue.businessName;
}

@end
