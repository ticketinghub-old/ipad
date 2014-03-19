//
//  TXHDoorTicketsAttendedHeaderView.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 14/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHDoorTicketsAttendedHeaderView.h"
#import <QuartzCore/QuartzCore.h>

@interface TXHDoorTicketsAttendedHeaderView ()

@end

@implementation TXHDoorTicketsAttendedHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.ticketCountLabel.layer.cornerRadius = self.ticketCountLabel.height / 2.0;
    // add a gesture recogniser to handle toggling between expanded & collapsed
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleMode:)];
    [self addGestureRecognizer:tapGesture];
}

- (void)setAttendedCount:(NSNumber *)count
{
    self.attendedLabel.text = [NSString stringWithFormat:@"%d Attending", [count integerValue]];
}

- (void)setTotalCount:(NSNumber *)count
{
    self.ticketCountLabel.text = [NSString stringWithFormat:@"  %d  ",[count integerValue]];
}

- (void)setExpanded:(BOOL)expanded {
    _expanded = expanded;
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.arrowImage.transform = CGAffineTransformMakeRotation(expanded ? M_PI : 0);
                     }
                     completion:nil];

}

- (void)toggleMode:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded)
    {
        self.expanded = !self.expanded;
        [self.delegate txhDoorTicketsAttendedHeaderViewDelegateIsExpandedDidChange:self];
    }
}

@end
