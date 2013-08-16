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
    
    __block typeof(self) blockSelf = self;
    self.completionBlock = ^{
        // Update the order for tickets
        NSLog(@"Update order for %@", blockSelf);
    };
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configureTimerViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    [super didMoveToParentViewController:parent];
    [self resetFrame];
}

- (void)resetFrame {
    CGRect frame = self.view.frame;
    NSLog(@"%s - %@", __FUNCTION__, NSStringFromCGRect(frame));
}

- (TXHSalesTimerViewController *)timerViewController {
    return _timerViewController;
}

- (void)setTimerViewController:(TXHSalesTimerViewController *)timerViewController {
    _timerViewController = timerViewController;
    [self configureTimerViewController];
}

- (TXHSalesCompletionViewController *)completionViewController {
    return _completionViewController;
}

- (void)setCompletionViewController:(TXHSalesCompletionViewController *)completionViewController {
    _completionViewController = completionViewController;
    [self configureCompletionViewController];
}

- (void (^)(void))completionBlock {
    return _completionBlock;
}

- (void)setCompletionBlock:(void (^)(void))completionBlock {
    _completionBlock = completionBlock;
    [self configureCompletionViewController];
}

- (void)configureTimerViewController {
    // Set up the timer view to reflect our details
    if (self.timerViewController) {
        [self.timerViewController resetPresentationAnimated:NO];
        self.timerViewController.stepTitle = NSLocalizedString(@"Payment", @"Payment");
        [self.timerViewController hidePaymentSelection:NO animated:YES];
        [self.timerViewController hideCountdownTimer:NO];
    }
}

- (void)configureCompletionViewController {
    // Set up the completion view controller to reflect ticket tier details
    [self.completionViewController setCompletionBlock:self.completionBlock];
}

@end
