//
//  TXHBorderedButton.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 15/02/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHBorderedButton.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+Additions.h"

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

- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor  = borderColor;
    self.layer.borderColor = borderColor.CGColor;
}

- (void)setNormalFillColor:(UIColor *)normalFillColor
{
    _normalFillColor = normalFillColor;
    [self updateColors];
}

- (void)setHighlightedFillColor:(UIColor *)highlightedFillColor
{
    _highlightedFillColor = highlightedFillColor;
    [self updateColors];
}

- (void)setNormalTextColor:(UIColor *)normalTextColor
{
    _normalTextColor = normalTextColor;
    [self setTitleColor:normalTextColor forState:UIControlStateNormal];
    [self updateColors];
}

- (void)setHighlightedTextColor:(UIColor *)highlightedTextColor
{
    _highlightedTextColor = highlightedTextColor;
    [self setTitleColor:highlightedTextColor forState:UIControlStateHighlighted];
    [self updateColors];
}

- (void)updateColors
{
    self.backgroundColor     = self.highlighted ? self.highlightedFillColor : self.normalFillColor;
    self.imageView.tintColor = self.highlighted ? self.highlightedTextColor : self.normalTextColor;
}

#define INSET 15

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.right = self.width - self.contentEdgeInsets.right;
    
    //something moves it right...
    if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentLeft)
        self.titleLabel.left = self.contentEdgeInsets.left;
}

@end
