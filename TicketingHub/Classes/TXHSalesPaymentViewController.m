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
#import "TXHOrderManager.h"

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

    // TODO: temporary
    self.valid = (TXHPaymentMethodType)sender.selectedSegmentIndex == 2;
}

- (void)setOffsetBottomBy:(CGFloat)offset
{
//    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, offset, 0);
}

#pragma mark - TXHSalesContentsViewControllerProtocol

- (void)finishStepWithCompletion:(void (^)(NSError *error))blockName
{
    NSDictionary *ownerInfo = @{@"first_name" : @"Bartek",
                                @"last_name"  : @"Hugo",
                                @"email"      : @"bartekhugo@me.com",
                                @"telephone"  : @"+447534463225",
                                @"country"    : @"GB"};
    
    [TXHORDERMANAGER updateOrderWithOwnerInfo:ownerInfo
                                   completion:^(TXHOrder *order, NSError *error) {
                                       [TXHORDERMANAGER updateOrderWithPaymentMethod:@"credit"
                                                                          completion:^(TXHOrder *order2, NSError *error2) {
                                                                              if (blockName)
                                                                                  blockName(error2);
                                                                          }];
                                   }];
    
}




@end
