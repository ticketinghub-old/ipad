//
//  TXHMenuViewController.m
//  TicketingHub
//
//  Created by Mark on 10/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHMenuViewController.h"
#import "TXHCommonNames.h"

@interface TXHMenuViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftHandSpace;
@property (strong, nonatomic) UITapGestureRecognizer  *tapRecogniser;

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

- (void)viewDidLoad
{
  [super viewDidLoad];
	// Do any additional setup after loading the view.
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleMenu:) name:TOGGLE_MENU object:nil];
  self.tapRecogniser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
  self.leftHandSpace.constant = -240.0f;
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [UIView animateWithDuration:0.75f delay:0.15f options:UIViewAnimationOptionCurveEaseInOut animations:^{
    self.leftHandSpace.constant = 0.0f;
    [self.view layoutIfNeeded];
  } completion:nil];
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
      self.leftHandSpace.constant = -240.0f;
    } else {
      self.leftHandSpace.constant = 0.0f;
    }
    [self.view layoutIfNeeded];
  }];
//  [UIView beginAnimations:nil context:nil];
//  [UIView setAnimationDuration:0.75];
//  if (self.leftHandSpace.constant == 0.0f) {
//    self.leftHandSpace.constant = -240.0f;
////    [self expandMenu];
//  } else {
//    self.leftHandSpace.constant = 0.0f;
////    [self collapseMenu];
//  }
//  [UIView commitAnimations];
}

- (void)tap:(UITapGestureRecognizer *)recogniser {
#pragma unused (recogniser)
  [self toggleMenu:nil];
}

- (void)expandMenu {
  CGRect boundingRect = self.menuContainer.bounds;
  boundingRect.size.width = 240.0f;
  self.menuContainer.frame = boundingRect;
  boundingRect = self.tabContainer.frame;
  boundingRect.origin.x = self.menuContainer.bounds.size.width;
  self.tabContainer.frame = boundingRect;
}

- (void)collapseMenu {
  CGRect boundingRect = self.menuContainer.bounds;
  boundingRect.size.width = 0.0f;
  self.menuContainer.frame = boundingRect;
  boundingRect = self.tabContainer.frame;
  boundingRect.origin.x = 0.0f;
  self.tabContainer.frame = boundingRect;
}

@end
