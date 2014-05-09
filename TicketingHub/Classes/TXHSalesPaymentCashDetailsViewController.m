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

@interface TXHSalesPaymentCashDetailsViewController ()

@property (strong, nonatomic) NSNumber *totalAmount;

@property (readwrite, nonatomic, getter = isValid) BOOL valid;
@property (readwrite, nonatomic, getter = isEnabled) BOOL enabled;

@property (weak, nonatomic) IBOutlet UILabel     *totalAmountValueLabel;
@property (weak, nonatomic) IBOutlet UILabel     *changeValueLabel;
@property (weak, nonatomic) IBOutlet UITextField *givenAmountValueField;

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

@end
