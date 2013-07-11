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
    [self generateToken];
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

- (void)generateToken {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login"
                                                  message:@"Please enter your username & password"
                                                 delegate:self
                                        cancelButtonTitle:@"Cancel"
                                        otherButtonTitles:@"Login", nil];
  alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
  [alert show];
}

- (void)getVenues {
  [[TXHServerAccessManager sharedInstance] getVenuesWithCompletionHandler:^(NSArray *venues){
    [self buildVenues:venues];
    dispatch_async(dispatch_get_main_queue(), ^{
      [self.venuesTable reloadData];
    });
  }
                                                             errorHandler:^(id reason){
                                                               NSError *err = reason;
                                                               NSLog(@"error: %@", err.description);
                                                             }];
}

- (void)buildVenues:(NSArray *)venues {
  [self.venuesList removeAllObjects];
  for (NSDictionary *venueData in venues) {
    TXHVenue *venue = [[TXHVenue alloc] initWithData:venueData];
    if (venue != nil) {
      [self.venuesList addObject:venue];
    }
  }
}

#pragma mark - AlertView Delegate Methods

- (void)willPresentAlertView:(UIAlertView *)alertView {
  UITextField *userField = [alertView textFieldAtIndex:0];
  userField.text = @"mark_brindle@me.com";
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
  if (buttonIndex != [alertView cancelButtonIndex]) {
    // Generate the token
    UITextField *userField = [alertView textFieldAtIndex:0];
    UITextField *passwordField = [alertView textFieldAtIndex:1];
    [[TXHServerAccessManager sharedInstance] generateAccessTokenFor:userField.text
                                                           password:passwordField.text
                                                         completion: ^() {
                                                           [self getVenues];
                                                         }
                                                              error:^(id reason) {
                                                                NSError *err = reason;
                                                                NSLog(@"error: %@", err.description);
                                                              }];
  }
}

@end
