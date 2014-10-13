
//
//  TXHSalesPaymentCashDetailsViewController.m
//  TicketingHub
//
//  Created by Mark on 14/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesPaymentCashDetailsViewController.h"

#import "TXHOrderManager.h"
#import "TXHProductsManager.h"

#import "TXHPrinter.h"
#import "TXHPrintersManager.h"
#import "TXHPrinterSelectionViewController.h"

#import "TXHActivityLabelView.h"
#import "TXHBorderedButton.h"

#import <UIAlertView-Blocks/UIAlertView+Blocks.h>
#import <TSCurrencyTextField/TSCurrencyTextField.h>
#import <QuartzCore/QuartzCore.h>

#import "TXHFullScreenKeyboardViewController.h"

// TODO: add activity view

@interface TXHSalesPaymentCashDetailsViewController () <UITextFieldDelegate, TXHPrinterSelectionViewControllerDelegate, TXHFullScreenKeyboardViewControllerDelegate>

@property (strong, nonatomic) NSNumber *totalAmount;

@property (readwrite, assign, nonatomic, getter = isValid) BOOL valid;
@property (readwrite, assign, nonatomic) BOOL shouldBeSkiped;

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *changeLabel;
@property (weak, nonatomic) IBOutlet UILabel *changeValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *givenAmountLabel;

@property (weak, nonatomic) IBOutlet UIView              *givenAmountBackground;
@property (weak, nonatomic) IBOutlet TSCurrencyTextField *givenAmountValueField;

@property (strong, nonatomic) TXHActivityLabelView *activityView;

@property (strong, nonatomic) UIPopoverController *printerSelectionPopover;
@property (weak, nonatomic) IBOutlet TXHBorderedButton *openDrawerButton;

@property (nonatomic, strong) TXHFullScreenKeyboardViewController *fullScreenController;

@end

@implementation TXHSalesPaymentCashDetailsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.givenAmountBackground.layer.cornerRadius = 10.0f;
    self.valid = YES;
    
    [self updateGivenAmountFieldCurrncy];
}

- (void)updateGivenAmountFieldCurrncy
{
    NSString *currencyCode = self.productManager.selectedProduct.currency;
    [self.givenAmountValueField.currencyNumberFormatter setCurrencyCode:currencyCode];
    self.givenAmountValueField.amount = @(0);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.fullScreenController hideAniamted:NO
                                 completion:nil];
    self.fullScreenController = nil;
}

- (void)setProductManager:(TXHProductsManager *)productManager
{
    _productManager = productManager;

    [self updateGivenAmountFieldCurrncy];
    [self updateView];
}

- (void)setOrderManager:(TXHOrderManager *)orderManager
{
    _orderManager    = orderManager;
    self.totalAmount = orderManager.order.total;
    
    [self updateView];
}

- (TXHPayment *)cashPayment
{
    NSManagedObjectContext *orderMoc = self.orderManager.order.managedObjectContext;
    
    TXHPayment *payment = [TXHPayment insertInManagedObjectContext:orderMoc];
    payment.type = @"cash";
    
    return payment;
}

- (TXHActivityLabelView *)activityView
{
    if (!_activityView)
        _activityView = [TXHActivityLabelView getInstanceInView:self.view];
    
    return _activityView;
}

- (void)updateView
{
    self.totalAmountValueLabel.text = [self.productManager priceStringForPrice:self.totalAmount];
    
    [self givenAmountValueChanged:self.givenAmountValueField];
    
    
}

- (IBAction)givenAmountValueChanged:(id)sender
{
    CGFloat givenAmount  = [self.givenAmountValueField.amount floatValue];
    CGFloat changeAmount = (givenAmount * 100) - [self.totalAmount floatValue];
        
    self.changeValueLabel.text = [self changeStringForChangeAmount:changeAmount];
}

