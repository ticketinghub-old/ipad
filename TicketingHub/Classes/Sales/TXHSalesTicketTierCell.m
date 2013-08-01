//
//  TXHSalesTicketTierCell.m
//  TicketingHub
//
//  Created by Mark on 31/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesTicketTierCell.h"

#import "TXHServerAccessManager.h"
#import "TXHTicketTier.h"

@interface TXHSalesTicketTierCell ()

@property (weak, nonatomic) IBOutlet UILabel *tierName;
@property (weak, nonatomic) IBOutlet UITextView *tierDescription;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UITextField *quantity;
@property (weak, nonatomic) IBOutlet UIStepper *stepper;

@end

@implementation TXHSalesTicketTierCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTier:(TXHTicketTier *)tier {
    _tier = tier;
    [self configureTierDetails];
    [self layoutIfNeeded];
}

- (void)configureTierDetails {
    self.tierName.text = self.tier.tierName;
    self.tierDescription.text = self.tier.tierDescription;
    // Currency is specified by the venue
    self.price.text = [[TXHServerAccessManager sharedInstance] formatCurrencyValue:self.tier.price];
    self.stepper.maximumValue = self.tier.limit.doubleValue;
}

- (void)quantityDidChange {
    if (self.quantityChangedHandler) {
        self.quantityChangedHandler(@{self.tier.tierID: [NSNumber numberWithInteger:self.quantity.text.integerValue]});
    }
}

#pragma mark - Quantity Value Changed action

- (IBAction)quantityChanged:(id)sender {
#pragma unused (sender)
    // Validate the quantity entered & update the stepper to reflect this new quantity
    NSUInteger oldQuantity = [self.quantity.text integerValue];
    NSUInteger quantity = oldQuantity;
    if (quantity < self.stepper.minimumValue) {
        quantity = self.stepper.minimumValue;
    }
    if (quantity > self.stepper.maximumValue) {
        quantity = self.stepper.maximumValue;
    }
    self.stepper.value = quantity;
    if (quantity != oldQuantity) {
        self.quantity.text = [NSString stringWithFormat:@"%d", quantity];
        [self quantityDidChange];
    }
}


#pragma mark - Stepper Value Changed action

- (IBAction)stepChanged:(id)sender {
    UIStepper *stepper = sender;
    self.quantity.text = [NSString stringWithFormat:@"%.0f", stepper.value];
    [self quantityDidChange];
}

@end
