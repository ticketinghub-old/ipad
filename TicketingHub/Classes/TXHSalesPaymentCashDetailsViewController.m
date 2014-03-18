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

@interface TXHSalesPaymentCashDetailsViewController () <UITextFieldDelegate>

@property (strong, nonatomic) NSNumber *totalAmount;

@property (weak, nonatomic) IBOutlet UILabel     *totalAmountValueLabel;
@property (weak, nonatomic) IBOutlet UILabel     *changeValueLabel;
@property (weak, nonatomic) IBOutlet UITextField *givenAmountValueField;

@end

@implementation TXHSalesPaymentCashDetailsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.totalAmount = [TXHORDERMANAGER totalOrderPrice];
    self.totalAmountValueLabel.text = [TXHPRODUCTSMANAGER priceStringForPrice:self.totalAmount];
    
    [self givenAmountValueChanged:self.givenAmountValueField];
}

- (IBAction)givenAmountValueChanged:(id)sender
{
    CGFloat givenAmount  = [self.givenAmountValueField.text floatValue];
    CGFloat changeAmount = [self.totalAmount floatValue] - givenAmount * 100;

    NSString *changeString = [TXHPRODUCTSMANAGER priceStringForPrice:@(fabs(changeAmount))];
    if (changeAmount < 0)
        changeString = [@"-" stringByAppendingString:changeString];
    
    self.changeValueLabel.text = changeString;
}

@end
