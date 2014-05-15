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

#import "TXHInfineaManger.h"

#import "TXHCardView.h"
#import "TXHCardView+TXHCustomXIB.h"

#import <Block-KVO/MTKObserving.h>

@interface TXHSalesPaymentCreditDetailsViewController () <TXHSignaturePadViewControllerDelegate>

@property (readwrite, nonatomic, getter = isValid) BOOL valid;
@property (strong, nonatomic) TXHInfineaManger *infineaManager;

@property (strong, nonatomic) IBOutlet TXHCardView *cardView;
@property (copy, nonatomic) NSString *cardTrackData;

@end

@implementation TXHSalesPaymentCreditDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeInfineaManger];
    [self registerForScannersRecognitionNotifications];
    
    [self observeCardView];
}

- (void)dealloc
{
    [self unregisterFromScannersRecognitionNotifications];
}

- (void)initializeInfineaManger
{
    TXHInfineaManger *manger = [TXHInfineaManger sharedManager];
    self.infineaManager = manger;

    [manger connect];
}

- (void)showSignatureView
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

- (void)observeCardView
{
    [self observeProperty:@keypath(self.cardView.valid) withBlock:^(__weak TXHSalesPaymentCreditDetailsViewController *wself, id old, id new) {
        NSLog(@"cardnumber: %@",wself.cardView.card.number);
        NSLog(@"exipry month: %d",wself.cardView.card.expMonth);
        NSLog(@"expiry year: %d",wself.cardView.card.expYear);
        NSLog(@"cvv: %@",wself.cardView.card.cvc);
    }];
}

#pragma mark - Infinea Notification

- (void)registerForScannersRecognitionNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(scannerMSRDataRecognized:)
                                                 name:TXHScannerRecognizedMSRCardDataNotification
                                               object:self.infineaManager];
}

- (void)unregisterFromScannersRecognitionNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:TXHScannerRecognizedMSRCardDataNotification
                                                  object:self.infineaManager];
}


- (void)scannerMSRDataRecognized:(NSNotification *)note
{
    if (note.object == self.infineaManager)
    {
        NSString *cardTrack = [note userInfo][TXHScannerRecognizedValueKey];
        self.cardTrackData = cardTrack;
        
        self.cardView.skipFronSide = [cardTrack length] > 0;
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
