//
//  TXHSalesPaymentViewController.m
//  TicketingHub
//
//  Created by Mark on 14/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesPaymentViewController.h"

#import "TXHSalesCompletionViewController.h"
#import "TXHSalesPaymentPaymentDetailsViewController.h"
#import "TXHSalesTimerViewController.h"

@interface TXHSalesPaymentViewController () <UICollectionViewDelegateFlowLayout>

@property (readwrite, nonatomic, getter = isValid) BOOL valid;

// A mutable collection of sections indicating their expanded status.
@property (strong, nonatomic) NSMutableDictionary *sections;

// A reference to the payment details content controller
@property (strong, nonatomic) TXHSalesPaymentPaymentDetailsViewController *paymentDetailsController;

@end

@implementation TXHSalesPaymentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Add constraints
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.view.translatesAutoresizingMaskIntoConstraints = YES;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
#pragma unused (sender)
    if ([segue.identifier isEqualToString:@"TXHSalesPaymentPaymentDetailsViewController"]) {
        self.paymentDetailsController = segue.destinationViewController;
    }
}


#pragma mark - Payment method changed

- (IBAction)didChangePaymentMethod:(UISegmentedControl *)sender
{
    [self.paymentDetailsController setPaymentMethodType:(TXHPaymentMethodType)sender.selectedSegmentIndex];
}

- (void)setOffsetBottomBy:(CGFloat)offset
{
//    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, offset, 0);
}

- (void)finishStepWithCompletion:(void (^)(NSError *error))blockName
{
    
}


@end
