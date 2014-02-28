//
//  TXHSelectionEntryTableViewCell.m
//  TicketingHub
//
//  Created by Mark on 20/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSelectionEntryTableViewCell.h"

#import "TXHDataEntryFieldErrorView.h"
#import <QuartzCore/QuartzCore.h>

@interface TXHSelectionEntryTableViewCell ()

@property (weak, nonatomic) IBOutlet TXHDataEntryFieldErrorView *errorMessageView;
@property (weak, nonatomic) IBOutlet UIButton *selectionField;

@end

@implementation TXHSelectionEntryTableViewCell

+ (UIColor *)errorBackgroundColor
{
    static UIColor *_errorBackgroundColor;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _errorBackgroundColor = [UIColor colorWithRed:255.0f / 255.0f
                                                green:213.0f / 255.0f
                                                 blue:216.0f / 255.0f
                                                alpha:1.0f];
    });
    return _errorBackgroundColor;
}

+ (UIColor *)normalBackgroundColor
{
    static UIColor *_normalBackgroundColor;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _normalBackgroundColor = [UIColor colorWithRed:238.0f / 255.0f
                                                 green:241.0f / 255.0f
                                                  blue:243.0f / 255.0f
                                                 alpha:1.0f];
    });
    return _normalBackgroundColor;
}

+ (UIColor *)errorTextColor
{
    static UIColor *_errorTextColor;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _errorTextColor = [UIColor redColor];
    });
    return _errorTextColor;
}

+ (UIColor *)normalTextColor
{
    static UIColor *_normalTextColor;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _normalTextColor = [UIColor colorWithRed:37.0f / 255.0f
                                           green:16.0f / 255.0f
                                            blue:87.0f / 255.0f
                                           alpha:1.0f];
    });
    return _normalTextColor;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setupSeletionField];
}


- (void)setupSeletionField
{
    self.selectionField.layer.borderColor  = self.selectionField.tintColor.CGColor;
    self.selectionField.layer.cornerRadius = 5.0;
    self.selectionField.layer.borderWidth  = 1.0;
}

- (BOOL)hasErrors
{
    return (self.errorMessageView.message.length > 0);
}

- (void)prepareForReuse {
    [super prepareForReuse];
}

- (void)setText:(NSString *)text
{
    [self.selectionField setTitle:text forState:UIControlStateNormal];
}

- (NSString *)text
{
    return self.selectionField.titleLabel.text;
}

- (void)setErrorMessage:(NSString *)errorMessage
{
    self.errorMessageView.message = errorMessage;
    [self updateColors];
}

- (void)updateColors
{
}

@end
