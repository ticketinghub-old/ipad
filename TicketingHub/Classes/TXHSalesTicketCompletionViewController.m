//
//  TXHSalesTicketCompletionViewController.m
//  TicketingHub
//
//  Created by Mark on 31/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesTicketCompletionViewController.h"

@interface TXHSalesTicketCompletionViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *coupon;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;

@property (assign, nonatomic) BOOL editingCoupon;

@end

@implementation TXHSalesTicketCompletionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
