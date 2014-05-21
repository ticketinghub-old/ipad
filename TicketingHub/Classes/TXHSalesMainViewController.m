 //
//  TXHSalesMainViewController.m
//  TicketingHub
//
//  Created by Mark on 08/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesMainViewController.h"
#import "UIViewController+BHTKeyboardNotifications.h"

// segues
#import "TXHEmbeddingSegue.h"

// child controllers
#import "TXHSalesTimerViewController.h"
#import "TXHSalesCompletionViewController.h"
#import "TXHSalesWizardViewController.h"

// steps data
#import "TXHSalesStep.h"
#import "TXHSalesStepsManager.h"
#import "TXHOrderManager.h"
#import "TXHProductsManager.h"
#import "TXHPrintersManager.h"

#import "TXHActivityLabelView.h"
#import "TXHActivityLabelPrintersUtilityDelegate.h"
#import "TXHPrinterSelectionViewController.h"
#import "TXHPrintersUtility.h"

#import "UIColor+TicketingHub.h"

// defines
#import "TXHProductsManagerNotifications.h"

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
@property (strong, nonatomic) TXHSalesStepsManager *stepsManager;

@end

@implementation TXHSalesMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupStepsManager];
    [self setupKeyboardAnimations];
    
    [self registerForProductAndAvailabilityChanges];
    [self registerForOrderExpirationNotifications];
    
    [self resetData];
}

