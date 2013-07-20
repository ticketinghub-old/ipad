//
//  TXHMainNavigationBar.m
//  TicketingHub
//
//  Created by Mark on 19/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHMainNavigationBar.h"
#import "TXHCommonNames.h"
#import "TXHVenue.h"

@interface TXHMainNavigationBar ()

@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation TXHMainNavigationBar

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
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
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(venueSelected:) name:NOTIFICATION_VENUE_SELECTED object:nil];
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)toggleMenu:(id)sender {
#pragma unused (sender)
  [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TOGGLE_MENU object:nil];
}

- (void)venueSelected:(NSNotification *)notification {
  TXHVenue *venue = notification.object;
  self.titleLabel.text = venue.businessName;
}

@end
