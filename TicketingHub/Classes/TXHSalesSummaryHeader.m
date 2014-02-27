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

@property (strong, nonatomic) UIImage *expandImage;
@property (strong, nonatomic) UIImage *collapseImage;

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

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    // Create images for expanded and collapsed modes
    self.expandImage = [[UIImage imageNamed:@"Expand"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.collapseImage = [[UIImage imageNamed:@"Collapse"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    // Assign the collapsed mode at startup
    self.expandedCollapsedImageView.image = self.collapseImage;
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

- (void)setExpanded:(BOOL)expanded {
    _expanded = expanded;
    self.expandedCollapsedImageView.image = expanded ? self.collapseImage : self.expandImage;
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
