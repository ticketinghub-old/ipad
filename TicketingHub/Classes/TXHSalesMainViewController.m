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

#import "UIColor+TicketingHub.h"

#import "TXHPrintersManager.h"
#import "TXHPrinterSelectionViewController.h"

// defines
#import "ProductListControllerNotifications.h"

typedef NS_ENUM(NSUInteger, TXHPrintTarget) {
    TXHPrintTargetNone,
    TXHPrintTargetTickets,
    TXHPrintTargetRecipt
};

static void * ContentValidContext = &ContentValidContext;

@interface TXHSalesMainViewController ()  <TXHSaleStepsManagerDelegate, TXHSalesCompletionViewControllerDelegate, TXHPrinterSelectionViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentsContainer;

@property (strong, nonatomic) TXHSalesWizardViewController           *wizardSteps;
@property (strong, nonatomic) TXHSalesTimerViewController            *timeController;
@property (strong, nonatomic) TXHSalesCompletionViewController       *stepCompletionController;
@property (strong, nonatomic) UIViewController<TXHSalesContentsViewControllerProtocol> *stepContentController;

@property (assign, nonatomic) TXHPrintTarget       printTarget;
@property (strong, nonatomic) UIPopoverController *printerSelectorPopover;

// data
@property (strong, nonatomic) TXHSaleStepsManager *stepsManager;

@end

