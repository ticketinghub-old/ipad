//
//  TXHSalesMainViewController.m
//  TicketingHub
//
//  Created by Mark on 08/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesMainViewController.h"

// segues
#import "TXHEmbeddingSegue.h"
#import "TXHTransitionSegue.h"


// child controllers
#import "TXHSalesTimerViewController.h"
#import "TXHSalesCompletionViewController.h"
#import "TXHSalesWizardViewController.h"

// steps data
#import "TXHSalesStepAbstract.h"
#import "TXHSaleStepsManager.h"
#import "TXHOrderManager.h"

// defines
#import "ProductListControllerNotifications.h"

static void * ContentValidContext = &ContentValidContext;

@interface TXHSalesMainViewController ()  <TXHSaleStepsManagerDelegate, TXHSalesCompletionViewControllerDelegate>

@property (strong, nonatomic) TXHSalesWizardViewController           *wizardSteps;
@property (strong, nonatomic) TXHSalesTimerViewController            *timeController;
@property (strong, nonatomic) TXHSalesCompletionViewController       *stepCompletionController;
@property (strong, nonatomic) UIViewController<TXHSalesContentsViewControllerProtocol> *stepContentController;

@property (weak, nonatomic) IBOutlet UIView *contentsContainer;

// data
@property (strong, nonatomic) TXHSaleStepsManager *stepsManager;

@end

@implementation TXHSalesMainViewController

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
    
    [self performSegueWithIdentifier:@"Embed Step1" sender:self];
    
    [self resetData];
    
    [self registerForProductAndAvailabilityChanges];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orderDidExpire:)
                                                 name:TXHOrderDidExpireNotification object:nil];
}

- (void)dealloc
{
    // remove observer
    self.stepCompletionController = nil;
    [self unregisterForProductAndAvailabilityChanges];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TXHOrderDidExpireNotification object:nil];
}

- (void)orderDidExpire:(NSNotification *)note
{
    [self resetData];
}

- (void)resetData
{
    [TXHORDERMANAGER resetOrder];
    [self.stepsManager resetProcess];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Embed Steps"])
    {
        self.wizardSteps = segue.destinationViewController;
    }
    else if ([segue.identifier isEqualToString:@"TXHSalesTimerViewController"])
    {
        self.timeController = segue.destinationViewController;
    }
    else if ([segue.identifier isEqualToString:@"TXHSalesCompletionViewController"])
    {
        self.stepCompletionController = segue.destinationViewController;
        self.stepCompletionController.delegate = self;
    }
    else if (([segue isMemberOfClass:[TXHTransitionSegue class]]) ||
             ([segue.identifier isEqualToString:@"Embed Step1"]))
    {
        TXHTransitionSegue *transitionSegue = (TXHTransitionSegue *)segue;
        transitionSegue.containerView = self.contentsContainer;
        self.stepContentController = segue.destinationViewController;
    }
}

// TODO: rethink that idea (or sorry if not good enough and i forgot)
- (void)setStepContentController:(UIViewController<TXHSalesContentsViewControllerProtocol> *)stepContentController
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

- (void)registerForProductAndAvailabilityChanges
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(productDidChange:)
                                                 name:TXHProductChangedNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(availabilityDidChange:)
                                                 name:TXHAvailabilityChangedNotification
                                               object:nil];
}

- (void)unregisterForProductAndAvailabilityChanges
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TXHProductChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TXHAvailabilityChangedNotification object:nil];

}

#pragma mark notifications

- (void)productDidChange:(NSNotification *)note
{
    [self resetData];
}

- (void)availabilityDidChange:(NSNotification *)note
{
    [self resetData];
}


#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == ContentValidContext)
    {
        [self.stepCompletionController setContinueButtonEnabled:[self.stepContentController isValid]];
    }
}

#pragma mark - TXHSaleStepsManagerDelegate

- (void)saleStepsManager:(TXHSaleStepsManager *)manager didChangeToStep:(id)step
{
    // update header
    [self.timeController setTitleText:step[kWizardStepTitleKey]];
    [self.timeController setTimerEndDate:[TXHORDERMANAGER expirationDate]];

    // update footer
    [self.stepCompletionController setContinueButtonEnabled:[self.stepsManager hasNextStep]];
    
    // update content
    [self showStepContentControllerWithSegueID:step[kWizardStepControllerSegueID]];
    
    // update list
    [self.wizardSteps reloadWizard];
}

- (void)showStepContentControllerWithSegueID:(NSString *)segueID
{
    [self performSegueWithIdentifier:segueID sender:self];
}

#pragma mark - TXHSalesCompletionViewControllerDelegate

- (void)salesCompletionViewControllerDidCancel:(TXHSalesCompletionViewController *)controller
{
    //TODO: show alertview to confirm
    [self resetData];
}

- (void)salesCompletionViewControllerDidContinue:(TXHSalesCompletionViewController *)controller
{
    self.stepCompletionController.view.userInteractionEnabled = NO;
    [self.stepContentController finishStepWithCompletion:^(NSError *error) {
        if (!error)
        {
            [self.stepsManager continueToNextStep];
        }
        self.stepCompletionController.view.userInteractionEnabled = YES;
    }];
}


@end
