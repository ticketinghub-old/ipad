//
//  TXHSalesPaymentCreditDetailsViewController.m
//  TicketingHub
//
//  Created by Mark on 14/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesPaymentCreditDetailsViewController.h"
#import "TXHActivityLabelView.h"

#import "TXHOrderManager.h"
#import "TXHProductsManager.h"

#import "TXHScanersManager.h"

#import "TXHCardView.h"
#import "TXHCardView+TXHCustomXIB.h"

#import "TXHPayment+PKCard.h"

#import "TXHFullScreenKeyboardViewController.h"
#import <UIAlertView-Blocks/UIAlertView+Blocks.h>


@interface TXHSalesPaymentCreditDetailsViewController () <TXHFullScreenKeyboardViewControllerDelegate, TXHScanersManagerDelegate, TXHCardViewDelegate>

@property (readwrite, assign, nonatomic, getter = isValid) BOOL valid;
@property (readwrite, assign, nonatomic) BOOL shouldBeSkiped;

@property (nonatomic, strong) TXHScanersManager *scanersManager;

@property (nonatomic, copy) NSString *cardTrackData;

@property (nonatomic, strong) IBOutlet UILabel     *mainLabel;
@property (nonatomic, strong) IBOutlet UILabel     *descriptionLabel;
@property (nonatomic, strong) IBOutlet TXHCardView *cardView;
@property (nonatomic, strong) IBOutlet UIView      *containerView;

@property (nonatomic, strong) TXHActivityLabelView *activityView;

@property (nonatomic, strong) TXHFullScreenKeyboardViewController *fullScreenController;

@end

@implementation TXHSalesPaymentCreditDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeMSRScanner];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateView];
    self.scanersManager.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.fullScreenController hideAniamted:NO
                                 completion:nil];
    self.scanersManager.delegate = nil;
}

- (void)setValid:(BOOL)valid
{
    _valid = valid;
    
    [self updateView];
}

- (void)initializeMSRScanner
{
    TXHScanersManager *scannersManger = [[TXHScanersManager alloc] initWithInfineaManager:[TXHInfineaManger sharedManager]
                                                                       andScanApiManager:nil];
    scannersManger.delegate = self;
    self.scanersManager = scannersManger;
}

- (void)showCardFullScreen
{
    if (self.fullScreenController)
        return;
    
    TXHFullScreenKeyboardViewController *full = [[TXHFullScreenKeyboardViewController alloc] init];
    full.destinationBackgroundColor = [UIColor whiteColor];
    full.delegate = self;
    
    self.fullScreenController = full;
    
    __weak typeof(self) wself = self;
    
    [full showWithView:self.containerView
            completion:^{
        [wself.cardView becomeFirstResponder];
    }];
}

- (void)setCardTrackData:(NSString *)cardTrackData
{
    _cardTrackData = cardTrackData;
    
    self.cardView.skipFronSide = [cardTrackData length] > 0;
}

- (TXHActivityLabelView *)activityView
{
    if (!_activityView)
        _activityView = [TXHActivityLabelView getInstanceInView:self.view];
    
    return _activityView;
}

- (void)updateView
{
    TXHCardSide cardSide = self.cardView.cardSide;
    [self updateLabelsForCardSide:cardSide];
}

- (void)updateLabelsForCardSide:(TXHCardSide)cardSide
{
    if (self.isValid)
    {
        self.mainLabel.text        = NSLocalizedString(@"SALESMAN_PAYMENT_CNP_MAIN_LABEL_TEXT_CARD_VALID", nil);
        self.descriptionLabel.text = NSLocalizedString(@"SALESMAN_PAYMENT_CNP_DESCRIPTION_LABEL_TEXT_CARD_VALID", nil);
    }
    else
    {
        self.mainLabel.text        = [self mainLabelTextForCardSide:cardSide];
        self.descriptionLabel.text = [self descriptionLabelTextForCardSide:cardSide];
    }
}

- (NSString *)mainLabelTextForCardSide:(TXHCardSide)cardSide
{
    switch (cardSide) {
        case TXHCardSideFront: return NSLocalizedString(@"SALESMAN_PAYMENT_CNP_MAIN_LABEL_TEXT_CARD_FRONT", nil);
        case TXHCardSideBack:  return NSLocalizedString(@"SALESMAN_PAYMENT_CNP_MAIN_LABEL_TEXT_CARD_BACK", nil);
    }
    return nil;
}

