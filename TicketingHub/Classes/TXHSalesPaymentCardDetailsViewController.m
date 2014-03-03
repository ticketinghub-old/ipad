//
//  TXHSalesPaymentCardDetailsViewController.m
//  TicketingHub
//
//  Created by Mark on 14/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesPaymentCardDetailsViewController.h"

#import "PKTextField.h"
#import "PKView.h"
#import "STPView.h"

#import "TXHOrderManager.h"
#import "TXHProductsManager.h"

@interface TXHSalesPaymentCardDetailsViewController ()  <STPViewDelegate, PKViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (weak, nonatomic) IBOutlet STPView *stripeCreditCardView;

@property (weak, nonatomic) IBOutlet UILabel *cardErrorMessage;

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

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSNumber *totalAmount = [TXHORDERMANAGER totalOrderPrice];

    self.totalAmountLabel.text = [TXHPRODUCTSMANAGER priceStringForPrice:totalAmount];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
#pragma unused (tableView, indexPath)
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath {
#pragma unused (tableView, indexPath)
    return NO;
}


- (IBAction)scanCard:(id)sender {
    // Set some data - simulating getting details from a card reader
    PKTextField *numberField = self.stripeCreditCardView.paymentView.cardNumberField;
    PKTextField *expiryField = self.stripeCreditCardView.paymentView.cardExpiryField;
    PKTextField *cvcField = self.stripeCreditCardView.paymentView.cardCVCField;
    NSRange range;
    range.location = 0;
    range.length = numberField.text.length;
    [numberField.delegate textField:numberField shouldChangeCharactersInRange:range replacementString:@"4242424242424242"];
    range.length = expiryField.text.length;
    [expiryField.delegate textField:expiryField shouldChangeCharactersInRange:range replacementString:@"1014"];
    range.length = cvcField.text.length;
    [cvcField.delegate textField:cvcField shouldChangeCharactersInRange:range replacementString:@"678"];
    [cvcField resignFirstResponder];
    // Call the validation routine
    [self stripeView:self.stripeCreditCardView withCard:self.stripeCreditCardView.paymentView.card isValid:self.stripeCreditCardView.paymentView.isValid];
}

- (IBAction)resetCard:(id)sender {
    // Ensure there is no credit card data, before we start
    PKTextField *numberField = self.stripeCreditCardView.paymentView.cardNumberField;
    PKTextField *expiryField = self.stripeCreditCardView.paymentView.cardExpiryField;
    PKTextField *cvcField = self.stripeCreditCardView.paymentView.cardCVCField;
    NSRange range;
    range.location = 0;
    range.length = cvcField.text.length;
    [cvcField.delegate textField:cvcField shouldChangeCharactersInRange:range replacementString:@""];
    range.length = expiryField.text.length;
    [expiryField.delegate textField:expiryField shouldChangeCharactersInRange:range replacementString:@""];
    range.length = numberField.text.length;
    [numberField.delegate textField:numberField shouldChangeCharactersInRange:range replacementString:@""];
    [numberField resignFirstResponder];
}


@end
