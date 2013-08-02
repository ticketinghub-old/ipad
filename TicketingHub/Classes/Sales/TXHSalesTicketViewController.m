//
//  TXHSalesTicketViewController.m
//  TicketingHub
//
//  Created by Mark on 31/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesTicketViewController.h"

#import "TXHSalesTicketCompletionViewController.h"
#import "TXHSalesTicketTiersViewController.h"
#import "TXHSalesTimerViewController.h"

@interface TXHSalesTicketViewController ()

@property (weak, nonatomic) TXHSalesTicketTiersViewController       *tiersController;
@property (weak, nonatomic) TXHSalesTicketCompletionViewController  *completionController;

// Height constraint 
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *completionHeightConstraint;

// Keep a running total of the
@property (strong, nonatomic) NSMutableDictionary                   *tierQuantities;

@end

@implementation TXHSalesTicketViewController

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
    
    // Set up the timer view to reflect our details
    self.timerView.stepTitle = NSLocalizedString(@"Select your tickets", @"Select your tickets");
    [self.timerView hideCountdownTimer:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableDictionary *)tierQuantities {
    if (_tierQuantities == nil) {
        _tierQuantities = [NSMutableDictionary dictionary];
    }
    return _tierQuantities;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
#pragma unused (sender)
    if ([segue.identifier isEqualToString:@"TXHSalesTicketTiersViewController"]) {
        self.tiersController = segue.destinationViewController;
        self.tiersController.delegate = self;
    }
    if ([segue.identifier isEqualToString:@"TXHSalesTicketCompletionViewController"]) {
        self.completionController = segue.destinationViewController;
        self.completionController.delegate = self;
    }
}

#pragma mark - Tier quantity change

- (void)quantityChanged:(NSDictionary *)quantity {
    // Add this quantity to our dictionary
    [self.tierQuantities addEntriesFromDictionary:quantity];
    
    // Inform the completion view controller of the current number of tickets selected
    NSUInteger total = 0;
    for (NSNumber *tierQuantity in [self.tierQuantities allValues]) {
        total += tierQuantity.integerValue;
    }
    [self.completionController updateTicketCount:total];
}

- (void)continueFromStep:(NSNumber *)step {
    // Pass up the chain - we don't need to do anything here
    if ([self.delegate respondsToSelector:@selector(continueFromStep:)]) {
        [self.delegate performSelector:@selector(continueFromStep:) withObject:step];
    }
}


- (void)increaseHeight {
    [UIView animateWithDuration:0.36f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.completionHeightConstraint.constant += 352.0f;
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (void)decreaseHeight {
    [UIView animateWithDuration:0.36f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.completionHeightConstraint.constant -= 352.0f;
        [self.view layoutIfNeeded];
    } completion:nil];
}

@end
