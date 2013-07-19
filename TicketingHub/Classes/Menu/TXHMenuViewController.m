//
//  TXHMenuViewController.m
//  TicketingHub
//
//  Created by Mark on 10/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHMenuViewController.h"
#import "TXHCommonNames.h"
#import "TXHLoginViewController.h"
#import "TXHMenuController.h"

@interface TXHMenuViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftHandSpace;
@property (strong, nonatomic) UITapGestureRecognizer  *tapRecogniser;

@property (assign, nonatomic) BOOL  loggedIn;

@end

@implementation TXHMenuViewController

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
  [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout:) name:MENU_LOGOUT object:nil];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
	// Do any additional setup after loading the view.
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleMenu:) name:TOGGLE_MENU object:nil];
  self.tapRecogniser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
  self.leftHandSpace.constant = -self.menuContainer.bounds.size.width;
  [self performSegueWithIdentifier:@"modalLogin" sender:self];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [UIView animateWithDuration:0.75f delay:0.15f options:UIViewAnimationOptionCurveEaseInOut animations:^{
    self.leftHandSpace.constant = 0.0f;
    [self.view layoutIfNeeded];
  } completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}


- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)toggleMenu:(id)sender {
#pragma unused (sender)
  [UIView animateWithDuration:1.0f animations:^{
    if (self.leftHandSpace.constant == 0.0f) {
      self.leftHandSpace.constant = -self.menuContainer.bounds.size.width;
    } else {
      self.leftHandSpace.constant = 0.0f;
    }
    [self.view layoutIfNeeded];
  }];
}

- (void)tap:(UITapGestureRecognizer *)recogniser {
#pragma unused (recogniser)
  [self toggleMenu:nil];
}

- (IBAction)mySegueHandler:(UIStoryboardSegue *)sender {
  // Do some interesting stuff
  TXHLoginViewController *controller = sender.sourceViewController;
  [controller dismissViewControllerAnimated:YES completion:nil];
  [UIView animateWithDuration:0.5
                   animations:^{
                     
                     [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
                   }
                   completion:^(BOOL finished){
                     self.loggedIn = finished;
                   }];
  [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - Notifications

- (void)logout:(NSNotification *)notification {
#pragma unused (notification)
  self.loggedIn = YES;
  [self performSegueWithIdentifier:@"reLogin" sender:self];
}

@end
