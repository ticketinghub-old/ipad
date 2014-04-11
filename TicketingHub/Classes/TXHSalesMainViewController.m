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


// child controllers
#import "TXHSalesTimerViewController.h"
#import "TXHSalesCompletionViewController.h"
#import "TXHSalesWizardViewController.h"

// steps data
#import "TXHSalesStepAbstract.h"
#import "TXHSaleStepsManager.h"
#import "TXHOrderManager.h"

#import "TXHActivityLabelView.h"
#import "TXHActivityLabelPrintersUtilityDelegate.h"
#import "TXHPrinterSelectionViewController.h"
#import "TXHPrintersUtility.h"

#import "UIColor+TicketingHub.h"

// defines
#import "ProductListControllerNotifications.h"


static void * ContentValidContext = &ContentValidContext;


@interface TXHSalesMainViewController ()  <TXHSaleStepsManagerDelegate, TXHSalesCompletionViewControllerDelegate, TXHPrinterSelectionViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentsContainer;

@property (strong, nonatomic) TXHActivityLabelView *activityView;

@property (strong, nonatomic) TXHSalesWizardViewController           *wizardSteps;
@property (strong, nonatomic) TXHSalesTimerViewController            *timeController;
@property (strong, nonatomic) TXHSalesCompletionViewController       *stepCompletionController;
@property (strong, nonatomic) UIViewController<TXHSalesContentsViewControllerProtocol> *stepContentController;

@property (strong, nonatomic) TXHActivityLabelPrintersUtilityDelegate *printingUtilityDelegate;
@property (strong, nonatomic) TXHPrintersUtility                      *printingUtility;
@property (assign, nonatomic) TXHPrintType                            selectedPrintType;
@property (strong, nonatomic) UIPopoverController                     *printerSelectionPopover;

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
                                                                       kWizardStepMiddleButtonBlock : [self printReciptButtonActionBlock],
                                                                       kWizardStepRightButtonBlock  : [self printTicketsButtonActionBlock]
                                                                       }
                                                                     ]];
    
    self.stepsManager.delegate = self;
    
    [self resetData];
    
    [self registerForProductAndAvailabilityChanges];
    [self registerForKeyboardNotifications];
    [self registerForOrderExpirationNotifications];
}

- (void (^)(UIButton *button))printReciptButtonActionBlock
{
    __weak typeof(self) wself = self;
    return ^(UIButton *button){
        wself.selectedPrintType = TXHPrintTypeRecipt;
        [wself showPrinterSelectorFromButton:button];
    };
}

- (void (^)(UIButton *button))printTicketsButtonActionBlock
{
    __weak typeof(self) wself = self;
    return ^(UIButton *button){
        wself.selectedPrintType = TXHPrintTypeTickets;
        [wself showPrinterSelectorFromButton:button];
    };
}

- (void)showPrinterSelectorFromButton:(UIButton *)button
{
    TXHPrinterSelectionViewController *printerSelector = [[TXHPrinterSelectionViewController alloc] init];
    printerSelector.delegate = self;
    
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:printerSelector];
    popover.popoverContentSize = CGSizeMake(200, 110);
    
    CGRect fromRect = [button.superview convertRect:button.frame toView:self.view];
    
    [popover presentPopoverFromRect:fromRect
                             inView:self.view
           permittedArrowDirections:UIPopoverArrowDirectionAny
                           animated:YES];
    
    self.printerSelectionPopover = popover;
}

- (void)dealloc
{
    self.stepContentController = nil; // removing KVO observer
    
    [self unregisterForProductAndAvailabilityChanges];
    [self unregisterFromKeyboardNotifications];
    [self unregisterFromOrderExpirationNotifications];
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
    else if (([segue isMemberOfClass:[TXHEmbeddingSegue class]]))
    {
        TXHEmbeddingSegue *transitionSegue = (TXHEmbeddingSegue *)segue;
        transitionSegue.containerView      = self.contentsContainer;
        transitionSegue.previousController = self.stepContentController;
        
        self.stepContentController = segue.destinationViewController;
    }
}

#pragma mark - Accessors

-(void)setStepsManager:(TXHSaleStepsManager *)stepsManager
{
    _stepsManager = stepsManager;
    
    self.wizardSteps.dataSource = self.stepsManager;
}

