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
#import "TXHMenuViewController.h"

@interface UIAlertView (myView)

@end

@interface TXHLoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalSpaceToLogo;

@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIImageView *email;

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
  
  // Set the status bar style to be light since we have a dark background
  [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
  
  // Register for keyboard notifications, so that we can reposition the entry fields to keep them visible
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
	// Do any additional setup after loading the view.
  if (self.lastUser.length > 0) {
    self.userField.text = self.lastUser;
  }
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didEndOnExit:(id)sender {
  [self login:sender];
}

- (IBAction)editingDidEnd:(id)sender {
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
  
  // We successfully logged in, so get a list of venues for this user
  [[TXHServerAccessManager sharedInstance] getVenuesWithCompletionHandler:^(NSArray *venues){
    NSLog(@"get venues:");
    [self gotVenues:venues];
  }
                                                             errorHandler:^(id reason){[self loginFailed:reason];}];
}

- (void)gotVenues:(NSArray *)venues {
  // If there are no venues, display a message to the user and do not leave the login page
  if (venues.count == 0) {
    // Warn user that they cannot proceed
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Venues" message:@"You do not have access to any venues." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alert setaccessoryView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tickethub"]]];
    [alert show];
  } else {
//    [self performSegueWithIdentifier:@"loginUnwindSegue" sender:self];
    [self dismissViewControllerAnimated:YES completion:nil];
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:[NSBundle mainBundle]];
//    UINavigationController *navController = [storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
//    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
//    [window setRootViewController:navController];
//    [window makeKeyAndVisible];
  }
}

- (void)loginFailed:(id)reason {
  NSError *error = reason;
  NSLog(@"ERROR:%@", error.userInfo.description);
}

- (IBAction)editingChanged:(id)sender {
#pragma unused (sender)
  self.loginButton.enabled = ((self.userField.text.length > 0) && (self.passwordField.text.length > 0));
}

#pragma mark - Notifications

- (void)keyboardWillShow:(NSNotification *)notification {
  NSDictionary *keyboardAnimationDetail = [notification userInfo];
  UIViewAnimationOptions curve = [keyboardAnimationDetail[UIKeyboardAnimationCurveUserInfoKey] integerValue];
  NSTimeInterval duration = [keyboardAnimationDetail[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
  [UIView animateWithDuration:duration delay:0.0f options:curve animations:^{
    self.verticalSpaceToLogo.constant = 40.0f;
    [self.view layoutIfNeeded];
  } completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notification {
#pragma unused (notification)
  [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
    self.verticalSpaceToLogo.constant = 184.0f;
    [self.view layoutIfNeeded];
  } completion:nil];
}

@end
