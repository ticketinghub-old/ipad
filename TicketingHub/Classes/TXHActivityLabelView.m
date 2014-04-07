//
//  TXHActivityLabelView.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 28/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHActivityLabelView.h"

@interface TXHActivityLabelView ()

@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *indicator;
@property (nonatomic, weak) IBOutlet UILabel *label;

@end

@implementation TXHActivityLabelView

+ (instancetype)getInstance
{
    NSArray *content = [[NSBundle mainBundle] loadNibNamed:@"TXHActivityLabelView" owner:nil options:nil];
    TXHActivityLabelView *view = [content firstObject];
    return view;
}

- (void)showWithText:(NSString *)text activityIndicatorHidden:(BOOL)hidden
{
    self.label.text = text;
    
    if (hidden)
        [self.indicator stopAnimating];
    else
        [self.indicator startAnimating];
    
    [UIView animateWithDuration:0.3
                          delay:0.0
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

@end
