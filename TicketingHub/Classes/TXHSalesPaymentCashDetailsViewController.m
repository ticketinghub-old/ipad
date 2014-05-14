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

#import "TXHBorderedButton.h"
#import "TXHPrinter.h"
#import "TXHPrintersManager.h"
#import "TXHPrinterSelectionViewController.h"

@interface TXHSalesPaymentCashDetailsViewController () <TXHPrinterSelectionViewControllerDelegate>

@property (strong, nonatomic) NSNumber *totalAmount;

@property (readwrite, nonatomic, getter = isValid) BOOL valid;
@property (readwrite, nonatomic, getter = isEnabled) BOOL enabled;

@property (weak, nonatomic) IBOutlet UILabel     *totalAmountValueLabel;
@property (weak, nonatomic) IBOutlet UILabel     *changeValueLabel;
@property (weak, nonatomic) IBOutlet UITextField *givenAmountValueField;

@property (weak, nonatomic) IBOutlet TXHBorderedButton *openDrawerButton;
@property (strong, nonatomic) UIPopoverController *printerSelectionPopover;

@end

@implementation TXHSalesPaymentCashDetailsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.enabled = YES;

    [self updateView];

    NSManagedObjectContext *orderMoc = self.orderManager.order.managedObjectContext;
    
    TXHPayment *payment = [TXHPayment insertInManagedObjectContext:orderMoc];
    payment.type = @"cash";
    
    __weak typeof(self) wself = self;
    [self.orderManager updateOrderWithPayment:payment
                                   completion:^(TXHOrder *order, NSError *error) {
                                       
                                       wself.valid = (error == nil);
                                       [wself updateView];
                                   }];
}

- (void)setProductManager:(TXHProductsManager *)productManager
{
    _productManager = productManager;
    [self updateView];

}

- (void)setOrderManager:(TXHOrderManager *)orderManager
{
    _orderManager = orderManager;
    [self updateView];
}

- (void)updateView
{
    self.totalAmount = [self.orderManager totalOrderPrice];
    self.totalAmountValueLabel.text = [self.productManager priceStringForPrice:self.totalAmount];
    
    [self givenAmountValueChanged:self.givenAmountValueField];
}

- (IBAction)givenAmountValueChanged:(id)sender
{
    CGFloat givenAmount  = [self.givenAmountValueField.text floatValue];
    CGFloat changeAmount = [self.totalAmount floatValue] - givenAmount * 100;

    NSString *changeString = [self.productManager priceStringForPrice:@(fabs(changeAmount))];
    if (changeAmount < 0)
        changeString = [@"-" stringByAppendingString:changeString];
    
    self.changeValueLabel.text = changeString;
}

- (IBAction)openDrawerButtonAction:(id)sender
{
    TXHPrinterSelectionViewController *printerSelector = [[TXHPrinterSelectionViewController alloc] initWithPrintersManager:TXHPRINTERSMANAGER];
    printerSelector.delegate = self;
    
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:printerSelector];
    popover.popoverContentSize = CGSizeMake(200, 110);
    
    CGRect fromRect = [self.openDrawerButton.superview convertRect:self.openDrawerButton.frame toView:self.view];
    
    [popover presentPopoverFromRect:fromRect
                             inView:self.view
           permittedArrowDirections:UIPopoverArrowDirectionAny
                           animated:YES];
    
    self.printerSelectionPopover = popover;
}

#pragma mark - TXHPrinterSelectionViewControllerDelegate

- (void)txhPrinterSelectionViewController:(TXHPrinterSelectionViewController *)controller
                         didSelectPrinter:(TXHPrinter *)printer
{
    
    [self.printerSelectionPopover dismissPopoverAnimated:YES];
    self.printerSelectionPopover = nil;

    // double check
    if (printer.canOpenDrawer)
    {
        [printer openDrawerWithCompletion:^(NSError *error, BOOL cancelled) {
            
        }];
    }
}


@end
