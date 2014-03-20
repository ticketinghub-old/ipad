//
//  TXHSalesCompletionViewController.m
//  TicketingHub
//
//  Created by Mark on 05/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesCompletionViewController.h"

#import "TXHBorderedButton.h"

@interface TXHSalesCompletionViewController () <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet TXHBorderedButton *rightButton;
@property (weak, nonatomic) IBOutlet TXHBorderedButton *middleButton;
@property (weak, nonatomic) IBOutlet TXHBorderedButton *leftButton;

@end

@implementation TXHSalesCompletionViewController

#pragma mark Buttons Image


- (void)setRightButtonImage:(UIImage *)rightButtonImage
{
    [self setImage:rightButtonImage forButton:self.rightButton];
}

- (void)setMiddleButtonImage:(UIImage *)middleButtonImage
{
    [self setImage:middleButtonImage forButton:self.middleButton];
}

- (void)setImage:(UIImage *)image forButton:(TXHBorderedButton *)button
{
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [button setImage:image forState:UIControlStateNormal];
}

#pragma mark Buttons Title

- (void)setLeftButtonTitle:(NSString *)continueButtonTitle
{
    [self setTitle:continueButtonTitle forButton:self.leftButton];
}

- (void)setMiddleButtonTitle:(NSString *)continueButtonTitle
{
    [self setTitle:continueButtonTitle forButton:self.middleButton];
}

- (void)setRightButtonTitle:(NSString *)continueButtonTitle
{
    [self setTitle:continueButtonTitle forButton:self.rightButton];
}

- (void)setTitle:(NSString *)title forButton:(TXHBorderedButton *)button
{
    if (![title length])
        title = @"";

    [button setTitle:title forState:UIControlStateNormal];
}

#pragma mark Buttons Enable

- (void)setLeftButtonDisabled:(BOOL)disabled
{
    [self setButton:self.leftButton disabled:disabled];
}

- (void)setMiddleButtonDisabled:(BOOL)disabled
{
    [self setButton:self.middleButton disabled:disabled];
}

- (void)setRightButtonDisabled:(BOOL)disabled
{
    [self setButton:self.rightButton disabled:disabled];
}

- (void)setButton:(TXHBorderedButton *)button disabled:(BOOL)disabled
{
    button.enabled = !disabled;
    button.alpha   = !disabled ? 1.0 : 0.5;
}

#pragma mark Buttons Hide

- (void)setLeftButtonHidden:(BOOL)hidden
{
    [self setButton:self.leftButton hidden:hidden];
}

- (void)setMiddleButtonHidden:(BOOL)hidden
{
    [self setButton:self.middleButton hidden:hidden];
}

- (void)setRightButtonHidden:(BOOL)hidden
{
    [self setButton:self.rightButton hidden:hidden];
}

- (void)setButton:(TXHBorderedButton *)button hidden:(BOOL)hidden
{
    button.hidden = hidden;
}

#pragma mark - Button Actions

- (IBAction)leftButtonAction:(id)sender
{
    [self.delegate salesCompletionViewController:self didDidSelectLeftButton:sender];
}

- (IBAction)middleButtonAction:(id)sender
{
    [self.delegate salesCompletionViewController:self didDidSelectMiddleButton:sender];
}

- (IBAction)rightButtonAction:(id)sender
{
    [self.delegate salesCompletionViewController:self didDidSelectRightButton:sender];
}


#pragma mark - Button Color

- (void)setLeftBarButtonColor:(UIColor *)color;
{
    self.leftButton.borderColor          = color;
    self.leftButton.normalTextColor      = color;
    self.leftButton.highlightedFillColor = color;
}

@end
