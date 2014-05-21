//
//  TXHSalesWizardTabelViewCell.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 17/02/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHSalesWizardTabelViewCell.h"
#import "UIColor+TicketingHub.h"
#import <QuartzCore/QuartzCore.h>

@interface TXHSalesWizardTabelViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *checmarkImageView;
@property (weak, nonatomic) IBOutlet UIView *circleView;
@property (assign, nonatomic, getter = isCurrent) BOOL current;

@end

@implementation TXHSalesWizardTabelViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self updateView];
}

- (void)setTite:(NSString *)title
{
    self.titleLabel.text = title;
}

- (void)setDetails:(NSString *)details
{
    self.detailsLabel.text = details;
}

- (void)setNumber:(NSUInteger)number
{
    self.numberLabel.text = [[NSNumber numberWithInteger:number] stringValue];
}

- (void)setIsCurrent:(BOOL)current
{
    self.current = current;
    [UIView animateWithDuration:0.2
                     animations:^{
                         [self updateView];
                     }];
}

- (void)updateView
{
    self.circleView.layer.borderColor = self.current ? [UIColor txhBlueColor].CGColor : [UIColor lightGrayColor].CGColor;
    self.circleView.backgroundColor   = self.current ? [UIColor txhBlueColor] : self.contentView.backgroundColor;
    self.numberLabel.textColor        = self.current ? [UIColor whiteColor]   : self.titleLabel.textColor;
    
    self.circleView.layer.cornerRadius = self.circleView.width * 0.5;
    self.circleView.layer.borderWidth = 1.5;

}

- (void)setCompleted:(BOOL)completed
{
    self.checmarkImageView.hidden = !completed;
}

@end
