//
//  TXHMainViewController.m
//  TicketingHub
//
//  Created by Mark Brindle on 07/06/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHMainViewController.h"
#import "TXHCommonNames.h"
#import "TXHVenue.h"
#import "TXHServerAccessManager.h"

// UIAlertViewDelegate is ONLY FOR TESTING purposes & may be removed
@interface TXHMainViewController ()

@property (readwrite, nonatomic)  BOOL  isUserLoggedIn;

// A list of venues from which a venue can be selected
@property (strong, nonatomic) NSMutableArray  *venuesList;

@property (readwrite, nonatomic) NSInteger venueSelected;

@end

@implementation TXHMainViewController

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
  [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:1.0f / 255.0f green:46.0f / 255.0f blue:67.0f / 255.0f alpha:1.0f]];
  self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:24.0f],
                                                                  NSForegroundColorAttributeName: [UIColor whiteColor]};
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)venuesList {
  if (_venuesList == nil) {
    _venuesList = [NSMutableArray array];
  }
  return _venuesList;
}

- (IBAction)toggleMenu:(id)sender {
#pragma unused (sender)
  [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TOGGLE_MENU object:nil];
}

#pragma mark - Notifications

- (void)venueSelected:(NSNotification *)notification {
  // Check for venue details then close menu if appropriate
  TXHVenue *venue = [notification object];
  self.title = venue.businessName;
  [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TOGGLE_MENU object:nil];
}

@end
