//
//  TXHDoorOrderDetailsViewController.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 13/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHDoorOrderDetailsViewController.h"
#import "TXHBorderedButton.h"
#import <iOS-api/NSDateFormatter+TicketingHubFormat.h>


#define dashIfEmpty(x) [x length] > 0 ? x : @"-"


@interface TXHDoorOrderDetailsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fullNameValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardTypeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cardTypeImageView;
@property (weak, nonatomic) IBOutlet UILabel *cardTypeValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *expiryLabel;
@property (weak, nonatomic) IBOutlet UILabel *expiryValueLabel;

@property (weak, nonatomic) IBOutlet TXHBorderedButton *cancelRefundButton;

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
    
    self.fullNameValueLabel.text = dashIfEmpty(customer.fullName);
    self.emailValueLabel.text    = dashIfEmpty(customer.email);
    self.phoneValueLabel.text    = dashIfEmpty(customer.telephone);
    self.countryValueLabel.text  = dashIfEmpty(customer.address.country);
    
    self.cardValueLabel.text     = dashIfEmpty(@"");
    self.cardTypeValueLabel.text = dashIfEmpty(@"");
    self.expiryValueLabel.text   = dashIfEmpty([NSDateFormatter txh_stringFromDate:self.order.expiresAt]);
}

#pragma mark - Actions

- (IBAction)cancelRefundButtonAction:(id)sender
{

}

@end
