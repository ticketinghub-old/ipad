//
//  TXHSalesTicketViewController.m
//  TicketingHub
//
//  Created by Mark on 31/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesTicketViewController.h"

#import "TXHSalesTicketTiersViewController.h"
#import "TXHSalesTicketCompletionViewController.h"

@interface TXHSalesTicketViewController ()

@property (weak, nonatomic) TXHSalesTicketTiersViewController       *tiersController;
@property (weak, nonatomic) TXHSalesTicketCompletionViewController  *completionController;

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

@end
