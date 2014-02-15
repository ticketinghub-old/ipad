//
//  TXHBorderedButton.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 15/02/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHBorderedButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation TXHBorderedButton

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self updateColors];
}

#pragma mark - Custom setters

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    [self updateColors];
}

- (void)setFillColor:(UIColor *)fillColor
{
    _fillColor = [fillColor copy];
    [self updateColors];
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    self.layer.borderWidth = borderWidth;
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
}

- (void)setTintColor:(UIColor *)tintColor
{
    [super setTintColor:tintColor];
    [self updateColors];
}

- (void)updateColors
{
    self.backgroundColor                 = self.isHighlighted ? self.tintColor : self.fillColor;
    self.titleLabel.textColor            = self.tintColor;
    self.titleLabel.highlightedTextColor = self.fillColor;
    self.layer.borderColor               = self.isHighlighted ? self.fillColor.CGColor : self.tintColor.CGColor;
    self.titleLabel.highlighted          = self.isHighlighted;
}

@end
