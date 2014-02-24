//
//  TXHSalesWizardTabelViewCell.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 17/02/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHSalesWizardTabelViewCell.h"
#import <QuartzCore/QuartzCore.h>

@interface TXHSalesWizardTabelViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *checmarkImageView;
@property (weak, nonatomic) IBOutlet UIView *circleView;

@end

@implementation TXHSalesWizardTabelViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.circleView.layer.cornerRadius = self.circleView.width * 0.5;
    self.circleView.layer.borderWidth = 1.5;
    self.circleView.layer.borderColor = [UIColor lightGrayColor].CGColor;
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

- (void)setCompleted:(BOOL)completed
{
    self.checmarkImageView.hidden = !completed;
}

@end
