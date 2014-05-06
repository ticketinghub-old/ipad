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

#import <Block-KVO/MTKObserving.h>

@interface TXHSalesPaymentViewController () <UICollectionViewDelegateFlowLayout>

@property (readwrite, nonatomic, getter = isValid) BOOL valid;


@property (strong, nonatomic) TXHSalesPaymentPaymentDetailsViewController *paymentDetailsController;
@property (weak, nonatomic) IBOutlet UISegmentedControl *paymentTypeSegmentedControl;

@end

@implementation TXHSalesPaymentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)setPaymentDetailsController:(TXHSalesPaymentPaymentDetailsViewController *)paymentDetailsController
{
    _paymentDetailsController = paymentDetailsController;

    paymentDetailsController.productManager = self.productManager;
    paymentDetailsController.orderManager   = self.orderManager;
    
    [self updatePaymentMethod];
    
    [self map:@keypath(self.paymentDetailsController.valid) to:@keypath(self.valid) null:nil];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"TXHSalesPaymentPaymentDetailsViewController"])
    {
        self.paymentDetailsController = segue.destinationViewController;
    }
}


#pragma mark - Payment method changed

- (IBAction)didChangePaymentMethod:(UISegmentedControl *)sender
{
    [self updatePaymentMethod];
}

- (void)updatePaymentMethod
{
    self.paymentDetailsController.paymentType = (TXHPaymentMethodType)self.paymentTypeSegmentedControl.selectedSegmentIndex;
}

#pragma mark - TXHSalesContentsViewControllerProtocol

- (void)finishStepWithCompletion:(void (^)(NSError *error))blockName
{
    NSDictionary *ownerInfo = @{@"first_name" : @"Bartek",
                                @"last_name"  : @"Hugo",
                                @"email"      : @"bartekhugo@me.com",
                                @"telephone"  : @"+447534463225",
                                @"country"    : @"GB"};
    
    [self.orderManager updateOrderWithOwnerInfo:ownerInfo
                                   completion:^(TXHOrder *order, NSError *error) {
                                       if (!error)
                                           [self.orderManager updateOrderWithPaymentMethod:@"credit"
                                                                              completion:^(TXHOrder *order2, NSError *error2) {
                                                                                  if (!error)
                                                                                      [self.orderManager confirmOrderWithCompletion:^(TXHOrder *order3, NSError *error3) {
                                                                                          if (blockName)
                                                                                              blockName(error3);
                                                                                      }];
                                                                              }];
                                   }];
    
}


@end
