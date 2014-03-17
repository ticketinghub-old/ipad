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

@property (strong, nonatomic) UIImage *expandImage;
@property (strong, nonatomic) UIImage *collapseImage;

@end

@implementation TXHDoorTicketsAttendedHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.ticketCountLabel.layer.cornerRadius = self.ticketCountLabel.height / 2.0;
    
    self.expandImage = [[UIImage imageNamed:@"Expand"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.collapseImage = [[UIImage imageNamed:@"Collapse"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    // add a gesture recogniser to handle toggling between expanded & collapsed
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleMode:)];
    [self addGestureRecognizer:tapGesture];
}

- (void)setAttendedCount:(NSNumber *)count
{
    self.attendedLabel.text = [NSString stringWithFormat:@"%d Attended", [count integerValue]];
}

- (void)setTotalCount:(NSNumber *)count
{
    self.ticketCountLabel.text = [NSString stringWithFormat:@"  %d  ",[count integerValue]];
}

- (void)setExpanded:(BOOL)expanded {
    _expanded = expanded;
    self.arrowImage.image = expanded ? self.collapseImage : self.expandImage;
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
