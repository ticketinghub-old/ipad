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
    UIColor *backgroundColor = self.isHighlighted ? self.tintColor : self.fillColor;
    UIColor *textColor       = self.isHighlighted ? self.fillColor : self.tintColor;
    
    self.backgroundColor                 = backgroundColor;
    self.titleLabel.textColor            = textColor;
    self.layer.borderColor               = textColor.CGColor;
}

@end
