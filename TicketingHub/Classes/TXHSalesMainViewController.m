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

@interface TXHSalesMainViewController () // <TXHSalesWizardDelegate>

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

- (IBAction)checkout:(id)sender {
  [self performSegueWithIdentifier:@"SalesCheckoutSegue" sender:sender];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
#pragma unused (sender)
    // If this segue is embedding one of the containers give it ourself as a delegate
    if ([segue.identifier isEqualToString:@"Embed Steps"]) {
        self.wizardSteps = segue.destinationViewController;
//        self.wizardSteps.delegate = self;
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

- (void)didChangeOption:(id)sender {
    if ([sender isKindOfClass:[TXHSalesWizardViewController class]] == YES) {
        [self.wizardDetails transition:sender];
    }
    if ([sender isKindOfClass:[TXHSalesWizardDetailsViewController class]] == YES) {
        [self.wizardSteps moveToNextStep:sender];
    }
}

- (void)continueFromStep:(NSNumber *)step {
    // We want to progress to the next step
//    [self wizard:self.wizardSteps didChooseOption:step];
}

- (void)completeWizardStep:(id)sender {
    [self.wizardSteps moveToNextStep:sender];
}

- (void)orderExpiredWithSender:(id)sender {
#pragma unused (sender)
    [self.wizardSteps orderExpired];
}

@end
