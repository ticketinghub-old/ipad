//
//  TXHSalesPaymentViewController.m
//  TicketingHub
//
//  Created by Mark on 14/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesPaymentViewController.h"

#import "TXHSalesCompletionViewController.h"
#import "TXHSalesContentProtocol.h"
#import "TXHSalesTimerViewController.h"

@interface TXHSalesPaymentViewController () <TXHSalesContentProtocol, UICollectionViewDelegateFlowLayout>

// A reference to the timer view controller
@property (retain, nonatomic) TXHSalesTimerViewController *timerViewController;

// A reference to the completion view controller
@property (retain, nonatomic) TXHSalesCompletionViewController *completionViewController;

// A completion block to be run when this step is completed
@property (copy) void (^completionBlock)(void);

// A mutable collection of sections indicating their expanded status.
@property (strong, nonatomic) NSMutableDictionary *sections;

@end

@implementation TXHSalesPaymentViewController

@synthesize timerViewController = _timerViewController;
@synthesize completionViewController = _completionViewController;
@synthesize completionBlock = _completionBlock;

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
