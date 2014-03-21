//
//  TXHSalesTicketCompletionViewController.m
//  TicketingHub
//
//  Created by Mark on 31/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesTicketCompletionViewController.h"
#import "NSDateFormatter+DisplayFormat.h"


#import "TXHOrderManager.h"
#import "TXHProductsManager.h"

@interface TXHSalesTicketCompletionViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *summaryDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryTotalLabel;

@property (readwrite, nonatomic, getter = isValid) BOOL valid;

@end

@implementation TXHSalesTicketCompletionViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    TXHOrder *order = [TXHORDERMANAGER order];
    NSNumber *totalPrice = [order total];
    NSDate *validFromDate = [(TXHTicket *)[order.tickets anyObject] validFrom];
    
    self.summaryTotalLabel.text = [TXHPRODUCTSMANAGER priceStringForPrice:totalPrice];
    self.summaryDateLabel.text  = [NSDateFormatter txh_fullDateStringFromDate:validFromDate];
    
    self.valid = YES;
}

@end
