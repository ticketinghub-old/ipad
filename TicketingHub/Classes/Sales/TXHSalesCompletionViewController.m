//
//  TXHSalesCompletionViewController.m
//  TicketingHub
//
//  Created by Mark on 05/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesCompletionViewController.h"

@interface TXHSalesCompletionViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *coupon;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;

@property (assign, nonatomic) BOOL editingCoupon;

@end

@implementation TXHSalesCompletionViewController

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

- (void)setCanCompleteStep:(BOOL)canCompleteStep {
    _canCompleteStep = canCompleteStep;
    self.continueButton.enabled = canCompleteStep;
}

- (IBAction)continueAction:(id)sender {
#pragma unused (sender)
    [[UIApplication sharedApplication] sendAction:@selector(completeWizardStep:) to:nil from:self forEvent:nil];
}

- (void)hideCoupon:(BOOL)hidden {
    __block typeof(self) blockSelf = self;
    
    if (hidden) {
        self.animationHandler = nil;
        self.coupon.hidden = YES;
        self.newVerticalHeight = 102.0f;
    } else {
        self.animationHandler = ^(BOOL finished) {
#pragma unused (finished)
            blockSelf.coupon.hidden = NO;
        };
        self.newVerticalHeight = 131.0f;
    }
    
    [[UIApplication sharedApplication] sendAction:@selector(updateCompletionContainerHeight:) to:nil from:self forEvent:nil];
}

#pragma mark - UITextField delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
#pragma unused (textField)
    [[UIApplication sharedApplication] sendAction:@selector(increaseCompletionContainerHeight:) to:nil from:self forEvent:nil];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
#pragma unused (textField)
    [[UIApplication sharedApplication] sendAction:@selector(decreaseCompletionContainerHeight:) to:nil from:self forEvent:nil];
}

@end