@implementation TXHSalesMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.stepsManager = [[TXHSaleStepsManager alloc] initWithSteps:@[@{kWizardStepTitleKey          : NSLocalizedString(@"SALESMAN_STEPS_TICKET_QUANTITY_TITLE",nil),
                                                                       kWizardStepDescriptionKey    : NSLocalizedString(@"SALESMAN_STEPS_TICKET_QUANTITY_DESC",nil),
                                                                       kWizardStepLeftButtonTitle   : NSLocalizedString(@"SALESMAN_STEPS_CANCEL_ORDER_BUTTON_TITLE",nil),
                                                                       kWizardStepRightButtonTitle  : NSLocalizedString(@"SALESMAN_STEPS_TICKET_QUANTITY_RIGHT_BUTTON_TITLE",nil),
                                                                       kWizardStepControllerSegueID : @"Tickets Quantity",
                                                                       kWizardStepHidesLeftButton   : @YES,
                                                                       kWizardStepHidesMiddleButton : @YES,
                                                                       kWizardStepLeftButtonColor   : [UIColor redColor],
                                                                       kWizardStepRightButtonImage  : [UIImage imageNamed:@"right-arrow"]},

                                                                     @{kWizardStepTitleKey          : NSLocalizedString(@"SALESMAN_STEPS_TICKET_UPGRADES_TITLE",nil),
                                                                       kWizardStepDescriptionKey    : NSLocalizedString(@"SALESMAN_STEPS_TICKET_UPGRADES_DESC",nil),
                                                                       kWizardStepLeftButtonTitle   : NSLocalizedString(@"SALESMAN_STEPS_CANCEL_ORDER_BUTTON_TITLE",nil),
                                                                       kWizardStepRightButtonTitle  : NSLocalizedString(@"SALESMAN_STEPS_TICKET_UPGRADES_RIGHT_BUTTON_TITLE",nil),
                                                                       kWizardStepControllerSegueID : @"Tickets Upgrades",
                                                                       kWizardStepHidesMiddleButton : @YES,
                                                                       kWizardStepLeftButtonColor   : [UIColor redColor],
                                                                       kWizardStepRightButtonImage  : [UIImage imageNamed:@"right-arrow"]},

                                                                     @{kWizardStepTitleKey          : NSLocalizedString(@"SALESMAN_STEPS_ORDER_SUMMARY_TITLE",nil),
                                                                       kWizardStepDescriptionKey    : NSLocalizedString(@"SALESMAN_STEPS_ORDER_SUMMARY_DESC",nil),
                                                                       kWizardStepLeftButtonTitle   : NSLocalizedString(@"SALESMAN_STEPS_CANCEL_ORDER_BUTTON_TITLE",nil),
                                                                       kWizardStepRightButtonTitle  : NSLocalizedString(@"SALESMAN_STEPS_ORDER_SUMMARY_RIGHT_BUTTON_TITLE",nil),
                                                                       kWizardStepControllerSegueID : @"Order Summary",
                                                                       kWizardStepHidesMiddleButton : @YES,
                                                                       kWizardStepLeftButtonColor   : [UIColor redColor],
                                                                       kWizardStepRightButtonImage  : [UIImage imageNamed:@"right-arrow"]},

                                                                     @{kWizardStepTitleKey          : NSLocalizedString(@"SALESMAN_STEPS_PAYMENT_TITLE",nil),
                                                                       kWizardStepDescriptionKey    : NSLocalizedString(@"SALESMAN_STEPS_PAYMENT_DESC",nil),
                                                                       kWizardStepLeftButtonTitle   : NSLocalizedString(@"SALESMAN_STEPS_CANCEL_ORDER_BUTTON_TITLE",nil),
                                                                       kWizardStepRightButtonTitle  : NSLocalizedString(@"SALESMAN_STEPS_PAYMENT_RIGHT_BUTTON_TITLE",nil),
                                                                       kWizardStepControllerSegueID : @"Payment",
                                                                       kWizardStepHidesMiddleButton : @YES,
                                                                       kWizardStepLeftButtonColor   : [UIColor redColor],
                                                                       kWizardStepRightButtonImage  : [UIImage imageNamed:@"right-arrow"]},

                                                                     @{kWizardStepTitleKey          : NSLocalizedString(@"SALESMAN_STEPS_SUMMARY_TITLE",nil),
                                                                       kWizardStepDescriptionKey    : NSLocalizedString(@"SALESMAN_STEPS_SUMMARY_DESC",nil),
                                                                       kWizardStepLeftButtonTitle   : NSLocalizedString(@"SALESMAN_STEPS_SUMMARY_LEFT_BUTTON_TITLE",nil),
                                                                       kWizardStepMiddleButtonTitle : NSLocalizedString(@"SALESMAN_STEPS_SUMMARY_MIDDLE_BUTTON_TITLE",nil),
                                                                       kWizardStepRightButtonTitle  : NSLocalizedString(@"SALESMAN_STEPS_SUMMARY_RIGHT_BUTTON_TITLE",nil),
                                                                       kWizardStepControllerSegueID : @"Order Completion",
                                                                       kWizardStepLeftButtonColor   : [UIColor txhBlueColor],
                                                                       kWizardStepMiddleButtonImage : [UIImage imageNamed:@"printer-icon"],
                                                                       kWizardStepRightButtonImage  : [UIImage imageNamed:@"printer-icon"],
                                                                       kWizardStepMiddleButtonBlock : ^(UIButton *button){[self showPrinterSelectorFromButton:button]; self.printTarget = TXHPrintTargetRecipt;},
                                                                       kWizardStepRightButtonBlock  : ^(UIButton *button){[self showPrinterSelectorFromButton:button]; self.printTarget = TXHPrintTargetTickets;}}
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

- (void)showPrinterSelectorFromButton:(UIButton *)button
{
    TXHPrinterSelectionViewController *printerSelector = [[TXHPrinterSelectionViewController alloc] init];
    printerSelector.delegate = self;
    
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:printerSelector];
    popover.popoverContentSize = CGSizeMake(200, 110);
    
    CGRect fromRect = [button.superview convertRect:button.frame toView:self.view];
    [popover presentPopoverFromRect:fromRect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    
    self.printerSelectorPopover = popover;
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
        [self.stepCompletionController setRightButtonDisabled:![self.stepContentController isValid]];
}

#pragma mark - TXHSaleStepsManagerDelegate

- (void)saleStepsManager:(TXHSaleStepsManager *)manager didChangeToStep:(id)step
{
    NSInteger index = [manager indexOfStep:step];
    if (index == 0) {
        [TXHORDERMANAGER resetOrder];
    }
    
    // update header
    [self.timeController setTitleText:step[kWizardStepTitleKey]];
    [self.timeController setTimerEndDate:[TXHORDERMANAGER expirationDate]];
    
    // update footer
    [self.stepCompletionController setLeftButtonHidden:[step[kWizardStepHidesLeftButton] boolValue]];
    [self.stepCompletionController setMiddleButtonHidden:[step[kWizardStepHidesMiddleButton] boolValue]];
    [self.stepCompletionController setRightButtonHidden:[step[kWizardStepHidesRightButton] boolValue]];
    
    [self.stepCompletionController setLeftButtonDisabled:[step[kWizardStepLeftButtonDisabled] boolValue]];
    [self.stepCompletionController setMiddleButtonDisabled:[step[kWizardStepMiddleButtonDisabled] boolValue]];
    [self.stepCompletionController setRightButtonDisabled:[step[kWizardStepRightButtonDisabled] boolValue]];
    
    [self.stepCompletionController setLeftButtonTitle:step[kWizardStepLeftButtonTitle]];
    [self.stepCompletionController setMiddleButtonTitle:step[kWizardStepMiddleButtonTitle]];
    [self.stepCompletionController setRightButtonTitle:step[kWizardStepRightButtonTitle]];
    
    [self.stepCompletionController setMiddleButtonImage:step[kWizardStepMiddleButtonImage]];
    [self.stepCompletionController setRightButtonImage:step[kWizardStepRightButtonImage]];
    
    [self.stepCompletionController setLeftBarButtonColor:step[kWizardStepLeftButtonColor]];
    
    // update content
    [self showStepContentControllerWithSegueID:step[kWizardStepControllerSegueID]];
    
    // update list
    [self.wizardSteps reloadWizard];
}

- (NSString *)continueButtonTitleForStep:(id)step fromManger:(TXHSaleStepsManager *)manager
{
    NSInteger index = [manager indexOfStep:step];
    id nextStep = [manager stepAtIndex:index + 1];
    
    NSString *nextStepFullTitle = nextStep[kWizardStepRightButtonTitle];

    return nextStepFullTitle;
}

- (void)showStepContentControllerWithSegueID:(NSString *)segueID
{
    [self performSegueWithIdentifier:segueID sender:self];
}

#pragma mark - TXHSalesCompletionViewControllerDelegate

- (void)salesCompletionViewControllerDidContinue:(TXHSalesCompletionViewController *)controller
{

}

- (void)salesCompletionViewController:(TXHSalesCompletionViewController *)controller didDidSelectLeftButton:(TXHBorderedButton *)button
{
    NSDictionary *step = [self.stepsManager currentStep];
    
    void (^block)(UIButton *button) = step[kWizardStepLeftButtonBlock];
    if (block) {
        block((UIButton *)button);
    }
    else
    {
        // default
        [self resetData];
    }
}

- (void)salesCompletionViewController:(TXHSalesCompletionViewController *)controller didDidSelectMiddleButton:(TXHBorderedButton *)button
{
    NSDictionary *step = [self.stepsManager currentStep];
    
    void (^block)(UIButton *button) = step[kWizardStepMiddleButtonBlock];
    if (block) {
        block((UIButton *)button);
    }
    else
    {
        // default
    }
}

- (void)salesCompletionViewController:(TXHSalesCompletionViewController *)controller didDidSelectRightButton:(TXHBorderedButton *)button
{
    NSDictionary *step = [self.stepsManager currentStep];
    
    void (^block)(UIButton *buttton) = step[kWizardStepRightButtonBlock];
    if (block) {
        block((UIButton *)button);
    }
    else
    {
        // default
        self.stepCompletionController.view.userInteractionEnabled = NO;
        [self.stepContentController finishStepWithCompletion:^(NSError *error) {
            if (!error)
            {
                [self.stepsManager continueToNextStep];
            }
            self.stepCompletionController.view.userInteractionEnabled = YES;
        }];
    }
}

#pragma mark - TXHPrinterSelectionViewControllerDelegate

- (void)txhPrinterSelectionViewController:(TXHPrinterSelectionViewController *)controller
                         didSelectPrinter:(TXHPrinter *)printer
{
    [self.printerSelectorPopover dismissPopoverAnimated:YES];
    self.printerSelectorPopover = nil;
    
    [self printSelectedTargetWithPrinter:printer];
}

- (void)printSelectedTargetWithPrinter:(TXHPrinter *)printer
{
    switch (self.printTarget) {
        case TXHPrintTargetRecipt:
        {
            [TXHORDERMANAGER downloadReciptWithWidth:printer.paperWidth
                                                 dpi:printer.dpi
                                          completion:^(NSURL *url, NSError *error) {
                                              if (!error)
                                              {
                                                  [printer printPDFDocument:url completion:^(NSError *error2) {
                                                      if (error2)
                                                      {
                                                          [self showErrorWithTitle:NSLocalizedString(@"PRINTER_ERROR_TITLE", nil)
                                                                           message:error2.localizedDescription];
                                                      }
                                                  }];
                                              }
                                              else
                                              {
                                                  [self showErrorWithTitle:NSLocalizedString(@"ERROR_TITLE", nil)
                                                                   message:error.localizedDescription];
                                              }
                                          }];
        }
            break;
        case TXHPrintTargetTickets:
            NSLog(@"Printing Tickets with %@",printer.displayName);
            break;

        default:
            break;
    }
}

- (void)showErrorWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertView *alertView =
    [[UIAlertView alloc] initWithTitle:title
                               message:message
                              delegate:nil
                     cancelButtonTitle:@"OK"
                     otherButtonTitles:nil];
    [alertView show];
}




@end
