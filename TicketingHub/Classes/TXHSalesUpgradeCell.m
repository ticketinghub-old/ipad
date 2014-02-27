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

@property (weak, nonatomic) IBOutlet UIView *emptyCircleView;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;

@end

@implementation TXHSalesUpgradeCell

- (void)awakeFromNib
{
    [super awakeFromNib];

    [self setup];
    
}

- (void)setup
{
    [self setupEmptyCircle];
}

- (void)setupEmptyCircle
{
    self.emptyCircleView.layer.cornerRadius = self.emptyCircleView.width * 0.5;
    self.emptyCircleView.layer.borderWidth = 1.5;
    self.emptyCircleView.layer.borderColor = [UIColor lightGrayColor].CGColor;
}


#pragma mark accessors

- (NSString *)upgradeDescription
{
    return self.upgradeDescriptionTextView.text;
}


- (void)setUpgradeDescription:(NSString *)upgradeDescription
{
    self.upgradeDescriptionTextView.selectable = YES;
    self.upgradeDescriptionTextView.text = upgradeDescription;
    self.upgradeDescriptionTextView.selectable = NO;
}


- (NSString *)upgradeName
{
    return self.upgradeNameLabel.text;
}


- (void)setUpgradeName:(NSString *)upgradeName
{
    self.upgradeNameLabel.text = upgradeName;
}


- (NSString *)upgradePrice
{
    return self.upgradePriceLabel.text;
}


- (void)setUpgradePrice:(NSString *)upgradePrice
{
    self.upgradePriceLabel.text = upgradePrice;
}


- (void)setChosen:(BOOL)chosen
{
    chosen = chosen;
    self.selectedImageView.alpha = chosen ? 1.0 : 0.0;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.upgradeDescriptionTextView.text = @"";
    self.upgradeNameLabel.text           = @"";
    self.upgradePriceLabel.text          = @"";
    self.chosen                          = NO;
}

@end
