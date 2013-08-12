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

@property (strong, nonatomic) UIImage *expandedImage;
@property (strong, nonatomic) UIImage *collapsedImage;

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

- (void)setup {
    // Create images for expanded and collapsed modes
    self.expandedImage = [[UIImage imageNamed:@"Expanded"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.collapsedImage = [[UIImage imageNamed:@"Collapsed"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    // Assign the collapsed mode at startup
    self.expandedCollapsedImageView.image = self.collapsedImage;
    self.expandedCollapsedImageView.tintColor = [UIColor colorWithRed:77.0f / 255.0f
                                                                green:134.0f / 255.0f
                                                                 blue:180.0f / 255.0f
                                                                alpha:1.0f];
    
    // add a gesture recogniser to handle toggling between expanded & collapsed
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleMode:)];
    [self addGestureRecognizer:tapGesture];
}

- (NSAttributedString *)ticketTitle {
    return self.headerTitle.attributedText;
}

-(void)setTicketTitle:(NSAttributedString *)ticketTitle {
    NSAttributedString *title = ticketTitle;
    CGSize size = [title size];
    CGRect bounds = self.headerTitle.bounds;
    bounds.size = size;
    self.headerTitle.bounds = bounds;
    self.headerTitle.attributedText = ticketTitle;
    [self layoutIfNeeded];
}

- (void)setIsExpanded:(BOOL)isExpanded {
    _isExpanded = isExpanded;
    self.expandedCollapsedImageView.image = isExpanded ? self.expandedImage : self.collapsedImage;
}

- (void)toggleMode:(UITapGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateEnded) {
        self.isExpanded = !self.isExpanded;
        [[UIApplication sharedApplication] sendAction:@selector(toggleSection:) to:nil from:self forEvent:nil];
    }
}

@end
