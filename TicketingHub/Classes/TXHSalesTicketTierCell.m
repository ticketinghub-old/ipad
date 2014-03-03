//
//  TXHSalesTicketTierCell.m
//  TicketingHub
//
//  Created by Mark on 31/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesTicketTierCell.h"

#import "TXHProductsManager.h"

@interface TXHSalesTicketTierCell () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel     *tierName;
@property (weak, nonatomic) IBOutlet UITextView  *tierDescription;
@property (weak, nonatomic) IBOutlet UILabel     *price;
@property (weak, nonatomic) IBOutlet UITextField *quantity;
@property (weak, nonatomic) IBOutlet UIStepper   *stepper;

@end

@implementation TXHSalesTicketTierCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.quantity.delegate = self;
    self.quantity.keyboardType = UIKeyboardTypeNumberPad;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.tierName.text = title;
}

-(void)setSubtitle:(NSString *)subtitle
{
    _subtitle = subtitle;
    self.tierDescription.text = subtitle;
}

- (void)setPriceString:(NSString *)priceString
{
    _priceString    = priceString;
    self.price.text = priceString;
}

- (void)setSelectedQuantity:(NSInteger)selectedQuantity
{
    self.quantity.text = [NSString stringWithFormat:@"%d",selectedQuantity];
}


- (void)quantityDidChange
{
    if (self.quantityChangedHandler)
        self.quantityChangedHandler(@{self.tierIdentifier : [NSNumber numberWithInteger:self.quantity.text.integerValue]});
}

#pragma mark - Quantity Value Changed action
- (IBAction)quantityChanged:(id)sender
{
    NSInteger maxValue = [self.delegate maximumQuantityForCell:self];
    
    NSUInteger quantity = [self.quantity.text integerValue];
    quantity = quantity > maxValue ? maxValue : quantity;
    
    self.stepper.value = quantity;
    self.quantity.text = [NSString stringWithFormat:@"%d", quantity];

    [self quantityDidChange];
}

#pragma mark - Stepper Value Changed action

- (IBAction)stepChanged:(id)sender
{
    UIStepper *stepper = sender;
    [self.quantity setText:[NSString stringWithFormat:@"%.0f", stepper.value]];
    [self quantityChanged:sender];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (![textField.text length]) {
        self.selectedQuantity = 0;
    }
}

@end
