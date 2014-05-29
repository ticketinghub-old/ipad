//
//  TXHOrderCell.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 28/05/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHOrderCell.h"
#import "UIColor+TicketingHub.h"

@interface TXHOrderCell ()

@property (weak, nonatomic) IBOutlet UILabel *orderReferenceLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *atendeessLabel;
@property (weak, nonatomic) IBOutlet UILabel *attendingLabel;
@property (weak, nonatomic) IBOutlet UIView *separatorView;
@property (weak, nonatomic) IBOutlet UIImageView *chevronVIew;

@property (strong, nonatomic) UIColor *orderReferenceLabelColor;
@property (strong, nonatomic) UIColor *priceLabelColor;
@property (strong, nonatomic) UIColor *atendeessLabelColor;
@property (strong, nonatomic) UIColor *attendingLabelColor;

@property (strong, nonatomic) UIColor *selectedTextColor;

@end

@implementation TXHOrderCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (!(self = [super initWithCoder:aDecoder]))
        return nil;
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.orderReferenceLabelColor = self.orderReferenceLabel.textColor;
    self.priceLabelColor          = self.priceLabel.textColor;
    self.attendingLabelColor      = self.attendingLabel.textColor;
    self.atendeessLabelColor      = self.atendeessLabel.textColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    [self updateViewAniamted:animated];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
 
    [self updateViewAniamted:animated];
}

- (void)updateViewAniamted:(BOOL)animated
{
    void (^actionblock)(void) = ^{
        BOOL higlight = self.highlighted || self.selected;
        
        self.contentView.backgroundColor = higlight ? [UIColor txhBlueColor] : [UIColor whiteColor];
        
        self.separatorView.hidden = higlight;
        self.chevronVIew.hidden   = higlight;
        
        self.orderReferenceLabel.textColor = higlight ? self.selectedTextColor : self.orderReferenceLabelColor;
        self.priceLabel.textColor          = higlight ? self.selectedTextColor : self.priceLabelColor;
        self.atendeessLabel.textColor      = higlight ? self.selectedTextColor : self.atendeessLabelColor;
        self.attendingLabel.textColor      = higlight ? self.selectedTextColor : self.attendingLabelColor;
    };
    
    if (animated)
        [UIView animateWithDuration:0.2
                              delay:0.0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:actionblock
                         completion:nil];
    else if (actionblock)
        actionblock();
        
}

- (void)setOrderReference:(NSString *)reference
{
    self.orderReferenceLabel.text = reference;
}

- (void)setPrice:(NSString *)string
{
    self.priceLabel.text = string;
}

- (void)setGuestCount:(NSInteger)guestCount
{
    self.atendeessLabel.text = [NSString stringWithFormat:NSLocalizedString(@"DOORMAN_TICKETS_LIST_ATTENDEES_FORMAT",nil),guestCount];
}

- (void)setAttendingCount:(NSInteger)attendingCount
{
    self.attendingLabel.text = [NSString stringWithFormat:NSLocalizedString(@"DOORMAN_TICKETS_LIST_ATTENDING_FORMAT",nil),attendingCount];

}


@end
