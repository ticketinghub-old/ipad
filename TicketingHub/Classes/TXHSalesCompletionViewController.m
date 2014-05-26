//
//  TXHSalesCompletionViewController.m
//  TicketingHub
//
//  Created by Mark on 05/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesCompletionViewController.h"

#import "TXHBorderedButton.h"
#import "TXHGradientView.h"

@interface TXHSalesCompletionViewController () <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet TXHBorderedButton *rightButton;
@property (weak, nonatomic) IBOutlet TXHBorderedButton *middleLeftButton;
@property (weak, nonatomic) IBOutlet TXHBorderedButton *middleButton;
@property (weak, nonatomic) IBOutlet TXHBorderedButton *middleRightButton;
@property (weak, nonatomic) IBOutlet TXHBorderedButton *leftButton;

@end

@implementation TXHSalesCompletionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupGradient];
}

- (void)setupGradient
{
    UIColor *colorOne = [UIColor colorWithWhite:1.0 alpha:0.0];
    UIColor *colorTwo = [UIColor whiteColor];
    
    NSArray *colors =  [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    
    [(TXHGradientView *)self.view setColors:colors];
}

#pragma mark Buttons Title

- (void)setLeftButtonTitle:(NSString *)buttonTitle
{
    [self setTitle:buttonTitle forButton:self.leftButton];
}

- (void)setMiddleLeftButtonTitle:(NSString *)buttonTitle
{
    [self setTitle:buttonTitle forButton:self.middleLeftButton];
}

- (void)setMiddleButtonTitle:(NSString *)buttonTitle
{
    [self setTitle:buttonTitle forButton:self.middleButton];
}

- (void)setMiddleRightButtonTitle:(NSString *)buttonTitle
{
    [self setTitle:buttonTitle forButton:self.middleRightButton];
}

- (void)setRightButtonTitle:(NSString *)buttonTitle
{
    [self setTitle:buttonTitle forButton:self.rightButton];
}

- (void)setTitle:(NSString *)title forButton:(TXHBorderedButton *)button
{
    if (![title length])
        title = @"";

    [button setTitle:title forState:UIControlStateNormal];
}

#pragma mark Buttons Enable

- (void)setButtonsDisabled:(BOOL)disabled
{
    [self setLeftButtonDisabled:disabled];
    [self setMiddleButtonDisabled:disabled];
    [self setRightButtonDisabled:disabled];
}

- (void)setLeftButtonDisabled:(BOOL)disabled
{
    [self setButton:self.leftButton disabled:disabled];
}

- (void)setMiddleLeftButtonDisabled:(BOOL)disabled
{
    [self setButton:self.middleLeftButton disabled:disabled];
}

- (void)setMiddleButtonDisabled:(BOOL)disabled
{
    [self setButton:self.middleButton disabled:disabled];
    
    // TODO: make it better
//    [UIView animateWithDuration:0.1
//                          delay:0.0
//                        options:UIViewAnimationOptionBeginFromCurrentState
//                     animations:^{
//                         self.middleButton.centerY = disabled ? self.view.height * 2 : self.view.height / 2;
//                         [self.view layoutIfNeeded];
//                     }
//                     completion:nil];
}

- (void)setMiddleRightButtonDisabled:(BOOL)disabled
{
    [self setButton:self.middleRightButton disabled:disabled];
}

- (void)setRightButtonDisabled:(BOOL)disabled
{
    [self setButton:self.rightButton disabled:disabled];
}

- (void)setButton:(TXHBorderedButton *)button disabled:(BOOL)disabled
{
    button.enabled = !disabled;
}

#pragma mark Buttons Hide

- (void)setLeftButtonHidden:(BOOL)hidden
{
    [self setButton:self.leftButton hidden:hidden];
}

- (void)setMiddleLeftButtonHidden:(BOOL)hidden
{
    [self setButton:self.middleLeftButton hidden:hidden];
}

- (void)setMiddleButtonHidden:(BOOL)hidden
{
    [self setButton:self.middleButton hidden:hidden];
}

- (void)setMiddleRightButtonHidden:(BOOL)hidden
{
    [self setButton:self.middleRightButton hidden:hidden];
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

- (IBAction)middleLeftButtonAction:(id)sender
{
    [self.delegate salesCompletionViewController:self didDidSelectMiddleLeftButton:sender];
}

- (IBAction)middleButtonAction:(id)sender
{
    [self.delegate salesCompletionViewController:self didDidSelectMiddleButton:sender];
}

- (IBAction)middleRightButtonAction:(id)sender
{
    [self.delegate salesCompletionViewController:self didDidSelectMiddleRightButton:sender];
}

- (IBAction)rightButtonAction:(id)sender
{
    [self.delegate salesCompletionViewController:self didDidSelectRightButton:sender];
}


@end
