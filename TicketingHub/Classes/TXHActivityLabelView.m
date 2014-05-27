//
//  TXHActivityLabelView.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 28/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHActivityLabelView.h"
#import "UIFont+TicketingHub.h"

@interface TXHActivityLabelView ()

@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *indicator;
@property (nonatomic, weak) IBOutlet UILabel *label;

@end

@implementation TXHActivityLabelView

+ (instancetype)getInstanceFromNibNamed:(NSString *)nibName
{
    NSArray *content = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
    TXHActivityLabelView *view = [content firstObject];
    return view;
}

+ (instancetype)getInstanceInView:(UIView *)targetView
{
    TXHActivityLabelView *activityView = [self getInstanceFromNibNamed:@"TXHActivityLabelView"];
    [activityView hide];

    if (targetView)
    {
        activityView.frame = targetView.bounds;
        activityView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        activityView.translatesAutoresizingMaskIntoConstraints = YES;
        activityView.label.font = [UIFont txhThinFontWithSize:23.0f];
        [targetView addSubview:activityView];
    }
    return activityView;
}

- (void)showWithMessage:(NSString *)text indicatorHidden:(BOOL)hidden
{
    self.label.text = text;
    
    if (hidden)
        [self.indicator stopAnimating];
    else
        [self.indicator startAnimating];
    
    [UIView animateWithDuration:0.3
                          delay:0.2
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.alpha = 1.0;
                     }
                     completion:nil];
}

- (void)hide
{
    [self.indicator stopAnimating];
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.alpha = 0.0;
                     }
                     completion:nil];
}

- (void)setMessagColor:(UIColor *)color
{
    self.label.textColor = color;
}

- (void)setMessagFont:(UIFont *)font
{
    self.label.font = font;
}

@end
