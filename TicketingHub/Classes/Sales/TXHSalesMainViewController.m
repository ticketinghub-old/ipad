//
//  TXHSalesMainViewController.m
//  TicketingHub
//
//  Created by Mark on 08/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesMainViewController.h"

#import "TXHTransitionSegue.h"
#import "TXHSalesWizardDetailsViewController.h"
#import "TXHSalesWizardViewController.h"

@interface TXHSalesMainViewController () <TXHSalesWizardDelegate>

@property (weak, nonatomic) IBOutlet UIView *steps;
@property (weak, nonatomic) IBOutlet UIView *details;

@property (strong, nonatomic)   TXHSalesWizardViewController *wizardSteps;
@property (strong, nonatomic)   TXHSalesWizardDetailsViewController *wizardDetails;

@end

@implementation TXHSalesMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    [super didMoveToParentViewController:parent];
    [self resetFrame];
}

- (void)resetFrame {
    CGRect frame = self.view.frame;
    frame.size.width = 1024;
    frame.size.height = 768;
    self.view.frame = frame;
}

- (IBAction)checkout:(id)sender {
  [self performSegueWithIdentifier:@"SalesCheckoutSegue" sender:sender];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
#pragma unused (sender)
    // If this segue is embedding one of the containers give it ourself as a delegate
    if ([segue.identifier isEqualToString:@"Embed Steps"]) {
        self.wizardSteps = segue.destinationViewController;
        self.wizardSteps.delegate = self;
        return;
    }
    if ([segue.identifier isEqualToString:@"Embed Details"]) {
        self.wizardDetails = segue.destinationViewController;
        self.wizardDetails.delegate = self;
        return;
    }
    
    if ([segue isMemberOfClass:[TXHTransitionSegue class]]) {
        TXHTransitionSegue *transitionSegue = (TXHTransitionSegue *)segue;
        transitionSegue.containerView = self.view;
    }
}

- (void)wizard:(id <TXHSalesWizardDelegate>)wizard didChooseOption:(NSNumber *)option {
    if ([wizard isKindOfClass:[TXHSalesWizardViewController class]] == YES) {
        [self.wizardDetails performSegueWithIdentifier:[NSString stringWithFormat:@"Transition To Step%d", option.integerValue] sender:option];
    }
    if ([wizard isKindOfClass:[TXHSalesWizardDetailsViewController class]] == YES) {
        [self.wizardSteps moveToNextStep];
    }
}

- (void)continueFromStep:(NSNumber *)step {
    // We want to progress to the next step
    [self wizard:self.wizardSteps didChooseOption:step];
}

- (void)completeWizardStep {
    [self.wizardSteps moveToNextStep];
}

- (void)orderExpiredWithSender:(id)sender {
#pragma unused (sender)
    [self.wizardSteps orderExpired];
}

@end
