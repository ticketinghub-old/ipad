//
//  TXHSalesMainViewController.m
//  TicketingHub
//
//  Created by Mark on 08/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesMainViewController.h"

// child controllers
#import "TXHTransitionSegue.h"
#import "TXHSalesTimerViewController.h"
#import "TXHSalesContentsViewController.h"
#import "TXHSalesCompletionViewController.h"
#import "TXHSalesWizardViewController.h"

// steps data
#import "TXHSalesStepAbstract.h"
#import "TXHSaleStepsManager.h"

static void * ContentValidContext = &ContentValidContext;

@interface TXHSalesMainViewController ()  <TXHSaleStepsManagerDelegate, TXHSalesCompletionViewControllerDelegate>

@property (strong, nonatomic) TXHSalesWizardViewController     *wizardSteps;
@property (strong, nonatomic) TXHSalesTimerViewController      *timeController;
@property (strong, nonatomic) TXHSalesContentsViewController   *stepContentController;
@property (strong, nonatomic) TXHSalesCompletionViewController *stepCompletionController;


// data
@property (strong, nonatomic) TXHSaleStepsManager *stepsManager;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.stepsManager = [[TXHSaleStepsManager alloc] initWithSteps:@[@{kWizardStepTitleKey  : NSLocalizedString(@"Tickets", @"Tickets"),
                                                                       kWizardStepDescriptionKey : NSLocalizedString(@"Select Type & Quantity", @"Select Type & Quantity"),
                                                                       kWizardStepControllerSegueID : @"Tickets Quantity"},

                                                                     @{kWizardStepTitleKey  : NSLocalizedString(@"Information", @"Information"),
                                                                       kWizardStepDescriptionKey : NSLocalizedString(@"Customer details", @"Customer details"),
                                                                       kWizardStepControllerSegueID : @"Tickets Details"},

                                                                     @{kWizardStepTitleKey  : NSLocalizedString(@"Upgrades", @"Upgrades"),
                                                                       kWizardStepDescriptionKey : NSLocalizedString(@"Add ticket extras", @"Add ticket extras"),
                                                                       kWizardStepControllerSegueID : @"Tickets Upgrades"},

                                                                     @{kWizardStepTitleKey  : NSLocalizedString(@"Products", @"Products"),
                                                                       kWizardStepDescriptionKey : NSLocalizedString(@"Optional extras", @"Optional extras"),
                                                                       kWizardStepControllerSegueID : @"Extra Products"},

                                                                     @{kWizardStepTitleKey  : NSLocalizedString(@"Summary", @"Summary"),
                                                                       kWizardStepDescriptionKey : NSLocalizedString(@"Review the order", @"Review the order"),
                                                                       kWizardStepControllerSegueID : @"Order Summary"},

                                                                     @{kWizardStepTitleKey  : NSLocalizedString(@"Payment", @"Payment"),
                                                                       kWizardStepDescriptionKey : NSLocalizedString(@"By card, cash or credit", @"By card, cash or credit"),
                                                                       kWizardStepControllerSegueID : @"Payment"},

                                                                     @{kWizardStepTitleKey  : NSLocalizedString(@"Completed", @"Completed"),
                                                                       kWizardStepDescriptionKey : NSLocalizedString(@"Print tickets and recipt", @"Print tickets and recipt"),
                                                                       kWizardStepControllerSegueID : @"Order Completion"}
                                                                     ]];

    self.stepsManager.delegate = self;
    self.wizardSteps.dataSource = self.stepsManager;
    
    [self.stepsManager resetProcess];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Embed Steps"]){
        self.wizardSteps = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"TXHSalesTimerViewController"]) {
        self.timeController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"TXHSalesContentsViewController"]) {
        self.stepContentController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"TXHSalesCompletionViewController"]) {
        self.stepCompletionController = segue.destinationViewController;
        self.stepCompletionController.delegate = self;
    } else if ([segue isMemberOfClass:[TXHTransitionSegue class]]){
        TXHTransitionSegue *transitionSegue = (TXHTransitionSegue *)segue;
        transitionSegue.containerView = self.view;
    }
}

// TODO: rethink that idea (or sorry if not good enough and i forgot)
- (void)setStepContentController:(TXHSalesContentsViewController *)stepContentController
{
    id observer = self;
    NSString * keyPath = @"valid";
    
    if (_stepContentController)
        [_stepContentController removeObserver:self forKeyPath:keyPath context:ContentValidContext];
    
    _stepContentController = stepContentController;
    
    if (_stepContentController)
        [_stepContentController addObserver:observer
                                 forKeyPath:keyPath
                                    options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial
                                    context:ContentValidContext];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == ContentValidContext)
    {
        DLog(@"is Valid changed");
    }
}

#pragma mark - TXHSaleStepsManagerDelegate

- (void)saleStepsManager:(TXHSaleStepsManager *)manager didChangeToStep:(id)step
{
    // update header
    [self.timeController setTitleText:step[kWizardStepTitleKey]];
    
    // update footer
    [self.stepCompletionController setContinueButtonEnabled:[self.stepsManager hasNextStep]];
    
    // update content
    [self.stepContentController showStepWithSegueID:step[kWizardStepControllerSegueID]];
    
    // update list
    [self.wizardSteps reloadWizard];
}

#pragma mark - TXHSalesCompletionViewControllerDelegate

- (void)salesCompletionViewControllerDidCancel:(TXHSalesCompletionViewController *)controller
{
    //TODO: show alertview to confirm
    [self.stepsManager resetProcess];
}

- (void)salesCompletionViewControllerDidContinue:(TXHSalesCompletionViewController *)controller
{
    [self.stepsManager continueToNextStep];
}

@end
