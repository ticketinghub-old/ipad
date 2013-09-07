//
//  TXHMainNavigationCell.m
//  TicketingHub
//
//  Created by Mark Brindle on 07/06/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHDoorDateCell.h"

@interface TXHDoorDateCell ()

@property (weak, nonatomic) IBOutlet UILabel *cellTitle;

@end

@implementation TXHDoorDateCell

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    [self setup];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self setup];
  }
  return self;
}

- (void)setup {
  self.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
  self.selectedBackgroundView.backgroundColor = [UIColor grayColor];
}

- (void)setDate:(NSDate *)date {
  _date = date;
  
  static NSDateFormatter *dateFormatter = nil;
  if (dateFormatter == nil) {
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
  }
  
  self.cellTitle.text = [dateFormatter stringFromDate:date];
}

@end
