//
//  TXHSalesInformationViewController.m
//  TicketingHub
//
//  Created by Mark on 02/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesInformationViewController.h"

#import "TXHSalesTimerViewController.h"

@interface TXHSalesInformationViewController ()

// Height constraint
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *completionHeightConstraint;

@end

@implementation TXHSalesInformationViewController

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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.timerView.stepTitle = NSLocalizedString(@"Customer Details", @"Customer Details");
    [self.timerView hideCountdownTimer:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