- (NSString *)changeStringForChangeAmount:(CGFloat)amount
{
    NSString *changeString;
    
    if (amount > 0)
    {
        if (amount > 1000000)
            changeString = @"SRSLY?";
        else
            changeString = [self.productManager priceStringForPrice:@(amount)];
    }
    else if (amount < 0)
        changeString = NSLocalizedString(@"CASH_CONTROLLER_NOT_PAID_ENOUGH_MESSAGE", nil);
    else
        changeString = NSLocalizedString(@"CASH_CONTROLLER_NO_CHANGE_MESSAGE", nil);
    
    return changeString;
}

- (IBAction)openDrawerButtonAction:(id)sender
{
    [self showDrawerPrintersSelectionViewController];
}

- (void)showDrawerPrintersSelectionViewController
{
    TXHPrinterSelectionViewController *printerSelector = [[TXHPrinterSelectionViewController alloc] initWithPrintersManager:TXHPRINTERSMANAGER];
    printerSelector.onlyPrintersWithDrawer = YES;
    printerSelector.delegate               = self;
    
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:printerSelector];
    popover.popoverContentSize = CGSizeMake(200, 110);
    
    CGRect fromRect = [self.openDrawerButton.superview convertRect:self.openDrawerButton.frame toView:self.view];
    
    [popover presentPopoverFromRect:fromRect
                             inView:self.view
           permittedArrowDirections:UIPopoverArrowDirectionAny
                           animated:YES];
    
    self.printerSelectionPopover = popover;
}

- (void)hideDrawerPrintersSelectionViewController
{
    [self.printerSelectionPopover dismissPopoverAnimated:YES];
    self.printerSelectionPopover = nil;

}

#pragma mark - TXHPrinterSelectionViewControllerDelegate

- (void)txhPrinterSelectionViewController:(TXHPrinterSelectionViewController *)controller
                         didSelectPrinter:(TXHPrinter *)printer
{
    [self hideDrawerPrintersSelectionViewController];
    [self openDrawerWithPrinter:printer];
}

- (void)openDrawerWithPrinter:(TXHPrinter *)printer
{
    if (printer.canOpenDrawer)// double check
        [printer openDrawerWithCompletion:^(NSError *error, BOOL cancelled) {
            if (error)
                [self showErrorWithTitle:NSLocalizedString(@"ERROR_TITLE", nil)
                                 message:error.errorDescription
                                  action:nil];
        }];
}

#pragma mark - TXHSalesPaymentContentViewControllerProtocol

- (void)finishWithCompletion:(void(^)(NSError *))completion
{
    TXHPayment *payment = [self cashPayment];
    
    [self.activityView showWithMessage:NSLocalizedString(@"CASH_CONTROLLER_UPDATING_PAYMENT_MESSAGE", nil)
                       indicatorHidden:NO];
    
    __weak typeof(self) wself = self;
    [self.orderManager updateOrderWithPayment:payment
                                   completion:^(TXHOrder *order, NSError *error) {
                                       [wself.activityView hide];
                                       
                                       if (error)
                                       {
                                           [wself showErrorWithTitle:NSLocalizedString(@"ERROR_TITLE", nil)
                                                             message:error.errorDescription
                                                              action:^{
                                                                  if (completion)
                                                                      completion(error);
                                                              }];
                                       }
                                       else if (completion)
                                           completion(nil);
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

#pragma mark UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self showFullScreen];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self hideFullScreen];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)showFullScreen
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
                [wself.givenAmountValueField becomeFirstResponder];
            }];
}

- (void)hideFullScreen
{
    __weak typeof(self) wself = self;
    
    [self.fullScreenController hideAniamted:YES
                                 completion:^{
                                     [wself.activityView.superview bringSubviewToFront:wself.activityView];
                                 }];
    self.fullScreenController = nil;

}

#pragma mark - TXHFullScreenKeyboardViewControllerDelegate

- (void)txhFullScreenKeyboardViewControllerDismiss:(TXHFullScreenKeyboardViewController *)controller
{
    [self.givenAmountValueField resignFirstResponder];
    [self hideFullScreen];
}


@end
