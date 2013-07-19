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
    // Custom initialization
  }
  return self;
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
  [[NSNotificationCenter defaultCenter] postNotificationName:TOGGLE_MENU object:nil];
}

- (void)updateAccess {
  // Enable appropriate access for this user
}

@end
