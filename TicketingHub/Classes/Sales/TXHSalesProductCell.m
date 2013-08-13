//
//  TXHSalesProductCell.m
//  TicketingHub
//
//  Created by Mark on 12/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesProductCell.h"

#import "TXHQuantitySelectorViewController.h"

@interface TXHSalesProductCell () <TXHQuantitySelectorDelegate>

@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLabel;
@property (weak, nonatomic) IBOutlet UITextView *productDescriptionTextView;
@property (weak, nonatomic) IBOutlet UIButton *quantityButton;

// A popover controller allowing upgrade quantity to be selected
@property (strong, nonatomic) UIPopoverController *selectQuantityPopover;

@end

@implementation TXHSalesProductCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.quantityButton.backgroundColor = [UIColor colorWithPatternImage:[[UIImage imageNamed:@"Counter"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSString *)productName {
    return self.productNameLabel.text;
}

- (void)setProductName:(NSString *)productName {
    self.productNameLabel.text = productName;
}

- (NSString *)productDescription {
    return self.productDescriptionTextView.text;
}

- (void)setProductDescription:(NSString *)productDescription {
    self.productDescriptionTextView.text = productDescription;
}

- (void)setPrice:(NSNumber *)price {
    _price = price;
    if (price.doubleValue == 0.0f) {
        self.productPriceLabel.text = @"Free";
    } else {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        // TODO: Currency ultimately comes from the venue for which the order is placed
        formatter.currencyCode = @"GBP";
        formatter.numberStyle = kCFNumberFormatterCurrencyStyle;
        self.productPriceLabel.text = [formatter stringFromNumber:price];
    }
}

- (void)setQuantity:(NSNumber *)quantity {
    _quantity = quantity;
    NSString *quantityString = [NSString stringWithFormat:@"%d  ", quantity.integerValue];
    [self.quantityButton setTitle:quantityString forState:UIControlStateNormal];
}

- (IBAction)changeQuantity:(id)sender {
    if (self.selectQuantityPopover.isPopoverVisible) {
        [self.selectQuantityPopover dismissPopoverAnimated:YES];
    }
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Salesman" bundle:nil];
    TXHQuantitySelectorViewController *quantityController = [storyboard instantiateViewControllerWithIdentifier:@"TXHQuantitySelectorViewController"];
    quantityController.currentQuantitySelected = self.quantity.unsignedIntegerValue;
    quantityController.maximumQuantityAllowed = self.quantity.unsignedIntegerValue + 5;
    quantityController.delegate = self;
    self.selectQuantityPopover = [[UIPopoverController alloc] initWithContentViewController:quantityController];
    self.selectQuantityPopover.popoverContentSize = CGSizeMake(210.0f, (quantityController.maximumQuantityAllowed * 44.0f));
    [self.selectQuantityPopover presentPopoverFromRect:self.quantityButton.frame inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

#pragma mark - Popover delegate method

- (void)quantitySelectorViewController:(TXHQuantitySelectorViewController *)controller didSelectQuantity:(NSUInteger)quantity {
    self.quantity = [NSNumber numberWithUnsignedInteger:quantity];
    [self setNeedsDisplay];
    [self.selectQuantityPopover dismissPopoverAnimated:YES];
    [[UIApplication sharedApplication] sendAction:@selector(changeUpdateQuantity:) to:nil from:self forEvent:nil];
}
@end
