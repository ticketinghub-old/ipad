//
//  TXHSalesSummaryHeader.m
//  TicketingHub
//
//  Created by Mark on 13/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesSummaryHeader.h"

@interface TXHSalesSummaryHeader ()

@property (weak, nonatomic) IBOutlet UILabel *headerTitle;
@property (weak, nonatomic) IBOutlet UILabel *headerTotalPrice;
@property (weak, nonatomic) IBOutlet UIImageView *expandedCollapsedImageView;

@end

@implementation TXHSalesSummaryHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.expandedCollapsedImageView.tintColor = [UIColor colorWithRed:77.0f / 255.0f
                                                                green:134.0f / 255.0f
                                                                 blue:180.0f / 255.0f
                                                                alpha:1.0f];
    
    // add a gesture recogniser to handle toggling between expanded & collapsed
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleMode:)];
    [self addGestureRecognizer:tapGesture];
}

- (void)setTicketTitle:(NSString *)ticketTitle
{
    self.headerTitle.text = ticketTitle;
}

- (void)setTicketTotalPrice:(NSString *)ticketTotalPrice
{
    self.headerTotalPrice.text = ticketTotalPrice;
}

- (void)setExpanded:(BOOL)expanded
{
    _expanded = expanded;
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.expandedCollapsedImageView.transform = CGAffineTransformMakeRotation(expanded ? M_PI : 0);
                     }
                     completion:nil];
}

- (void)setCanExpand:(BOOL)canExpand
{
    _canExpand = canExpand;
    self.expandedCollapsedImageView.hidden = !canExpand;
}

- (void)toggleMode:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded)
    {
        self.expanded = !self.expanded;
        [self.delegate txhSalesSummaryHeaderIsExpandedDidChange:self];
    }
}

@end
