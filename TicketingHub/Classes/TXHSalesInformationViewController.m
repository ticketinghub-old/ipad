//
//  TXHSalesInformationViewController.m
//  TicketingHub
//
//  Created by Mark on 02/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesInformationViewController.h"

#import "TXHSalesContentProtocol.h"
#import "TXHSalesTimerViewController.h"

@interface TXHSalesInformationViewController () <TXHSalesContentProtocol>

// Height constraint
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *completionHeightConstraint;

// A reference to the timer view controller
@property (retain, nonatomic) TXHSalesTimerViewController *timerViewController;

// A reference to the completion view controller
@property (retain, nonatomic) TXHSalesCompletionViewController *completionViewController;

@end

@implementation TXHSalesInformationViewController

@synthesize timerViewController = _timerViewController;
@synthesize completionViewController = _completionViewController;

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
    self.timerViewController.stepTitle = NSLocalizedString(@"Customer Details", @"Customer Details");
    [self.timerViewController hideCountdownTimer:NO];
    [self.timerViewController hidePaymentSelection:NO animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)transition:(id)sender {
    
}

@end
