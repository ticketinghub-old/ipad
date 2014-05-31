//
//  TXHSalesTicketTierCell.m
//  TicketingHub
//
//  Created by Mark on 31/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesTicketTierCell.h"
#import "UIResponder+FirstResponder.h"
#import "UIColor+TicketingHub.h"

#import <QuartzCore/QuartzCore.h>
#import "TXHProductsManager.h"

@interface TXHSalesTicketTierCell () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel     *tierName;
@property (weak, nonatomic) IBOutlet UILabel     *tierDescription;
@property (weak, nonatomic) IBOutlet UILabel     *price;
@property (weak, nonatomic) IBOutlet UITextField *quantity;
@property (weak, nonatomic) IBOutlet UIButton    *decreaseButton;
@property (weak, nonatomic) IBOutlet UIButton    *increaseButton;

@end

@implementation TXHSalesTicketTierCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.quantity.delegate              = self;
    self.quantity.keyboardType          = UIKeyboardTypeNumberPad;
    self.contentView.clipsToBounds      = YES;
    self.contentView.layer.cornerRadius = 30;
    self.contentView.backgroundColor    = [UIColor whiteColor];
    self.layer.masksToBounds            = NO;
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
    NSInteger maxValue = [self.delegate maximumQuantityForCell:self];

    NSUInteger quantity = selectedQuantity;
    quantity = quantity > maxValue ? maxValue : quantity;

    self.increaseButton.enabled = selectedQuantity < maxValue;
    self.decreaseButton.enabled = selectedQuantity > 0;
    
    _selectedQuantity  = quantity;
    self.quantity.text = [NSString stringWithFormat:@"%ld",(long)quantity];
    
    CGFloat alpha = self.selectedQuantity > 0 ? 0.8 : 0.1;
    self.layer.borderColor = [[UIColor txhBlueColor] colorWithAlphaComponent:alpha].CGColor;
    self.contentView.layer.borderWidth  = self.selectedQuantity > 0 ? 2 : 1;

    
    [self quantityDidChange];
}

- (void)quantityDidChange
{
    if (self.quantityChangedHandler)
        self.quantityChangedHandler(self.tierIdentifier ? @{self.tierIdentifier : [NSNumber numberWithInteger:self.quantity.text.integerValue]} : nil);
}

#pragma mark - Quantity Value Changed action

- (IBAction)quantityChanged:(id)sender
{
    self.selectedQuantity = [self.quantity.text integerValue];
}

#pragma mark - Stepper Value Changed action

- (IBAction)increaseButtonAction:(id)sender
{
    self.selectedQuantity++;
    [[UIResponder currentFirstResponder] resignFirstResponder];
}

- (IBAction)decreaseButtonAction:(id)sender
{
    self.selectedQuantity--;
    [[UIResponder currentFirstResponder] resignFirstResponder];
}

@end
