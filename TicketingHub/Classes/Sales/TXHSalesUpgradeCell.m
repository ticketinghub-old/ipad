//
//  TXHSalesUpgradeCell.m
//  TicketingHub
//
//  Created by Mark on 12/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesUpgradeCell.h"

@interface TXHSalesUpgradeCell ()

@property (weak, nonatomic) IBOutlet UILabel *upgradeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *upgradePriceLabel;
@property (weak, nonatomic) IBOutlet UITextView *upgradeDescriptionTextView;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;

@property (strong, nonatomic) UIImage *selectedImage;
@property (strong, nonatomic) UIImage *unselectedImage;

@end

@implementation TXHSalesUpgradeCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
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
    self.selectedImage = [UIImage imageNamed:@"Completed"];
    self.unselectedImage = [[UIImage imageNamed:@"EmptyCircle"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.selectedImageView.image = self.unselectedImage;

    // add a gesture recogniser to handle toggling between selected & unselected
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleSelected:)];
    [self addGestureRecognizer:tapGesture];
}

- (NSString *)upgradeDescription {
    return self.upgradeDescriptionTextView.text;
}

- (void)setUpgradeDescription:(NSString *)upgradeDescription {
    self.upgradeDescriptionTextView.text = upgradeDescription;
}

- (NSString *)upgradeName {
    return self.upgradeNameLabel.text;
}

- (void)setUpgradeName:(NSString *)upgradeName {
    self.upgradeNameLabel.text = upgradeName;
}

- (void)setUpgradePrice:(NSNumber *)upgradePrice {
    _upgradePrice = upgradePrice;
    if (upgradePrice.doubleValue == 0.0f) {
        self.upgradePriceLabel.text = @"Free";
    } else {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        // TODO: Currency ultimately comes from the venue for which the order is placed
        formatter.currencyCode = @"GBP";
        formatter.numberStyle = kCFNumberFormatterCurrencyStyle;
        self.upgradePriceLabel.text = [formatter stringFromNumber:upgradePrice];
    }
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    self.selectedImageView.image = isSelected ? self.selectedImage : self.unselectedImage;
}

- (void)prepareForReuse {
    self.upgradeDescriptionTextView.text = @"";
    self.upgradeNameLabel.text = @"";
    self.upgradePriceLabel.text = @"";
    self.selectedImageView.image = self.unselectedImage;
}

- (void)toggleSelected:(UITapGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateEnded) {
        self.isSelected = !self.isSelected;
    }
}

@end
