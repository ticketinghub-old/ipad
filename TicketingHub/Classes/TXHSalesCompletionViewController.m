//
//  TXHSalesCompletionViewController.m
//  TicketingHub
//
//  Created by Mark on 05/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesCompletionViewController.h"

#import "TXHBorderedButton.h"

@interface TXHSalesCompletionViewController ()

@property (weak, nonatomic) IBOutlet TXHBorderedButton *continueButton;
@property (weak, nonatomic) IBOutlet TXHBorderedButton *cancelButton;

@end

@implementation TXHSalesCompletionViewController

- (void)setContinueButtonEnabled:(BOOL)enabled
{
    self.continueButton.enabled = enabled;
    self.continueButton.alpha = enabled ? 1.0 : 0.5;
}

#pragma mark - Button Actions

- (IBAction)cancelAction:(id)sender
{
    [self.delegate salesCompletionViewControllerDidCancel:self];
}

- (IBAction)continueAction:(id)sender
{
    [self.delegate salesCompletionViewControllerDidContinue:self];
}

#pragma mark - UITextField delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [[UIApplication sharedApplication] sendAction:@selector(increaseCompletionContainerHeight:) to:nil from:self forEvent:nil];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [[UIApplication sharedApplication] sendAction:@selector(decreaseCompletionContainerHeight:) to:nil from:self forEvent:nil];
}

@end
