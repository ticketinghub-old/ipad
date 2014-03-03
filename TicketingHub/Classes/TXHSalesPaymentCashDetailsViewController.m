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

@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (strong, nonatomic) NSNumber *totalAmount;

@end

@implementation TXHSalesPaymentCashDetailsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.totalAmount = [TXHORDERMANAGER totalOrderPrice];
    
    self.totalAmountLabel.text = [TXHPRODUCTSMANAGER priceStringForPrice:self.totalAmount];
}


@end
