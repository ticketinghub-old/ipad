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

// TODO: add activity view

@interface TXHSalesPaymentCashDetailsViewController () <TXHPrinterSelectionViewControllerDelegate>

@property (strong, nonatomic) NSNumber *totalAmount;

@property (readwrite, nonatomic, getter = isValid) BOOL valid;

@property (weak, nonatomic) IBOutlet UILabel           *totalAmountValueLabel;
@property (weak, nonatomic) IBOutlet UILabel           *changeValueLabel;
@property (weak, nonatomic) IBOutlet UITextField       *givenAmountValueField;
@property (weak, nonatomic) IBOutlet TXHBorderedButton *openDrawerButton;

@property (strong, nonatomic) TXHActivityLabelView *activityView;

@property (strong, nonatomic) UIPopoverController *printerSelectionPopover;

@end

@implementation TXHSalesPaymentCashDetailsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateView];
}

- (void)setProductManager:(TXHProductsManager *)productManager
{
    _productManager = productManager;
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
        _activityView = [TXHActivityLabelView getInstanceInView:self.navigationController.view];
    
    return _activityView;
}

- (void)updateView
{
    self.totalAmountValueLabel.text = [self.productManager priceStringForPrice:self.totalAmount];
    
    [self givenAmountValueChanged:self.givenAmountValueField];
}

- (IBAction)givenAmountValueChanged:(id)sender
{
    CGFloat givenAmount  = [self.givenAmountValueField.text floatValue];
    CGFloat changeAmount = (givenAmount * 100) - [self.totalAmount floatValue];
    
    self.valid = (changeAmount >= 0);
    
    self.changeValueLabel.text = [self changeStringForChangeAmount:changeAmount];
}

- (NSString *)changeStringForChangeAmount:(CGFloat)amount
{
    NSString *changeString;
    
    if (amount > 0)
        changeString = [self.productManager priceStringForPrice:@(amount)];
    else if (amount < 0)
        changeString = NSLocalizedString(@"CASH_CONTROLLER_NOT_ENOUGH_PAID_MESSAGE", nil);
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
                                 message:error.localizedDescription
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
                                                             message:error.localizedDescription
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

@end
