
//
//  TXHSalesInformationHeader.m
//  TicketingHub
//
//  Created by Mark on 08/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesInformationHeader.h"

@interface TXHSalesInformationHeader ()

@property (weak, nonatomic) IBOutlet UILabel *headerTitle;
@property (weak, nonatomic) IBOutlet UILabel *headerSubtitle;
@property (weak, nonatomic) IBOutlet UIImageView *expandedCollapsedImageView;

@property (strong, nonatomic) UIImage *expandImage;
@property (strong, nonatomic) UIImage *collapseImage;

@property (weak, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;

@end

@implementation TXHSalesInformationHeader

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (void)setup
{
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
    self.tapGestureRecognizer = tapGesture;
}

- (void)setTierTitle:(NSString *)tierTitle
{
    self.headerTitle.text = tierTitle;
}

- (void)setSubTitle:(NSString *)subTitle
{
    self.headerSubtitle.text = subTitle;
}

- (void)setExpanded:(BOOL)expanded
{
    _expanded = expanded;
    self.expandedCollapsedImageView.image = expanded ? self.collapseImage : self.expandImage;
}

- (void)setExpandable:(BOOL)expandable
{
    _expandable = expandable;
    self.tapGestureRecognizer.enabled = expandable;
    self.expandedCollapsedImageView.hidden = !expandable;
}

- (void)toggleMode:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded)
    {
        self.expanded = !self.expanded;
        [self.delegate txhSalesInformationHeaderIsExpandedDidChange:self];
    }
}
@end
