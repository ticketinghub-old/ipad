//
//  TXHSalesWizardDetailsViewController.m
//  TicketingHub
//
//  Created by Mark on 29/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesWizardDetailsViewController.h"

#import "TXHSalesContentProtocol.h"
#import "TXHSalesCompletionViewController.h"
#import "TXHSalesTimerViewController.h"

@interface TXHSalesWizardDetailsViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timerViewVerticalConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *completionViewVerticalConstraint;

@property (strong, nonatomic) TXHSalesTimerViewController *timeController;
@property (strong, nonatomic) id <TXHSalesContentProtocol> stepContentController;
@property (strong, nonatomic) TXHSalesCompletionViewController *stepCompletionController;

@end

@implementation TXHSalesWizardDetailsViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTimeController:(TXHSalesTimerViewController *)timeController {
    _timeController = timeController;
    [self updateContentController];
}

- (void)setStepContentController:(id <TXHSalesContentProtocol>)stepContentController {
    _stepContentController = stepContentController;
    [self updateContentController];
}

- (void)setStepCompletionController:(TXHSalesCompletionViewController *)stepCompletionController {
    _stepCompletionController = stepCompletionController;
    [self updateContentController];
}

- (void)updateContentController {
    if (self.timeController && self.stepContentController && self.stepCompletionController) {
        [self.stepContentController setTimerViewController:self.timeController];
        [self.stepContentController setCompletionViewController:self.stepCompletionController];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
#pragma unused (sender)
    if ([segue.identifier isEqualToString:@"TXHSalesTimerViewController"]) {
        self.timeController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"TXHSalesContentsViewController"]) {
        self.stepContentController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"TXHSalesCompletionViewController"]) {
        self.stepCompletionController = segue.destinationViewController;
    }
}

- (void)transition:(id)sender {
    [self.stepContentController transition:sender];
}

- (void)updateTimerContainerHeight:(id)sender {
    // The timer container needs to respond to changes in height based on whether a payment selection control is visible or not
    TXHSalesTimerViewController *controller = sender;
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.timerViewVerticalConstraint.constant = controller.newVerticalHeight;
        [self.view layoutIfNeeded];
    } completion:controller.animationHandler];
}

- (void)updateCompletionContainerHeight:(id)sender {
    // The completion container needs to respond to changes in height based on whether a coupon selection control is visible or not
    TXHSalesCompletionViewController *controller = sender;
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.completionViewVerticalConstraint.constant = controller.newVerticalHeight;
        [self.view layoutIfNeeded];
    } completion:controller.animationHandler];
}

// This action method is sent when the coupon text field gets focus - the container height is increased to keep the coupon field in view above the keyboard
- (void)increaseCompletionContainerHeight:(id)sender {
#pragma unused (sender)
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.completionViewVerticalConstraint.constant += 354.0f;
        [self.view layoutIfNeeded];
    } completion:nil];
}

// Finished editing the coupon field, so shrink the completion container back to it's original height
- (void)decreaseCompletionContainerHeight:(id)sender {
#pragma unused (sender)
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.completionViewVerticalConstraint.constant -= 354.0f;
        [self.view layoutIfNeeded];
    } completion:nil];
}

// Nil targeted action handlers for changing payment method - pass on to the ContentsViewController

- (void)didChangePaymentMethod:(id)sender {
    [self.stepContentController didChangePaymentMethod:sender];
}

@end
