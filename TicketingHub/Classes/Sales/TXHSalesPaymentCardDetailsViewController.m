//
//  TXHSalesPaymentCardDetailsViewController.m
//  TicketingHub
//
//  Created by Mark on 14/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesPaymentCardDetailsViewController.h"

#import "TXHCreditCardNumberView.h"

@interface TXHSalesPaymentCardDetailsViewController ()

@property (weak, nonatomic) IBOutlet TXHCreditCardNumberView *creditCard;

@end

@implementation TXHSalesPaymentCardDetailsViewController

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
}

- (void)viewWillAppear:(BOOL)animated {
    self.creditCard.cardType = @"visa";
    self.creditCard.cardNumber = @"1234 5678 9012 3456";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
