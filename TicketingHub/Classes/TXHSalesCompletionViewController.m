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
   
    self.canCompleteStep = YES;
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

#pragma mark - Button Actions

- (IBAction)cancelAction:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(orderExpiredWithSender:) to:nil from:self forEvent:nil];
}

- (IBAction)continueAction:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(completeWizardStep:) to:nil from:self forEvent:nil];
}

#pragma mark - UITextField delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [[UIApplication sharedApplication] sendAction:@selector(increaseCompletionContainerHeight:) to:nil from:self forEvent:nil];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [[UIApplication sharedApplication] sendAction:@selector(decreaseCompletionContainerHeight:) to:nil from:self forEvent:nil];
}

@end
