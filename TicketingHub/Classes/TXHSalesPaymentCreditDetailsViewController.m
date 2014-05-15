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
#import "TXHInfineaManger.h"

@property (readwrite, nonatomic, getter = isValid) BOOL valid;
@property (strong, nonatomic) TXHInfineaManger *infineaManager;

@end

@implementation TXHSalesPaymentCreditDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeInfineaManger];
    [self registerForScannersRecognitionNotifications];
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
//        NSString *cardTrack = [note userInfo][TXHScannerRecognizedValueKey];
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
