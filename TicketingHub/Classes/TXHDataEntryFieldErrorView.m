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
    
    self.messageLabel.font = [UIFont systemFontOfSize:12.5f];
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
    
    self.messageBackgroundColor = [UIColor colorWithRed:28.0f / 255.0f
                                                  green:60.0f / 255.0f
                                                   blue:84.0f / 255.0f
                                                  alpha:1.0f];
    self.messageColor = [UIColor whiteColor];
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
    
    NSDictionary *attributesDict = @{NSFontAttributeName: self.messageLabel.font};
    NSAttributedString *attributedMessage = [[NSAttributedString alloc] initWithString:message attributes:attributesDict];
    CGSize size = [attributedMessage size];
    CGRect bounds = self.messageLabel.bounds;
    bounds.size = size;
    self.messageLabel.bounds = bounds;
    self.messageLabel.text = message;
    [self layoutIfNeeded];
}

- (void)setMessageColor:(UIColor *)messageColor {
    self.messageLabel.textColor = messageColor;
}

- (void)setMessageBackgroundColor:(UIColor *)messageBackgroundColor {
    _messageBackgroundColor = messageBackgroundColor;
    self.backgroundColor = messageBackgroundColor;
    self.messageLabel.backgroundColor = messageBackgroundColor;
}

@end
