//
//  TXHMainViewController.m
//  TicketingHub
//
//  Created by Mark Brindle on 07/06/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHMainViewController.h"
#import "TXHVenue.h"
#import "TXHVenueCell.h"
#import "TXHServerAccessManager.h"

// UIAlertViewDelegate is ONLY FOR TESTING purposes & may be removed
@interface TXHMainViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (weak, nonatomic) IBOutlet UITableView *venues;

@property (weak, nonatomic) IBOutlet UIButton *doorMan;
@property (weak, nonatomic) IBOutlet UIButton *salesMan;
@property (weak, nonatomic) IBOutlet UIButton *management;

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
  UIImage *backgroundImage = [UIImage imageNamed:@"bg_blue.png"];
  UIColor *backgroundColour = [UIColor colorWithPatternImage:backgroundImage];
  self.view.backgroundColor = backgroundColour;
  self.venueSelected = -1;
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

- (IBAction)loginOrOut:(id)sender {
#pragma unused (sender)
  // Perform logging in process
  [self processLogin];
}

- (void)updateAccess {
  // Enable appropriate access for this user
  self.doorMan.enabled = self.isUserLoggedIn;
  self.salesMan.enabled = self.isUserLoggedIn;
  self.management.enabled = self.isUserLoggedIn;
}

- (void)processLogin {
  
  // Stub - replace with actual logging in / out mechanism
  
  if (self.isUserLoggedIn) {
    self.isUserLoggedIn = NO;
    [self.venuesList removeAllObjects];
  } else {
    // Login
    // Get the venues list
    [[TXHServerAccessManager sharedInstance] getVenuesForAccessToken];
  }
  
  [self.loginButton setTitle:self.isUserLoggedIn ? @"Logout" : @"Login" forState:UIControlStateNormal];
}


#pragma mark - TableView Datasource & Delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#pragma unused (tableView)
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#pragma unused (tableView)
#pragma unused (section)
  return self.venuesList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  TXHVenueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"venueCellID" forIndexPath:indexPath];
  cell.venue = self.venuesList[indexPath.row];
  return cell;
}

#pragma mark - Temporary code to generate tokens

- (IBAction)generateToken:(id)sender {
#pragma unused (sender)
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Generate Token"
                                                  message:@"Enter Username & password"
                                                 delegate:self
                                        cancelButtonTitle:@"Cancel"
                                        otherButtonTitles:@"Generate", nil];
  alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
  [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
  if (buttonIndex != [alertView cancelButtonIndex]) {
    // Generate the token
    UITextField *userField = [alertView textFieldAtIndex:0];
    UITextField *passwordField = [alertView textFieldAtIndex:1];
    [[TXHServerAccessManager sharedInstance] generateAccessTokenFor:userField.text password:passwordField.text];
  }
}
@end
