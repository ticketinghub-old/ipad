//
//  TXHSalesTicketCompletionViewController.m
//  TicketingHub
//
//  Created by Mark on 31/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesTicketCompletionViewController.h"
#import "TXHOrderManager.h"

@interface TXHSalesTicketCompletionViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *coupon;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;

@property (assign, nonatomic) BOOL editingCoupon;

@property (readwrite, nonatomic, getter = isValid) BOOL valid;

@end

@implementation TXHSalesTicketCompletionViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.valid = YES;
}

- (IBAction)continueAction:(id)sender {
#pragma unused (sender)
    [[UIApplication sharedApplication] sendAction:@selector(completeWizardStep) to:nil from:self forEvent:nil];
}

#pragma mark - UITextField delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
#pragma unused (textField)
    
    // Set a flag used when the keyboard appears whilst editing the coupon
    self.editingCoupon = YES;
    if ([self.delegate respondsToSelector:@selector(increaseHeight)]) {
        [self.delegate performSelector:@selector(increaseHeight)];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
#pragma unused (textField)

    // Clear the flag used when the keyboard appears whilst editing the coupon
    self.editingCoupon = NO;
    if ([self.delegate respondsToSelector:@selector(decreaseHeight)]) {
        [self.delegate performSelector:@selector(decreaseHeight)];
    }
}

- (void)finishStepWithCompletion:(void (^)(NSError *error))blockName
{
 
}

@end