- (TXHActivityLabelView *)activityView
{
    if (!_activityView)
    {
        TXHActivityLabelView *activityView = [TXHActivityLabelView getInstance];
        activityView.frame = self.navigationController.view.bounds;
        activityView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        [self.view addSubview:activityView];
        _activityView = activityView;
    }
    return _activityView;
}

- (TXHPrintersUtility *)printingUtility
{
    if (!_printingUtility)
    {
        TXHActivityLabelPrintersUtilityDelegate *printingUtilityDelegate =
        [TXHActivityLabelPrintersUtilityDelegate new];
        printingUtilityDelegate.activityView = self.activityView;

        TXHPrintersUtility *printingUtility = [[TXHPrintersUtility alloc] init];
        printingUtility.delegate = printingUtilityDelegate;
        
        _printingUtility = printingUtility;
        _printingUtilityDelegate = printingUtilityDelegate;
    }
    return _printingUtility;
}

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

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == ContentValidContext)
        [self.stepCompletionController setRightButtonDisabled:![self.stepContentController isValid]];
}

#pragma mark - notifications

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

- (void)registerForOrderExpirationNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orderDidExpire:)
                                                 name:TXHOrderDidExpireNotification object:nil];
}

- (void)unregisterFromOrderExpirationNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TXHOrderDidExpireNotification object:nil];
}

#pragma mark product/availability notifications

- (void)productDidChange:(NSNotification *)note
{
    [self resetData];
}

- (void)availabilityDidChange:(NSNotification *)note
{
    [self resetData];
}

#pragma mark - order expiration notification

- (void)orderDidExpire:(NSNotification *)note
{
    [self resetData];
}

#pragma mark - Keyboard notifications

- (void)keyboardWillShow:(NSNotification *)notification
{
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


#pragma mark - TXHSaleStepsManagerDelegate

- (void)saleStepsManager:(TXHSaleStepsManager *)manager didChangeToStep:(id)step
{
    NSInteger index = [manager indexOfStep:step];
    if (index == 0)
        [TXHORDERMANAGER resetOrder];
    
    if (![manager hasNextStep])
        [TXHORDERMANAGER stopExpirationTimer];
    
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

- (void)salesCompletionViewController:(TXHSalesCompletionViewController *)controller didDidSelectLeftButton:(TXHBorderedButton *)button
{
    NSDictionary *step = [self.stepsManager currentStep];
    
    void (^block)(UIButton *button) = step[kWizardStepLeftButtonBlock];
    if (block)
        block((UIButton *)button);
    else
    {
        [self resetData];
    }
}

- (void)salesCompletionViewController:(TXHSalesCompletionViewController *)controller didDidSelectMiddleButton:(TXHBorderedButton *)button
{
    NSDictionary *step = [self.stepsManager currentStep];
    
    void (^block)(UIButton *button) = step[kWizardStepMiddleButtonBlock];
    if (block)
        block((UIButton *)button);
    else
    {
    }
}

- (void)salesCompletionViewController:(TXHSalesCompletionViewController *)controller didDidSelectRightButton:(TXHBorderedButton *)button
{
    NSDictionary *step = [self.stepsManager currentStep];
    
    __weak typeof(self) wself = self;
    void (^block)(UIButton *buttton) = step[kWizardStepRightButtonBlock];
    
    if (block)
        block((UIButton *)button);
    else
    {
        self.stepCompletionController.view.userInteractionEnabled = NO;
        [self.stepContentController finishStepWithCompletion:^(NSError *error) {
            if (!error)
            {
                [wself.stepsManager continueToNextStep];
            }
            wself.stepCompletionController.view.userInteractionEnabled = YES;
        }];
    }
}

#pragma mark - TXHPrinterSelectionViewControllerDelegate

- (void)txhPrinterSelectionViewController:(TXHPrinterSelectionViewController *)controller
                         didSelectPrinter:(TXHPrinter *)printer
{
    [self.printerSelectionPopover dismissPopoverAnimated:YES];
    self.printerSelectionPopover = nil;

    [self.printingUtility startPrintingWithType:self.selectedPrintType onPrinter:printer withOrder:[TXHORDERMANAGER order]];
}


@end
