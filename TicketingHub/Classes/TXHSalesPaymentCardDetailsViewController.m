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
#import <UIAlertView-Blocks/UIAlertView+Blocks.h>

#import "DKPOSHandpointClient.h"
#import "DKPOSClientTransactionInfo+Messages.h"
#import "TXHPayment+DKPOSClientTransactionInfo.h"

#import "TXHProductsManager.h"
#import "TXHOrderManager.h"

@interface TXHSalesPaymentCardDetailsViewController () <DKPOSClientDelegate, TXHSignaturePadViewControllerDelegate>

@property (strong, nonatomic) DKPOSHandpointClient *handpointClient;
@property (strong, nonatomic) TXHActivityLabelView *activityView;

@property (readwrite, assign, nonatomic, getter = isValid) BOOL valid;
@property (readwrite, assign, nonatomic) BOOL shouldBeSkiped;

@property (strong, nonatomic) NSString *SVGSignatre;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (copy, nonatomic) void(^completion)(NSError *error);

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowSignaturePad"])
    {
        TXHSignaturePadViewController *signaturePadController = segue.destinationViewController;
        signaturePadController.delegate         = self;
        signaturePadController.totalPriceString = [self.productManager priceStringForPrice:self.orderManager.order.total];
    }
}

- (void)updateView
{
    [self updateViewWithDKPOSClientTransactionInfo:nil];
}

- (void)updateViewWithDKPOSClientTransactionInfo:(DKPOSClientTransactionInfo*)info
{
    self.valid = self.handpointClient.isConnected;
    
    self.mainLabel.text        = [self mainLabelTextForDKPOSClientTransactionInfo:info];
    self.imageView.image       = [self iconImageForDKPOSClientTransactionInfo:info];
    
    [self setDescriptionText:[self descriptionLabelTextForDKPOSClientTransactionInfo:info]];
}

- (void)setDescriptionText:(NSString *)descriptionText
{
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString:descriptionText];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setAlignment:NSTextAlignmentCenter];

    [style setLineSpacing:12];

    [attrString addAttribute:NSParagraphStyleAttributeName
                       value:style
                       range:NSMakeRange(0, [descriptionText length])];
    
    self.descriptionLabel.attributedText = attrString;
}

- (NSString *)mainLabelTextForDKPOSClientTransactionInfo:(DKPOSClientTransactionInfo*)info
{
    if (info)
        return [info titleText];
    else if (self.isValid)
        return NSLocalizedString(@"SALESMAN_PAYMENT_HANDPOINT_DEVICE_CONNECTED_TITLE", nil);
    else
        return NSLocalizedString(@"SALESMAN_PAYMENT_HANDPOINT_DEVICE_DISCONNECTED_TITLE", nil);
    
    return nil;
}

- (NSString *)descriptionLabelTextForDKPOSClientTransactionInfo:(DKPOSClientTransactionInfo*)info
{
    if (info)
        return [info descriptionText];
    else if (self.isValid)
        return NSLocalizedString(@"SALESMAN_PAYMENT_HANDPOINT_DEVICE_CONNECTED_DESCRIPTION", nil);
    else
        return NSLocalizedString(@"SALESMAN_PAYMENT_HANDPOINT_DEVICE_DISCONNECTED_DESCRIPTION", nil);
    
    return nil;
}

- (UIImage *)iconImageForDKPOSClientTransactionInfo:(DKPOSClientTransactionInfo*)info
{
    if (info)
        return [info iconImage];
    
    return [UIImage imageNamed:@"Connected_Icon.png"];
}

- (void)setupHandpointClient
{
    if (!self.handpointClient.isConnected)
        [self.handpointClient initialize];
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
        _activityView = [TXHActivityLabelView getInstanceInView:self.view];
    
    return _activityView;
}

- (void)setGateway:(TXHGateway *)gateway
{
    _gateway = gateway;
    
    NSData *sharedSecretHexData = [gateway.sharedSecret hexData];
    [self.handpointClient setSharedSecret:sharedSecretHexData];
}

#pragma mark - DKPOSClientDelegate

- (void)posClientDidConnectDevice
{
    [self updateView];
}
- (void)posClientDidDisconnectDevice
{
    [self updateView];
}

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
                                           [self showErrorWithTitle:NSLocalizedString(@"ERROR_TITLE", nil)
                                                            message:error.errorDescription
                                                             action:^{
                                                                 if (self.completion)
                                                                     self.completion(error);
                                                            }];
                                       }
                                       else if (self.completion)
                                           self.completion(error);
                                       
                                   }];
}

- (TXHPayment *)paymentForClientTransactionInfo:(DKPOSClientTransactionInfo*)info
{
    NSManagedObjectContext *paymentMoc = self.gateway.managedObjectContext;
    
    TXHPayment *payment = [TXHPayment createWithTransactionInfo:info
                                         inManagedObjectContext:paymentMoc];
    
    payment.signature = self.SVGSignatre;
    payment.gateway   = self.gateway;
    
    return payment;
}

- (void)posClient:(NSObject<DKPOSClient>*)client transactionFailedWithError:(NSError*)error
{
    [self updateView];
    
    [self showErrorWithTitle:NSLocalizedString(@"TRANSACTION_FAILED_TITLE", nil)
                     message:error.errorDescription
                      action:^{
                          if (self.completion)
                              self.completion(error);
                      }];
}

- (void)posClient:(NSObject<DKPOSClient>*)client transactionStatusChanged:(DKPOSClientTransactionInfo*)info
{
    [self updateViewWithDKPOSClientTransactionInfo:info];
}

- (void)posClient:(NSObject<DKPOSClient>*)client transactionSignatureRequested:(DKPOSClientTransactionInfo*)info
{
    [self performSegueWithIdentifier:@"ShowSignaturePad"
                              sender:self];
}

- (void)posClient:(NSObject<DKPOSClient>*)client deviceConnectionError:(NSError*)error
{
    [self updateView];

    [self showErrorWithTitle:NSLocalizedString(@"DEVICE_CONNECTION_ERROR_TITLE", nil)
                     message:error.errorDescription
                      action:^{
                          if (self.completion)
                              self.completion(error);
                      }];
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

#pragma mark - TXHSalesPaymentContentViewControllerProtocol

- (void)finishWithCompletion:(void(^)(NSError *))completion
{
    self.completion = completion;
    
    TXHOrder *order = [self.orderManager order];
    
    NSError *error;
    [self.handpointClient saleWithAmount:order.totalValue
                                currency:order.currency
                             cardPresent:YES
                               reference:order.reference
                                   error:&error];
    
    if (error)
    {
        [self showErrorWithTitle:NSLocalizedString(@"ERROR_TITLE", nil)
                         message:error.errorDescription
                          action:^{
                              if (completion)
                                  completion(error);
                         }];
    }
}

#pragma mark - error helper

- (void)showErrorWithTitle:(NSString *)title message:(NSString *)message action:(void(^)(void))action
{
    RIButtonItem *cancelItem = [RIButtonItem itemWithLabel:NSLocalizedString(@"ERROR_DISMISS_BUTTON_TITLE", nil)
                                                    action:^{
                                                        if (action)
                                                            action();
                                                    }];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                               cancelButtonItem:cancelItem
                                               otherButtonItems: nil];
    [alertView show];
}


@end
