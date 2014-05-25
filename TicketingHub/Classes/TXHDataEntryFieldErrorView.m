//
//  TXHDataEntryFieldErrorView.m
//  TicketingHub
//
//  Created by Mark on 09/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHDataEntryFieldErrorView.h"

@import QuartzCore;

@interface TXHDataEntryFieldErrorView ()

@property (strong, nonatomic) UILabel *messageLabel;

@end

@implementation TXHDataEntryFieldErrorView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (void)setup
{
    self.messageLabel = [[UILabel alloc] initWithFrame:CGRectInset(self.bounds, 8.0f, 0.0f)];
    
    self.messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.messageLabel];
    
    [self setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    
    UILabel *tempLabel = self.messageLabel;
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(tempLabel);
    
    NSArray *constraints = [NSLayoutConstraint
                            constraintsWithVisualFormat:@"H:|-8-[tempLabel]-8-|"
                            options:0
                            metrics:nil
                            views:viewsDictionary];
    
    [self addConstraints:constraints];

    self.layer.cornerRadius = 5.0f;
    
    self.message = @"";
}

- (NSString *)message {
    return self.messageLabel.text;
}

- (void)setMessage:(NSString *)message
{
    self.hidden = (message.length == 0);
    
    if (self.hidden)
        return;

    self.messageLabel.text = message;
    [self layoutIfNeeded];
}

- (void)setMessageColor:(UIColor *)messageColor {
    self.messageLabel.textColor = messageColor;
}

- (void)setTextFont:(UIFont *)textFont{
    _textFont = textFont;
    self.messageLabel.font = textFont;
}

- (void)setMessageBackgroundColor:(UIColor *)messageBackgroundColor
{
    _messageBackgroundColor = messageBackgroundColor;
    self.backgroundColor = messageBackgroundColor;
    self.messageLabel.backgroundColor = messageBackgroundColor;
}

@end
