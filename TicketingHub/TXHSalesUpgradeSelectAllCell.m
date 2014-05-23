//
//  TXHSalesUpgradeSelectAllCell.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 22/05/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHSalesUpgradeSelectAllCell.h"
#import "UIColor+TicketingHub.h"
#import <QuartzCore/QuartzCore.h>

@interface TXHSalesUpgradeSelectAllCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation TXHSalesUpgradeSelectAllCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.layer.cornerRadius = 20.0;
}


- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    [self updateView];
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    [self updateView];
}


- (void)updateView
{
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.contentView.backgroundColor = [self contentViewBackgroundColor];
                         self.titleLabel.textColor        = [self titleLabelTextColor];
                         
                     }];
    self.titleLabel.text = [self titleLabelText];
    
}

- (UIColor *)contentViewBackgroundColor
{
    return (self.highlighted || self.selected) ? [UIColor txhBlueColor] : [UIColor txhVeryLightBlueColor];
}

- (UIColor *)titleLabelTextColor
{
    return (self.highlighted || self.selected) ? [UIColor txhVeryLightBlueColor] : [UIColor txhDarkBlueColor];
}

- (NSString *)titleLabelText
{
     return self.selected ? NSLocalizedString(@"SALESMAN_UPGRADES_DESELECT_ALL_TITLE", nil) : NSLocalizedString(@"SALESMAN_UPGRADES_SELECT_ALL_TITLE", nil);
}

@end
