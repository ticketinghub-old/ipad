//
//  TXHLoginViewController.m
//  TicketingHub
//
//  Created by Mark on 10/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHLoginViewController.h"
#import "TXHCommonNames.h"
#import "TXHServerAccessManager.h"

@interface TXHLoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (strong, nonatomic) NSString *lastUser;

@end

@implementation TXHLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
  NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
  // Grab the last user
  self.lastUser = [defaults objectForKey:LAST_USER];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
	// Do any additional setup after loading the view.
  if (self.lastUser.length > 0) {
    self.userField.text = self.lastUser;
  }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)login:(id)sender {
#pragma unused (sender)
  self.loginButton.enabled = NO;
  [[TXHServerAccessManager sharedInstance] generateAccessTokenFor:self.userField.text
                                                         password:self.passwordField.text
                                                       completion:^{[self loginCompleted];}
                                                            error:^(id reason){[self loginFailed:reason];}];
}

- (void)loginCompleted {
  // Save this user in NSUserDefaults
  NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
  // Set the last user
  [defaults setObject:self.userField.text forKey:LAST_USER];
  [defaults synchronize];
  
  [[TXHServerAccessManager sharedInstance] getVenuesWithCompletionHandler:^(NSArray *venues){[self gotVenues:venues];} errorHandler:^(id reason){[self loginFailed:reason];}];
}

- (void)gotVenues:(NSArray *)venues {
#pragma unused (venues)
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:[NSBundle mainBundle]];
  UINavigationController *navController = [storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
  UIWindow *window = [[UIApplication sharedApplication] keyWindow];
  [window setRootViewController:navController];
  [window makeKeyAndVisible];
}

- (void)loginFailed:(id)reason {

}

- (IBAction)editingChanged:(id)sender {
#pragma unused (sender)
  self.loginButton.enabled = ((self.userField.text.length > 0) && (self.passwordField.text.length > 0));
}

@end
