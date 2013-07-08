//
//  TXHMainViewController.m
//  TicketingHub
//
//  Created by Mark Brindle on 07/06/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHMainViewController.h"

@interface TXHMainViewController ()

@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (weak, nonatomic) IBOutlet UIButton *doorMan;
@property (weak, nonatomic) IBOutlet UIButton *salesMan;
@property (weak, nonatomic) IBOutlet UIButton *management;

@property (nonatomic, readwrite)  BOOL  isUserLoggedIn;

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
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)loginOrOut:(id)sender {
#pragma unused (sender)
  // Perform logging in process
  [self processLogin];
  
  // Enable appropriate access for this user
  
  self.doorMan.enabled = self.isUserLoggedIn;
  self.salesMan.enabled = self.isUserLoggedIn;
  self.management.enabled = self.isUserLoggedIn;
}

- (void)processLogin {
  // Stub - replace with actual logging in / out mechanism
  self.isUserLoggedIn = !self.isUserLoggedIn;
  
  [self.loginButton setTitle:self.isUserLoggedIn ? @"Logout" : @"Login" forState:UIControlStateNormal];
}

@end
