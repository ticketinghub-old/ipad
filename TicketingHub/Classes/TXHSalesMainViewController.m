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
    
    self.stepsManager = [[TXHSaleStepsManager alloc] initWithSteps:@[@{kWizardStepTitleKey  : NSLocalizedString(@"SALESMAN_STEPS_TICKET_QUANTITY_TITLE",nil),
                                                                       kWizardStepDescriptionKey : NSLocalizedString(@"SALESMAN_STEPS_TICKET_QUANTITY_DESC",nil),
                                                                       kWizardStepControllerSegueID : @"Tickets Quantity",
                                                                       kWizardStepHidesCancelButton : @YES,
                                                                       kWizardStepContinueButtonTitle : NSLocalizedString(@"SALESMAN_STEPS_TICKET_QUANTITY_FULL_TITLE",nil)},

                                                                     @{kWizardStepTitleKey  : NSLocalizedString(@"SALESMAN_STEPS_TICKET_UPGRADES_TITLE",nil),
                                                                       kWizardStepDescriptionKey : NSLocalizedString(@"SALESMAN_STEPS_TICKET_UPGRADES_DESC",nil),
                                                                       kWizardStepControllerSegueID : @"Tickets Upgrades",
                                                                       kWizardStepContinueButtonTitle : NSLocalizedString(@"SALESMAN_STEPS_TICKET_UPGRADES_FULL_TITLE",nil)},

                                                                     @{kWizardStepTitleKey  : NSLocalizedString(@"SALESMAN_STEPS_ORDER_SUMMARY_TITLE",nil),
                                                                       kWizardStepDescriptionKey : NSLocalizedString(@"SALESMAN_STEPS_ORDER_SUMMARY_DESC",nil),
                                                                       kWizardStepControllerSegueID : @"Order Summary",
                                                                       kWizardStepContinueButtonTitle : NSLocalizedString(@"SALESMAN_STEPS_ORDER_SUMMARY_FULL_TITLE",nil)},

                                                                     @{kWizardStepTitleKey  : NSLocalizedString(@"SALESMAN_STEPS_PAYMENT_TITLE",nil),
                                                                       kWizardStepDescriptionKey : NSLocalizedString(@"SALESMAN_STEPS_PAYMENT_DESC",nil),
                                                                       kWizardStepControllerSegueID : @"Payment",
                                                                       kWizardStepContinueButtonTitle : NSLocalizedString(@"SALESMAN_STEPS_PAYMENT_FULL_TITLE",nil)},

                                                                     @{kWizardStepTitleKey  : NSLocalizedString(@"SALESMAN_STEPS_SUMMARY_TITLE",nil),
                                                                       kWizardStepDescriptionKey : NSLocalizedString(@"SALESMAN_STEPS_SUMMARY_DESC",nil),
                                                                       kWizardStepControllerSegueID : @"Order Completion",
                                                                       kWizardStepContinueButtonTitle : NSLocalizedString(@"SALESMAN_STEPS_SUMMARY_FULL_TITLE",nil)}
                                                                     ]];

    self.stepsManager.delegate = self;
    self.wizardSteps.dataSource = self.stepsManager;
    
    [self performSegueWithIdentifier:@"Embed Step1" sender:self];
    
    [self resetData];
    
    [self registerForProductAndAvailabilityChanges];
    [self registerForKeyboardNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orderDidExpire:)
                                                 name:TXHOrderDidExpireNotification object:nil];
}

- (void)dealloc
{
    // remove observer
    self.stepCompletionController = nil;
    [self unregisterForProductAndAvailabilityChanges];
    [self unregisterFromKeyboardNotifications];
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

// observer vs delegation ??? used KVO...
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

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)unregisterFromKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];

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

#pragma mark - Keyboard notifications

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    NSValue *kbFrame = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardFrame = [kbFrame CGRectValue];
    NSInteger curve = [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue] << 16;
    
    CGFloat height = keyboardFrame.size.width - self.stepCompletionController.view.height;

    if ([self.stepContentController respondsToSelector:@selector(setOffsetBottomBy:)])
        [UIView animateWithDuration:animationDuration
                              delay:0.0
                            options:curve
                         animations:^{
                             [self.stepContentController setOffsetBottomBy:height];

                         }
                         completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    NSInteger curve = [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue] << 16;
    
    if ([self.stepContentController respondsToSelector:@selector(setOffsetBottomBy:)])
        [UIView animateWithDuration:animationDuration
                              delay:0.0
                            options:curve
                         animations:^{
                             [self.stepContentController setOffsetBottomBy:0];

                         }
                         completion:nil];
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
    NSInteger index = [manager indexOfStep:step];
    if (index == 0) {
        [TXHORDERMANAGER resetOrder];
    }
    
    if (index == NSNotFound)
    {
        [self.stepCompletionController setCancelButtonHidden:YES];
        [self.stepCompletionController setContinueButtonEnabled:NO];
        return;
    }
    // update header
    [self.timeController setTitleText:step[kWizardStepTitleKey]];
    [self.timeController setTimerEndDate:[TXHORDERMANAGER expirationDate]];

    // update footer
    [self.stepCompletionController setCancelButtonHidden:[step[kWizardStepHidesCancelButton] boolValue]];
    [self.stepCompletionController setContinueButtonEnabled:[self.stepsManager hasNextStep]];
    [self.stepCompletionController setContinueButtonTitle:[self  continueButtonTitleForStep:step fromManger:manager]];
    
    // update content
    [self showStepContentControllerWithSegueID:step[kWizardStepControllerSegueID]];
    
    // update list
    [self.wizardSteps reloadWizard];
}

- (NSString *)continueButtonTitleForStep:(id)step fromManger:(TXHSaleStepsManager *)manager
{
    NSInteger index = [manager indexOfStep:step];
    id nextStep = [manager stepAtIndex:index + 1];
    
    NSString *nextStepFullTitle = nextStep[kWizardStepContinueButtonTitle];

    if (![nextStepFullTitle length])
        nextStepFullTitle = NSLocalizedString(@"SALESMAN_STEPS_FINISH_PROCESS_TITLE", nil);

    return nextStepFullTitle;
}

- (void)showStepContentControllerWithSegueID:(NSString *)segueID
{
    [self performSegueWithIdentifier:segueID sender:self];
}

#pragma mark - TXHSalesCompletionViewControllerDelegate

- (void)salesCompletionViewControllerDidCancel:(TXHSalesCompletionViewController *)controller
{
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
