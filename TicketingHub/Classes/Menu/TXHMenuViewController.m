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

@property (strong, nonatomic) UITapGestureRecognizer  *tapRecogniser;
@property (strong, nonatomic) UIView                  *coverView;

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
  if (self.menuContainer.bounds.size.width == 0.0f) {
    CGRect boundingRect = self.menuContainer.bounds;
    boundingRect.size.width = 240.0f;
    self.menuContainer.bounds = boundingRect;
    boundingRect = self.tabContainer.frame;
    boundingRect.origin.x = self.menuContainer.bounds.size.width;
    self.tabContainer.frame = boundingRect;
    self.coverView = [[UIView alloc] initWithFrame:boundingRect];
    self.coverView.userInteractionEnabled = YES;
    self.coverView.backgroundColor = [UIColor colorWithWhite:0.2f alpha:0.1f];
    [self.coverView addGestureRecognizer:self.tapRecogniser];
//    [self.view addSubview:self.coverView];
  } else {
    CGRect boundingRect = self.menuContainer.bounds;
    boundingRect.size.width = 0.0f;
    self.menuContainer.bounds = boundingRect;
    boundingRect = self.tabContainer.frame;
    boundingRect.origin.x = 0.0f;
    self.tabContainer.frame = boundingRect;
//    [self.coverView removeFromSuperview];
    self.coverView = nil;
  }
}

- (void)tap:(UITapGestureRecognizer *)recogniser {
#pragma unused (recogniser)
  [self toggleMenu:nil];
}

@end
