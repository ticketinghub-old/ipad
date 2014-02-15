//
//  TXHProductListCell.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 15/02/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHProductListCell.h"

@implementation TXHProductListCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setupAccessoryView];
}

- (void)setupAccessoryView
{
    UIImage *accessoryImage = [UIImage imageNamed:@"right-arrow"];
    accessoryImage          = [accessoryImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.accessoryView      = [[UIImageView alloc] initWithImage:accessoryImage];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    [self updateColors];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    [self updateColors];
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = [textColor copy];
    
    [self updateColors];
}

-(void)setBgColor:(UIColor *)bgColor
{
    _bgColor = [bgColor copy];
    
    [self updateColors];
}

- (void)updateColors
{
    BOOL isHighlightedOrSelected = self.highlighted || self.selected;
    
    UIColor *textColor = isHighlightedOrSelected ? self.bgColor : self.textColor;
    
    self.tintColor           = textColor;
    self.textLabel.textColor = textColor;
    
    UIColor *bgColor = isHighlightedOrSelected ? self.textColor : self.bgColor;
    
    self.backgroundColor             = bgColor;
    self.contentView.backgroundColor = bgColor;
    self.textLabel.backgroundColor   = bgColor;
}

@end