- (void)setupStepsManager
{
    
    TXHSalesStep *step1 = [[TXHSalesStep alloc] initWithDictionary:
                           @{kWizardStepTitleKey          : NSLocalizedString(@"SALESMAN_STEPS_TICKET_QUANTITY_TITLE",nil),
                             kWizardStepDescriptionKey    : NSLocalizedString(@"SALESMAN_STEPS_TICKET_QUANTITY_DESC",nil),
                             kWizardStepContinueTitleKey  : NSLocalizedString(@"SALESMAN_STEPS_TICKET_QUANTITY_CONTINUE_TITLE",nil),
                             kWizardStepLeftButtonTitle   : NSLocalizedString(@"SALESMAN_STEPS_CANCEL_ORDER_BUTTON_TITLE",nil),
                             kWizardStepControllerSegueID : @"Tickets Quantity",
                             kWizardStepHidesLeftButton   : @YES,
                             kWizardStepHidesMiddleButton : @YES,
                             kWizardStepLeftButtonColor   : [UIColor redColor],
                             kWizardStepRightButtonImage  : [UIImage imageNamed:@"right-arrow"]}];
    
    TXHSalesStep *step2 = [[TXHSalesStep alloc] initWithDictionary:
                           @{kWizardStepTitleKey          : NSLocalizedString(@"SALESMAN_STEPS_TICKET_UPGRADES_TITLE",nil),
                             kWizardStepDescriptionKey    : NSLocalizedString(@"SALESMAN_STEPS_TICKET_UPGRADES_DESC",nil),
                             kWizardStepContinueTitleKey  : NSLocalizedString(@"SALESMAN_STEPS_TICKET_UPGRADES_CONTINUE_TITLE",nil),
                             kWizardStepLeftButtonTitle   : NSLocalizedString(@"SALESMAN_STEPS_CANCEL_ORDER_BUTTON_TITLE",nil),
                             kWizardStepControllerSegueID : @"Tickets Upgrades",
                             kWizardStepHidesMiddleButton : @YES,
                             kWizardStepLeftButtonColor   : [UIColor redColor],
                             kWizardStepRightButtonImage  : [UIImage imageNamed:@"right-arrow"]}];
    
    TXHSalesStep *step3 = [[TXHSalesStep alloc] initWithDictionary:
                           @{kWizardStepTitleKey          : NSLocalizedString(@"SALESMAN_STEPS_ORDER_SUMMARY_TITLE",nil),
                             kWizardStepDescriptionKey    : NSLocalizedString(@"SALESMAN_STEPS_ORDER_SUMMARY_DESC",nil),
                             kWizardStepContinueTitleKey  : NSLocalizedString(@"SALESMAN_STEPS_ORDER_SUMMARY_CONTINUE_TITLE",nil),
                             kWizardStepLeftButtonTitle   : NSLocalizedString(@"SALESMAN_STEPS_CANCEL_ORDER_BUTTON_TITLE",nil),
                             kWizardStepControllerSegueID : @"Order Summary",
                             kWizardStepHidesMiddleButton : @YES,
                             kWizardStepLeftButtonColor   : [UIColor redColor],
                             kWizardStepRightButtonImage  : [UIImage imageNamed:@"right-arrow"]}];
    
    TXHSalesStep *step4 = [[TXHSalesStep alloc] initWithDictionary:
                           @{kWizardStepTitleKey          : NSLocalizedString(@"SALESMAN_STEPS_PAYMENT_TITLE",nil),
                             kWizardStepDescriptionKey    : NSLocalizedString(@"SALESMAN_STEPS_PAYMENT_DESC",nil),
                             kWizardStepContinueTitleKey  : NSLocalizedString(@"SALESMAN_STEPS_PAYMENT_CONTINUE_TITLE",nil),
                             kWizardStepLeftButtonTitle   : NSLocalizedString(@"SALESMAN_STEPS_CANCEL_ORDER_BUTTON_TITLE",nil),
                             kWizardStepControllerSegueID : @"Payment",
                             kWizardStepHidesMiddleButton : @YES,
                             kWizardStepLeftButtonColor   : [UIColor redColor],
                             kWizardStepRightButtonImage  : [UIImage imageNamed:@"right-arrow"]}];
    
    TXHSalesStep *step5 = [[TXHSalesStep alloc] initWithDictionary:
                           @{kWizardStepTitleKey          : NSLocalizedString(@"SALESMAN_STEPS_SUMMARY_TITLE",nil),
                             kWizardStepDescriptionKey    : NSLocalizedString(@"SALESMAN_STEPS_SUMMARY_DESC",nil),
                             kWizardStepContinueTitleKey  : NSLocalizedString(@"SALESMNA_STEPS_SUMMARY_CONTINUE_TITLE",nil),
                             kWizardStepLeftButtonTitle   : NSLocalizedString(@"SALESMAN_STEPS_SUMMARY_LEFT_BUTTON_TITLE",nil),
                             kWizardStepMiddleButtonTitle : NSLocalizedString(@"SALESMAN_STEPS_SUMMARY_MIDDLE_BUTTON_TITLE",nil),
                             kWizardStepRightButtonTitle  : NSLocalizedString(@"SALESMAN_STEPS_SUMMARY_RIGHT_BUTTON_TITLE",nil),
                             kWizardStepControllerSegueID : @"Order Completion",
                             kWizardStepLeftButtonColor   : [UIColor txhBlueColor],
                             kWizardStepMiddleButtonImage : [UIImage imageNamed:@"printer-icon"],
                             kWizardStepRightButtonImage  : [UIImage imageNamed:@"printer-icon"],
                             kWizardStepMiddleButtonBlock : [self printReciptButtonActionBlock],
                             kWizardStepRightButtonBlock  : [self printTicketsButtonActionBlock]}];
    
    self.stepsManager = [[TXHSalesStepsManager alloc] initWithSteps:@[step1, step2, step3, step4, step5]];
    self.stepsManager.delegate = self;
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
    TXHPrinterSelectionViewController *printerSelector = [[TXHPrinterSelectionViewController alloc] initWithPrintersManager:TXHPRINTERSMANAGER];
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

- (void)setupKeyboardAnimations
{
    __weak typeof(self) wself = self;
    
    [self setKeyboardWillShowAnimationBlock:^(CGRect keyboardFrame) {
        if ([wself.stepContentController respondsToSelector:@selector(setOffsetBottomBy:)])
        {
            CGFloat height = keyboardFrame.size.width - wself.stepCompletionController.view.height;
            [wself.stepContentController setOffsetBottomBy:height];
        }
    }];
    
    [self setKeyboardWillHideAnimationBlock:^(CGRect keyboardFrame) {
        if ([wself.stepContentController respondsToSelector:@selector(setOffsetBottomBy:)])
            [wself.stepContentController setOffsetBottomBy:0];
    }];
}

- (void)dealloc
{
    self.stepContentController = nil; // removing KVO observer
    
    [self unregisterForProductAndAvailabilityChanges];
    [self unregisterFromOrderExpirationNotifications];
}

- (void)resetData
{
    [self.orderManager resetOrder];
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
        
        UIViewController<TXHSalesContentsViewControllerProtocol> *contentController = segue.destinationViewController;
        
        contentController.productManager = self.productManager;
        contentController.orderManager   = self.orderManager;
        
        self.stepContentController = contentController;
    }
}

#pragma mark - Accessors

-(void)setStepsManager:(TXHSalesStepsManager *)stepsManager
{
    _stepsManager = stepsManager;
    
    self.wizardSteps.dataSource = self.stepsManager;
}

- (TXHActivityLabelView *)activityView
{
    if (!_activityView)
    {
        _activityView = [TXHActivityLabelView getInstanceInView:self.view];
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

        TXHPrintersUtility *printingUtility = [[TXHPrintersUtility alloc] initWithTicketingHubCLient:self.productManager.txhManager.client];
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
                                                 name:TXHProductsChangedNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(availabilityDidChange:)
                                                 name:TXHAvailabilityChangedNotification
                                               object:nil];
}