- (NSString *)descriptionLabelTextForCardSide:(TXHCardSide)cardSide
{
    switch (cardSide) {
        case TXHCardSideFront: return NSLocalizedString(@"SALESMAN_PAYMENT_CNP_DESCRIPTION_LABEL_TEXT_CARD_FRONT", nil);
        case TXHCardSideBack:  return NSLocalizedString(@"SALESMAN_PAYMENT_CNP_DESCRIPTION_LABEL_TEXT_CARD_BACK", nil);
    }
    return nil;
}

#pragma mark - TXHScanersManagerDelegate

- (void)scannerManager:(TXHScanersManager *)manager didRecognizeMSRCardTrack:(NSString *)cardTrackData
{
    if (!self.fullScreenController)
    {
        self.cardTrackData = cardTrackData;
        [self showCardFullScreen];
    }
}

#pragma mark - TXHCardViewDelegate

- (void)txhCardView:(TXHCardView *)cardView didFlipToSide:(TXHCardSide)cardSide
{
    [self updateLabelsForCardSide:cardSide];
}

- (void)txhCardView:(TXHCardView *)cardView didFinishValid:(BOOL)valid withCardInfo:(PKCard *)card
{
    if (valid)
    {
        [self hideAndAcceptCard];
    }
    else
    {
        [self hideAndResetCard];
    }
    
    self.valid = valid;
}

- (void)hideAndAcceptCard
{
    if (![self.cardTrackData length])
        [self.cardView flipToCardSide:TXHCardSideFront];
    
    __weak typeof(self) wself = self;
    
    [self.fullScreenController hideAniamted:YES
                                 completion:^{
                                     [wself disableCardAnimated:YES];
                                 }];
}

- (void)disableCardAnimated:(BOOL)aniamted
{
    if (aniamted)
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.cardView.enabled = NO;
                         }];
    else
        self.cardView.enabled = NO;
}

- (TXHPayment *)cnpPayment
{
    return [self paymentForCardInfo:self.cardView.card cardTrackData:self.cardTrackData];
}

- (TXHPayment *)paymentForCardInfo:(PKCard *)card cardTrackData:(NSString *)cardTrackData
{
    NSManagedObjectContext *orderMoc = self.gateway.managedObjectContext;
    
    TXHPayment *payment = [TXHPayment createWithCard:card
                                       cardTrackData:cardTrackData
                                         inManagedObjectContext:orderMoc];
    payment.gateway   = self.gateway;
    
    return payment;
}

- (void)txhCardViewDidStartEditing:(TXHCardView *)cardView
{
    [self showCardFullScreen];
}

#pragma mark - TXHFullScreenKeyboardViewControllerDelegate

- (void)txhFullScreenKeyboardViewControllerDismiss:(TXHFullScreenKeyboardViewController *)controller
{
    [self.cardView resignFirstResponder];
    [self hideAndResetCard];
}

- (void)hideAndResetCard
{
    [self.cardView reset];
    
    [self.fullScreenController hideAniamted:YES completion:nil];
    self.fullScreenController = nil;
}

#pragma mark - TXHSalesPaymentContentViewControllerProtocol

- (void)finishWithCompletion:(void(^)(NSError *))completion
{
    [self.activityView showWithMessage:NSLocalizedString(@"CNP_CONTROLLER_UPDATING_PAYMENT_MESSAGE", nil)
                       indicatorHidden:NO];

    __weak typeof(self) wself = self;

    [self.orderManager updateOrderWithPayment:[self cnpPayment]
                                   completion:^(TXHOrder *order, NSError *error) {
                                       [wself.activityView hide];
                                       
                                       if (error)
                                       {
                                           [wself showErrorWithTitle:NSLocalizedString(@"ERROR_TITLE", nil)
                                                             message:error.localizedDescription
                                                              action:^{
                                                                  if (completion)
                                                                      completion(error);
                                                              }];
                                       }
                                       else if (completion)
                                           completion(error);
                                   }];
}

#pragma mark - error helper

- (void)showErrorWithTitle:(NSString *)title message:(NSString *)message action:(void(^)(void))action
{
    [self.activityView hide];
    
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
