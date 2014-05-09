//
//  TXHSalesPaymentCreditDetailsViewController.m
//  TicketingHub
//
//  Created by Mark on 14/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesPaymentCreditDetailsViewController.h"
#import "TXHSignaturePadViewController.h"

#import "TXHOrderManager.h"
#import "TXHProductsManager.h"

@interface TXHSalesPaymentCreditDetailsViewController () <TXHSignaturePadViewControllerDelegate>

@property (readwrite, nonatomic, getter = isValid) BOOL valid;
@property (readwrite, nonatomic, getter = isEnabled) BOOL enabled;

@end

@implementation TXHSalesPaymentCreditDetailsViewController

- (IBAction)testButtonAction:(id)sender
{
    [self performSegueWithIdentifier:@"ShowSignaturePad" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowSignaturePad"])
    {
        TXHOrder *order = [self.orderManager order];
        
        TXHSignaturePadViewController *signatureController = segue.destinationViewController;

        signatureController.totalPriceString = [self.productManager priceStringForPrice:order.total];
        signatureController.ownerName        = order.customer.fullName;
        signatureController.delegate         = self;
    }
}

#pragma mark - TXHSignaturePadViewControllerDelegate

- (void)txhSignaturePadViewController:(TXHSignaturePadViewController *)controller acceptSignatureWithImage:(UIImage *)image
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)txhSignaturePadViewControllerShouldDismiss:(TXHSignaturePadViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
