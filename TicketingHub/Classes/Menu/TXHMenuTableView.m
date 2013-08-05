//
//  TXHMenuTableView.m
//  TicketingHub
//
//  Created by Mark on 05/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHMenuTableView.h"

@interface TXHMenuTableView ()

@property (strong, nonatomic) UIView *topStretcher;
@property (strong, nonatomic) UIImageView *topStretcherShadow;

@property (strong, nonatomic) UIView *bottomStretcher;
@property (strong, nonatomic) UIImageView *bottomStretcherShadow;

@property (strong, nonatomic) UIImage *shadow;

@end

@implementation TXHMenuTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setTopColor:(UIColor *)topColor {
    if (self.topStretcher == nil) {
        self.topStretcher = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.topStretcher];
        // Add a shadow on the right hand side
        if (self.shadow == nil) {
            self.shadow = [[UIImage imageNamed:@"shadow"] resizableImageWithCapInsets:UIEdgeInsetsMake(1.0f, 0.0f, 0.0f, 0.0f) resizingMode:UIImageResizingModeStretch];
        }
        self.topStretcherShadow = [[UIImageView alloc] initWithImage:self.shadow];
        [self.topStretcher addSubview:self.topStretcherShadow];
    }
    
    if (self.topStretcher.backgroundColor != topColor) {
        self.topStretcher.backgroundColor = topColor;
    }
}

- (void)setBottomColor:(UIColor *)bottomColor {
    if (self.bottomStretcher == nil) {
        self.bottomStretcher = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.bottomStretcher];
        // Add a shadow on the right hand side
        if (self.shadow == nil) {
            self.shadow = [[UIImage imageNamed:@"shadow"] resizableImageWithCapInsets:UIEdgeInsetsMake(1.0f, 0.0f, 0.0f, 0.0f) resizingMode:UIImageResizingModeStretch];
        }
        self.bottomStretcherShadow = [[UIImageView alloc] initWithImage:self.shadow];
        [self.bottomStretcher addSubview:self.bottomStretcherShadow];
    }
    
    if (self.bottomStretcher.backgroundColor != bottomColor) {
        self.bottomStretcher.backgroundColor = bottomColor;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.topStretcher) {
        if (self.contentOffset.y > 0) {
            self.topStretcher.hidden = YES;
        } else {
            CGRect frame = CGRectMake(0.0f, self.contentOffset.y, self.frame.size.width, -self.contentOffset.y);
            self.topStretcher.frame = frame;
            // Size the shadow
            frame.size.width = self.topStretcherShadow.bounds.size.width;
            frame.origin.x = self.frame.size.width - frame.size.width;
            frame.origin.y = 0.0f;
            self.topStretcherShadow.frame = frame;
            self.topStretcher.hidden = NO;
        }
    }
    
    CGFloat contentBottom = (self.contentSize.height - self.contentOffset.y);
    CGFloat bottomGap = self.frame.size.height - contentBottom;
    
    if (bottomGap > 0 && self.bottomStretcher) {
        CGRect frame = CGRectMake(0.0f, self.contentSize.height, self.frame.size.width, bottomGap);
        self.bottomStretcher.frame = frame;
        // Size the shadow
        frame.size.width = self.bottomStretcherShadow.bounds.size.width;
        frame.origin.x = self.frame.size.width - frame.size.width;
        frame.origin.y = 0.0f;
        self.bottomStretcherShadow.frame = frame;
        self.bottomStretcher.hidden = NO;
    } else {
        self.bottomStretcher.hidden = YES;
    }
}

@end
