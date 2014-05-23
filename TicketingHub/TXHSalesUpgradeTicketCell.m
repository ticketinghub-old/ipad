//
//  TXHSalesUpgradeTicketCell.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 22/05/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHSalesUpgradeTicketCell.h"
#import "UIColor+TicketingHub.h"
#import <QuartzCore/QuartzCore.h>

@interface TXHSalesUpgradeTicketCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

@end

@implementation TXHSalesUpgradeTicketCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.contentView.layer.cornerRadius = 20.0;
    self.contentView.layer.borderWidth  = 3.0;
    
    [self updateView];
}

- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

- (void)setSubtitle:(NSString *)subtitle
{
    self.subtitleLabel.text = subtitle;
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
    self.contentView.layer.borderColor = [self borderColorRef];
}

- (CGColorRef)borderColorRef
{
    return (self.highlighted || self.selected) ? [UIColor txhBlueColor].CGColor : [UIColor txhVeryLightBlueColor].CGColor;
}

@end
