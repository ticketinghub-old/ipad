//
//  TXHDoorOrderDetailsViewController.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 13/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHDoorOrderDetailsViewController.h"
#import "TXHBorderedButton.h"
#import "TXHProductsManager.h"
#import "NSDateFormatter+DisplayFormat.h"

#define dashIfEmpty(x) [x length] > 0 ? x : @"-"
#define dashIfZero(x) [x integerValue] != 0 ? x : @"-"



@interface TXHDoorOrderDetailsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *orderReferenceLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderOwnerFullNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderOwnerEmailLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderOwnerPhoneNumberLabel;

@property (weak, nonatomic) IBOutlet UILabel *confirmedOnValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *staffNumberValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *directOrderValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymentTypeValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *last4ValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardExpiryDateValueLabel;

@end

@implementation TXHDoorOrderDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)setOrder:(TXHOrder *)order
{
    _order = order;
    
    [self updateLabels];
}

- (void)updateLabels
{
    TXHCustomer *customer = self.order.customer;
    TXHOrder *order       = self.order;
    
    self.orderReferenceLabel.text        = [NSString stringWithFormat:NSLocalizedString(@"ORDER_DETAILS_TITLE_FORMAT", nil),order.reference];

    self.orderOwnerFullNameLabel.text    = dashIfEmpty(customer.fullName);
    self.orderOwnerEmailLabel.text       = dashIfEmpty(customer.email);
    self.orderOwnerPhoneNumberLabel.text = dashIfEmpty(customer.telephone);
    
    self.confirmedOnValueLabel.text    = dashIfEmpty([NSDateFormatter txh_fullDateStringFromDate:self.order.confirmedAt]);
    self.couponValueLabel.text         = dashIfEmpty(order.coupon);
    self.staffNumberValueLabel.text    = dashIfEmpty(@"-");
    self.groupValueLabel.text          = [order.group boolValue] ? @"Yes" : @"No";
    self.directOrderValueLabel.text    = [order.directt boolValue] ? @"Yes" : @"No";
    self.totalPriceValueLabel.text     = [self.productManager priceStringForPrice:order.total];

    self.paymentTypeValueLabel.text    = dashIfEmpty(order.payment.type);
    self.last4ValueLabel.text          = dashIfEmpty(order.payment.card.last4);
    self.cardExpiryDateValueLabel.text = [NSString stringWithFormat:@"%@/%@",dashIfZero(order.payment.card.month), dashIfZero(order.payment.card.year)];
}

@end
