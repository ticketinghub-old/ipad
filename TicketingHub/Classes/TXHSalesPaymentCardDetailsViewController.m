//
//  TXHSalesPaymentCardDetailsViewController.m
//  TicketingHub
//
//  Created by Mark on 14/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesPaymentCardDetailsViewController.h"

#import "TXHSignaturePadViewController.h"

#import "NSString+Hex.h"
#import "TXHConfiguration.h"
#import "TXHActivityLabelView.h"

#import "DKPOSHandpointClient.h"
#import "TXHPayment+DKPOSClientTransactionInfo.h"

#import "TXHProductsManager.h"
#import "TXHOrderManager.h"

static void * HandpointConnectedContext = &HandpointConnectedContext;

@interface TXHSalesPaymentCardDetailsViewController () <DKPOSClientDelegate, TXHSignaturePadViewControllerDelegate>

@property (strong, nonatomic) DKPOSHandpointClient *handpointClient;
@property (strong, nonatomic) TXHActivityLabelView *activityView;

@property (readwrite, nonatomic, getter = isValid) BOOL valid;

@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (weak, nonatomic) IBOutlet UILabel  *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel  *infoLabel;

@property (strong, nonatomic) NSString *SVGSignatre;

@end

@implementation TXHSalesPaymentCardDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupHandpointClient];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self updateView];
}

- (void)updateView
{
    if (self.isValid)
    {
        self.payButton.enabled = NO;
        self.infoLabel.text    = @"Transaction Completed";
    }
    else
    {
        TXHOrder *order       = self.orderManager.order;
        NSString *priceString = [self.productManager priceStringForPrice:[order total]];
        
        self.amountLabel.text  = [NSString stringWithFormat:@"Amount to pay: %@",priceString];
        self.infoLabel.text    = self.handpointClient.isConnected ? @"Connected" : @"Disconnected" ;
        
        self.payButton.enabled = self.handpointClient.isConnected;
    }
}

- (IBAction)payAction:(id)sender
{
    TXHOrder *order = [self.orderManager order];
    
    NSError *error;
    [self.handpointClient saleWithAmount:3000
                                currency:order.currency
                             cardPresent:YES
                               reference:order.reference
                                   error:&error];
    
    if (error)
        [self showErrorWithTitle:NSLocalizedString(@"ERROR_TITLE", nil)
                         message:error.localizedDescription];
}

- (void)setupHandpointClient
{
    if (!self.handpointClient.isConnected)
        [self.handpointClient initialize];
    
    [self observerHandpointConnection];
}

- (DKPOSHandpointClient *)handpointClient
{
    if (!_handpointClient)
    {
        // generally share manager should cause less problems as reconeccting is a pain in the ars
        DKPOSHandpointClient *handpointClient = [DKPOSHandpointClient sharedClient];
        handpointClient.delegate = self;
        _handpointClient = handpointClient;
    }
    return _handpointClient;
}

- (TXHActivityLabelView *)activityView
{
    if (!_activityView)
        _activityView = [TXHActivityLabelView getInstanceInView:self.navigationController.view];
    
    return _activityView;
}

- (void)setGateway:(TXHGateway *)gateway
{
    _gateway = gateway;
    
    NSData *sharedSecretHexData = [gateway.sharedSecret hexData];
    [self.handpointClient setSharedSecret:sharedSecretHexData];
}

- (void)setValid:(BOOL)valid
{
    _valid = valid;
    
    [self updateView];
}

- (void)observerHandpointConnection
{
    [self.handpointClient addObserver:self
                           forKeyPath:@"handpointClient"
                              options:NSKeyValueObservingOptionNew
                              context:HandpointConnectedContext];
}

- (void)stopObservingHandpointConnection
{
    [self.handpointClient removeObserver:self forKeyPath:@"handpointClient" context:HandpointConnectedContext];
}

- (void)dealloc
{
    [self stopObservingHandpointConnection];
}

#pragma mark - NSKeyValueObserverRegistration

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == HandpointConnectedContext)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateView];
        });
    }
}

#pragma mark - DKPOSClientDelegate
#pragma mark optional

- (void)posClientDidConnectDevice
{
    [self updateView];
}
- (void)posClientDidDisconnectDevice
{
    [self updateView];
}

#pragma mark required

- (void)posClient:(NSObject<DKPOSClient>*)client transactionFinishedWithInfo:(DKPOSClientTransactionInfo*)info
{
    __weak typeof(self) wself = self;
    
    [self.activityView showWithMessage:NSLocalizedString(@"CARD_CONTROLLER_UPDATING_PAYMENT_MESSAGE", nil)
                       indicatorHidden:NO];
    
    [self.orderManager updateOrderWithPayment:[self paymentForClientTransactionInfo:info]
                                   completion:^(TXHOrder *order, NSError *error) {
                                       [wself.activityView hide];
                                       
                                       if (error)
                                       {
                                           [self showErrorWithTitle:NSLocalizedString(@"", nil)
                                                            message:NSLocalizedString(@"", nil)];
                                       }
                                       else
                                       {
                                           wself.valid = YES;
                                       }
                                   }];
}

- (TXHPayment *)paymentForClientTransactionInfo:(DKPOSClientTransactionInfo*)info
{
    NSManagedObjectContext *orderMoc = self.orderManager.order.managedObjectContext;
    
    TXHPayment *payment = [TXHPayment createWithTransactionInfo:info
                                         inManagedObjectContext:orderMoc];
    
    payment.signature = self.SVGSignatre;
    payment.gateway   = self.gateway;
    
    return payment;
}

- (void)posClient:(NSObject<DKPOSClient>*)client transactionFailedWithError:(NSError*)error
{
    [self.activityView hide];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"TRANSACTION_FAILED_TITLE", nil)
                                                        message:error.localizedDescription
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"ERROR_DISMISS_BUTTON_TITLE", nil)
                                              otherButtonTitles:nil];
    [alertView show];
    [self updateView];
}
- (void)posClient:(NSObject<DKPOSClient>*)client transactionStatusChanged:(DKPOSClientTransactionInfo*)info
{
    [self.activityView showWithMessage:[info localizedStatusDescription] indicatorHidden:NO];
}

- (void)posClient:(NSObject<DKPOSClient>*)client transactionSignatureRequested:(DKPOSClientTransactionInfo*)info
{
    [self performSegueWithIdentifier:@"ShowSignaturePad" sender:self];
}

- (void)posClient:(NSObject<DKPOSClient>*)client deviceConnectionError:(NSError*)error
{
    [self showErrorWithTitle:NSLocalizedString(@"DEVICE_CONNECTIONERROR_TITLE", nil) message:error.localizedDescription];
}

#pragma mark - error helper 

- (void)showErrorWithTitle:(NSString *)title message:(NSString *)message
{
    [self.activityView hide];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"ERROR_DISMISS_BUTTON_TITLE", nil)
                                              otherButtonTitles:nil];
    [alertView show];
}

#pragma mark - TXHSignaturePadViewControllerDelegate

- (void)txhSignaturePadViewController:(TXHSignaturePadViewController *)controller acceptSignatureWithImage:(UIImage *)image
{
    __weak typeof(self) wself = self;

    [self dismissViewControllerAnimated:YES completion:^{
        wself.SVGSignatre = controller.SVGSignature;
        [wself.handpointClient signatureAccepted];
    }];
}


- (void)txhSignaturePadViewControllerShouldDismiss:(TXHSignaturePadViewController *)controller
{
    __weak typeof(self) wself = self;
    
    [self dismissViewControllerAnimated:YES completion:^{
        [wself.handpointClient cancelTransaction];
    }];
}


@end
