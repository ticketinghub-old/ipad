//
//  TXHSalesCompletionViewController.m
//  TicketingHub
//
//  Created by Mark on 05/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesCompletionViewController.h"

#import "TXHBorderedButton.h"

static NSInteger const kCancelAlertTag = 123;

@interface TXHSalesCompletionViewController () <UIAlertViewDelegate>

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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Cancel Reservation", nil)
                                                    message:@"Are you sure want to cancel ticket reservation?"
                                                   delegate:self
                                          cancelButtonTitle:@"No"
                                          otherButtonTitles:@"Yes", nil];
    alert.tag = kCancelAlertTag;
    
    [alert show];
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

#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == kCancelAlertTag)
    {
        if (buttonIndex == 1) {
            [self.delegate salesCompletionViewControllerDidCancel:self];
        }
    }
}

@end