- (void)unregisterForProductAndAvailabilityChanges
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TXHProductsChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TXHAvailabilityChangedNotification object:nil];
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

#pragma mark - TXHSaleStepsManagerDelegate

- (void)saleStepsManager:(TXHSalesStepsManager *)manager didChangeToStep:(TXHSalesStep *)step
{
    NSInteger index = [manager indexOfStep:step];
    NSString *rightButtonTitle = [self continueButtonTitleForStep:step fromManger:manager];

    if (index == 0)
        [self.orderManager resetOrder];
    
    if (![manager hasNextStep])
    {
        [self.orderManager stopExpirationTimer];
        rightButtonTitle = step.rightButtonTitle;
    }
    
    // update header
    [self.timeController setTitleText:step.title];
    [self.timeController setTimerEndDate:[self.orderManager expirationDate]];
    
    // update footer
    [self.stepCompletionController setLeftButtonHidden:step.hasLeftButtonHidden];
    [self.stepCompletionController setMiddleButtonHidden:step.hasMiddleButtonHidden];
    [self.stepCompletionController setRightButtonHidden:step.hasRightButtonHidden];
    
    [self.stepCompletionController setLeftButtonDisabled:step.hasLeftButtonDisabled];
    [self.stepCompletionController setMiddleButtonDisabled:step.hasMiddleButtonDisabled];
    [self.stepCompletionController setRightButtonDisabled:step.hasRightButtonHidden];
    
    [self.stepCompletionController setLeftButtonTitle:step.leftButtonTitle];
    [self.stepCompletionController setMiddleButtonTitle:step.middleButtonTitle];
    [self.stepCompletionController setRightButtonTitle:rightButtonTitle];
    
    [self.stepCompletionController setMiddleButtonImage:step.middleButtonImage];
    [self.stepCompletionController setRightButtonImage:step.rightButtonImage];
    
    [self.stepCompletionController setLeftBarButtonColor:step.leftButtonColor];
    
    // update content
    [self showStepContentControllerWithSegueID:step.segueID];
    
    // update list
    [self.wizardSteps reloadWizard];
}

- (NSString *)continueButtonTitleForStep:(TXHSalesStep *)step fromManger:(TXHSalesStepsManager *)manager
{
    NSInteger index = [manager indexOfStep:step];
    TXHSalesStep *nextStep = [manager stepAtIndex:index + 1];
    
    NSString *nextStepContinueTitle = nextStep.continueTitle;
    
    return nextStepContinueTitle;
}

- (void)showStepContentControllerWithSegueID:(NSString *)segueID
{
    [self performSegueWithIdentifier:segueID sender:self];
}

#pragma mark - TXHSalesCompletionViewControllerDelegate

- (void)salesCompletionViewController:(TXHSalesCompletionViewController *)controller didDidSelectLeftButton:(TXHBorderedButton *)button
{
    TXHSalesStep *step = [self.stepsManager currentStep];
    
    void (^block)(UIButton *button) = step.leftButtonActionBlock;
    if (block)
        block((UIButton *)button);
    else
    {
        [self resetData];
    }
}

- (void)salesCompletionViewController:(TXHSalesCompletionViewController *)controller didDidSelectMiddleButton:(TXHBorderedButton *)button
{
    TXHSalesStep *step = [self.stepsManager currentStep];
    
    void (^block)(UIButton *button) = step.middleButtonActionBlock;
    if (block)
        block((UIButton *)button);
    else
    {
    }
}

- (void)salesCompletionViewController:(TXHSalesCompletionViewController *)controller didDidSelectRightButton:(TXHBorderedButton *)button
{
    TXHSalesStep *step = [self.stepsManager currentStep];
    
    __weak typeof(self) wself = self;
    
    void (^block)(UIButton *buttton) = step.rightButtonActionBlock;
    
    if (block)
        block((UIButton *)button);
    else
    {
        [self.stepCompletionController setButtonsDisabled:YES];
        [self.stepContentController finishStepWithCompletion:^(NSError *error) {
            if (!error)
                [wself.stepsManager continueToNextStep];
        
            [wself.stepCompletionController setButtonsDisabled:NO];
        }];
    }
}

#pragma mark - TXHPrinterSelectionViewControllerDelegate

- (void)txhPrinterSelectionViewController:(TXHPrinterSelectionViewController *)controller
                         didSelectPrinter:(TXHPrinter *)printer
{
    [self.printerSelectionPopover dismissPopoverAnimated:YES];
    self.printerSelectionPopover = nil;

    [self.printingUtility startPrintingWithType:self.selectedPrintType onPrinter:printer withOrder:[self.orderManager order]];
}


@end
