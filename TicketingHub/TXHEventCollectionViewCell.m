//
//  TXHEventCollectionViewCell.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 26/05/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHEventCollectionViewCell.h"
#import "UIColor+TicketingHub.h"
#import <QuartzCore/QuartzCore.h>

@interface TXHEventCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *middleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

@end

@implementation TXHEventCollectionViewCell


- (void)setTimeString:(NSString *)text
{
    self.leftLabel.text = text;
}

- (void)setSpacesString:(NSString *)text
{
    self.middleLabel.text = text;
}

- (void)setPriceString:(NSString *)text
{
    self.rightLabel.text = text;
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
    self.layer.borderWidth = (self.selected || self.highlighted) ? 3.0 : 0.0;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.layer.cornerRadius = 10.0;
    self.layer.borderColor = [[UIColor txhBlueColor] colorWithAlphaComponent:0.8].CGColor;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    [self setTimeString:nil];
    [self setSpacesString:nil];
    [self setPriceString:nil];
}


@end
