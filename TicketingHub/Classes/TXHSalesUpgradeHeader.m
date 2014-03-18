//
//  TXHSalesUpgradeHeader.m
//  TicketingHub
//
//  Created by Mark on 12/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesUpgradeHeader.h"

@interface TXHSalesUpgradeHeader ()

@property (weak, nonatomic) IBOutlet UILabel *headerTitle;
@property (weak, nonatomic) IBOutlet UIImageView *expandedCollapsedImageView;

@end

@implementation TXHSalesUpgradeHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
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
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleMode:)];
    [self addGestureRecognizer:tapGesture];
}

- (NSAttributedString *)ticketTitle {
    return self.headerTitle.attributedText;
}

-(void)setTicketTitle:(NSString *)ticketTitle
{
    self.headerTitle.text = ticketTitle;
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

- (void)toggleMode:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded)
    {
        self.expanded = !self.expanded;
        [self.delegate txhSalesUpgradeHeaderIsExpandedDidChange:self];
    }
}

@end
