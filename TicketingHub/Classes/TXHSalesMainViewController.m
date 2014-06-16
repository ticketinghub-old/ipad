 //
//  TXHSalesMainViewController.m
//  TicketingHub
//
//  Created by Mark on 08/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesMainViewController.h"
#import <UIViewController+BHTKeyboardAnimationBlocks/UIViewController+BHTKeyboardNotifications.h>

// segues
#import "TXHEmbeddingSegue.h"

// child controllers
#import "TXHSalesCompletionViewController.h"
#import "TXHSalesWizardViewController.h"

// steps data
#import "TXHSalesStep.h"
#import "TXHSalesStepsManager.h"
#import "TXHOrderManager.h"
#import "TXHProductsManager.h"
#import "TXHPrintersManager.h"

#import <Block-KVO/MTKObserving.h>

#import "TXHActivityLabelView.h"
#import "TXHActivityLabelPrintersUtilityDelegate.h"
#import "TXHPrinterSelectionViewController.h"
#import "TXHPrintersUtility.h"

#import "UIColor+TicketingHub.h"
#import "UIFont+TicketingHub.h"

// defines
#import "TXHProductsManagerNotifications.h"

static void * ContentValidContext = &ContentValidContext;

@interface TXHSalesMainViewController ()  <TXHSaleStepsManagerDelegate, TXHSalesCompletionViewControllerDelegate, TXHPrinterSelectionViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentsContainer;

@property (strong, nonatomic) TXHActivityLabelView *activityView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentContainerTopConstraint;

@property (strong, nonatomic) TXHSalesWizardViewController           *wizardSteps;
@property (strong, nonatomic) TXHSalesCompletionViewController       *stepCompletionController;
@property (strong, nonatomic) UIViewController<TXHSalesContentsViewControllerProtocol> *stepContentController;

@property (strong, nonatomic) TXHActivityLabelPrintersUtilityDelegate *printingUtilityDelegate;
@property (strong, nonatomic) TXHPrintersUtility                      *printingUtility;
@property (assign, nonatomic) TXHPrintType                            selectedPrintType;
@property (strong, nonatomic) UIPopoverController                     *printerSelectionPopover;

@property (strong, nonatomic) NSTimer *timer;

@property (assign, nonatomic) BOOL contentControllerValid;
@property (assign, nonatomic) BOOL contentControllerShouldBeSkiped;

// data
@property (strong, nonatomic) TXHSalesStepsManager *stepsManager;

@end

@implementation TXHSalesMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupStepsManager];
    [self setupKeyboardAnimations];
    
    [self registerForProductChanges];
    [self registerForOrderManagerNotifications];
    
    [self resetData];
}

- (void)setupStepsManager
{
    
    TXHSalesStep *step1 = [[TXHSalesStep alloc] initWithDictionary:
                           @{kWizardStepTitleKey                : NSLocalizedString(@"SALESMAN_STEPS_TICKET_QUANTITY_TITLE",nil),
                             kWizardStepDescriptionKey          : NSLocalizedString(@"SALESMAN_STEPS_TICKET_QUANTITY_DESC",nil),
                             kWizardStepContinueTitleKey        : NSLocalizedString(@"SALESMAN_STEPS_TICKET_QUANTITY_CONTINUE_TITLE",nil),
                             kWizardStepLeftButtonTitle         : NSLocalizedString(@"SALESMAN_STEPS_CANCEL_ORDER_BUTTON_TITLE",nil),
                             kWizardStepControllerSegueID       : @"Tickets Quantity",
                             kWizardStepHidesLeftButton         : @YES,
                             kWizardStepHidesRightButton        : @YES,
                             kWizardStepHidesMiddleLeftButton   : @YES,
                             kWizardStepHidesMiddleRightButton  : @YES}];

    TXHSalesStep *step2 = [[TXHSalesStep alloc] initWithDictionary:
                           @{kWizardStepTitleKey                : NSLocalizedString(@"SALESMAN_STEPS_TICKET_DATES_TITLE",nil),
                             kWizardStepDescriptionKey          : NSLocalizedString(@"SALESMAN_STEPS_TICKET_UDATES_DESC",nil),
                             kWizardStepContinueTitleKey        : NSLocalizedString(@"SALESMAN_STEPS_TICKETDATES_CONTINUE_TITLE",nil),
                             kWizardStepLeftButtonTitle         : NSLocalizedString(@"SALESMAN_STEPS_CANCEL_ORDER_BUTTON_TITLE",nil),
                             kWizardStepControllerSegueID       : @"Tickets Dates",
                             kWizardStepHidesRightButton        : @YES,
                             kWizardStepHidesLeftButton         : @YES,
                             kWizardStepHidesMiddleLeftButton   : @YES,
                             kWizardStepHidesMiddleRightButton  : @YES}];
    
    TXHSalesStep *step3 = [[TXHSalesStep alloc] initWithDictionary:
                           @{kWizardStepTitleKey                : NSLocalizedString(@"SALESMAN_STEPS_TICKET_UPGRADES_TITLE",nil),
                             kWizardStepDescriptionKey          : NSLocalizedString(@"SALESMAN_STEPS_TICKET_UPGRADES_DESC",nil),
                             kWizardStepContinueTitleKey        : NSLocalizedString(@"SALESMAN_STEPS_TICKET_UPGRADES_CONTINUE_TITLE",nil),
                             kWizardStepLeftButtonTitle         : NSLocalizedString(@"SALESMAN_STEPS_CANCEL_ORDER_BUTTON_TITLE",nil),
                             kWizardStepControllerSegueID       : @"Tickets Upgrades",
                             kWizardStepHidesRightButton        : @YES,
                             kWizardStepHidesMiddleLeftButton   : @YES,
                             kWizardStepHidesMiddleRightButton  : @YES}];
    
    TXHSalesStep *step4 = [[TXHSalesStep alloc] initWithDictionary:
                           @{kWizardStepTitleKey                : NSLocalizedString(@"SALESMAN_STEPS_ORDER_SUMMARY_TITLE",nil),
                             kWizardStepDescriptionKey          : NSLocalizedString(@"SALESMAN_STEPS_ORDER_SUMMARY_DESC",nil),
                             kWizardStepContinueTitleKey        : NSLocalizedString(@"SALESMAN_STEPS_ORDER_SUMMARY_CONTINUE_TITLE",nil),
                             kWizardStepLeftButtonTitle         : NSLocalizedString(@"SALESMAN_STEPS_CANCEL_ORDER_BUTTON_TITLE",nil),
                             kWizardStepControllerSegueID       : @"Order Summary",
                             kWizardStepHidesRightButton        : @YES,
                             kWizardStepHidesMiddleLeftButton   : @YES,
                             kWizardStepHidesMiddleRightButton  : @YES}];
    
    TXHSalesStep *step5 = [[TXHSalesStep alloc] initWithDictionary:
                           @{kWizardStepTitleKey                : NSLocalizedString(@"SALESMAN_STEPS_PAYMENT_TITLE",nil),
                             kWizardStepDescriptionKey          : NSLocalizedString(@"SALESMAN_STEPS_PAYMENT_DESC",nil),
                             kWizardStepContinueTitleKey        : NSLocalizedString(@"SALESMAN_STEPS_PAYMENT_CONTINUE_TITLE",nil),
                             kWizardStepLeftButtonTitle         : NSLocalizedString(@"SALESMAN_STEPS_CANCEL_ORDER_BUTTON_TITLE",nil),
                             kWizardStepControllerSegueID       : @"Payment",
                             kWizardStepHidesRightButton        : @YES,
                             kWizardStepHidesMiddleLeftButton   : @YES,
                             kWizardStepHidesMiddleRightButton  : @YES}];
    
    TXHSalesStep *step6 = [[TXHSalesStep alloc] initWithDictionary:
                           @{kWizardStepTitleKey                : NSLocalizedString(@"SALESMAN_STEPS_SUMMARY_TITLE",nil),
                             kWizardStepDescriptionKey          : NSLocalizedString(@"SALESMAN_STEPS_SUMMARY_DESC",nil),
                             kWizardStepContinueTitleKey        : NSLocalizedString(@"SALESMNA_STEPS_SUMMARY_CONTINUE_TITLE",nil),
                             kWizardStepRightButtonTitle        : NSLocalizedString(@"SALESMAN_STEPS_SUMMARY_RIGHT_BUTTON_TITLE",nil),
                             kWizardStepMiddleLeftButtonTitle   : NSLocalizedString(@"SALESMAN_STEPS_SUMMARY_MIDDLE_LEFT_BUTTON_TITLE",nil),
                             kWizardStepMiddleRightButtonTitle  : NSLocalizedString(@"SALESMAN_STEPS_SUMMARY_MIDDLE_RIGHT_BUTTON_TITLE",nil),
                             kWizardStepControllerSegueID       : @"Order Completion",
                             kWizardStepHidesMiddleButton       : @YES,
                             kWizardStepHidesLeftButton         : @YES,
                             kWizardStepHidesStepsList          : @YES,
                             kWizardStepMiddleLeftButtonBlock   : [self printReciptButtonActionBlock],
                             kWizardStepMiddleRightButtonBlock  : [self printTicketsButtonActionBlock],
                             kWizardStepRightButtonBlock        : [self resetDataActionBlock]}];
    
    self.stepsManager = [[TXHSalesStepsManager alloc] initWithSteps:@[step1, step2, step3, step4, step5, step6]];
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
    [self removeAllObservations];
    
    [self unregisterForProductChanges];
    [self unregisterFromOrderManagerNotifications];
}

- (void)resetData
{
    [self.orderManager resetOrder];
    [self.stepsManager resetProcess];
    
    self.navigationItem.rightBarButtonItem = nil;

}

- (void (^)(UIButton *button))resetDataActionBlock
{
    __weak typeof(self) wself = self;
    return ^(UIButton *button){
        [wself resetData];
    };
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Embed Steps"])
    {
        self.wizardSteps = segue.destinationViewController;
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
    [self willChangeValueForKey:@"stepContentController"];
    _stepContentController = stepContentController;
    [self didChangeValueForKey:@"stepContentController"];
    
    [self removeAllObservations];
    
    [self map:@keypath(self.stepContentController.valid) to:@keypath(self.contentControllerValid) null:nil];
    [self map:@keypath(self.stepContentController.shouldBeSkiped) to:@keypath(self.contentControllerShouldBeSkiped) null:nil];

    self.contentControllerValid          = [self.stepContentController isValid];
    self.contentControllerShouldBeSkiped = [self.stepContentController shouldBeSkiped];
}

#pragma mark - KVO

-(void)setContentControllerValid:(BOOL)contentControllerValid
{
    _contentControllerValid = contentControllerValid;
    
    [self.stepCompletionController setMiddleButtonDisabled:![self.stepContentController isValid]];
}

- (void)setContentControllerShouldBeSkiped:(BOOL)contentControllerShouldBeSkiped
{
    _contentControllerShouldBeSkiped = contentControllerShouldBeSkiped;
    
    if (contentControllerShouldBeSkiped)
        [self continueToNextStep];
}


#pragma mark - notifications

- (void)registerForProductChanges
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(productDidChange:)
                                                 name:TXHProductsChangedNotification
                                               object:nil];
}

- (void)unregisterForProductChanges
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TXHProductsChangedNotification object:nil];
}

- (void)registerForOrderManagerNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orderDidExpire:)
                                                 name:TXHOrderDidExpireNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orderDidChange:)
                                                 name:TXHOrderDidChangeNotification object:nil];
}

- (void)unregisterFromOrderManagerNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TXHOrderDidExpireNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TXHOrderDidChangeNotification object:nil];

}

#pragma mark product notifications

- (void)productDidChange:(NSNotification *)note
{
    [self resetData];
}

#pragma mark - order expiration notification

- (void)orderDidExpire:(NSNotification *)note
{
    [self resetData];
}


- (void)orderDidChange:(NSNotification *)note
{
    TXHOrder *order = self.orderManager.order;
    __weak typeof(self) wself = self;
    if (order && !order.confirmedAt && !self.timer)
    {
        NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:wself selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        self.timer = timer;
    }
    else if (!order)
    {
        [self.timer invalidate];
        self.timer = nil;
        
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)timerFireMethod:(NSTimer *)timer
{
    NSTimeInterval interval = 10*60 + [self.orderManager.order.createdAt timeIntervalSinceNow];
    interval = interval < 0 ? 0 : interval;
    NSString *timeString = [self stringFromTimeInterval:interval];
    
    UIImage *timerIcon = [UIImage imageNamed:@"timer_icon"];
    
    UIButton *timerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [timerButton.titleLabel setFont:[UIFont txhThinFontWithSize:18.0]];
    [timerButton setAdjustsImageWhenHighlighted:NO];
    [timerButton setImage:timerIcon forState:UIControlStateNormal];
    [timerButton setTitle:timeString forState:UIControlStateNormal];
    timerButton.frame = (CGRect) {
        .size.width = 100,
        .size.height = 30,
    };
    
    UIBarButtonItem *barButton= [[UIBarButtonItem alloc] initWithCustomView:timerButton];
    
    self.navigationItem.rightBarButtonItem = barButton;
}

- (NSString *)stringFromTimeInterval:(NSTimeInterval)interval
{
    NSInteger ti = (NSInteger)interval;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    return [NSString stringWithFormat:@"  %02ld:%02ld", (long)minutes, (long)seconds];
}

#pragma mark - TXHSaleStepsManagerDelegate

- (void)saleStepsManager:(TXHSalesStepsManager *)manager didChangeToStep:(TXHSalesStep *)step
{
    NSInteger index = [manager indexOfStep:step];
    NSString *middleButtonTitle = [self continueButtonTitleForStep:step fromManger:manager];

    if (index == 0)
        [self.orderManager resetOrder];
    
    if (![manager hasNextStep])
    {
        [self.orderManager stopExpirationTimer];
        middleButtonTitle = step.middleButtonTitle;
    }

    // update footer
    [self.stepCompletionController setLeftButtonHidden:step.hasLeftButtonHidden];
    [self.stepCompletionController setMiddleLeftButtonHidden:step.hasMiddleLeftButtonHidden];
    [self.stepCompletionController setMiddleButtonHidden:step.hasMiddleButtonHidden];
    [self.stepCompletionController setMiddleRightButtonHidden:step.hasMiddleRightButtonHidden];
    [self.stepCompletionController setRightButtonHidden:step.hasRightButtonHidden];
    
    [self.stepCompletionController setLeftButtonDisabled:step.hasLeftButtonDisabled];
    [self.stepCompletionController setMiddleLeftButtonDisabled:step.hasMiddleLeftButtonDisabled];
    [self.stepCompletionController setMiddleButtonDisabled:step.hasMiddleButtonDisabled];
    [self.stepCompletionController setMiddleRightButtonDisabled:step.hasMiddleRightButtonDisabled];
    [self.stepCompletionController setRightButtonDisabled:step.hasRightButtonHidden];
    
    [self.stepCompletionController setLeftButtonTitle:step.leftButtonTitle];
    [self.stepCompletionController setMiddleLeftButtonTitle:step.middleLeftButtonTitle];
    [self.stepCompletionController setMiddleButtonTitle:middleButtonTitle];
    [self.stepCompletionController setMiddleRightButtonTitle:step.middleRightButtonTitle];
    [self.stepCompletionController setRightButtonTitle:step.rightButtonTitle];
    
    self.contentContainerTopConstraint.constant = step.shouldHideStepsList ? 0 : self.wizardSteps.view.height;
    
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

- (void)continueToNextStep
{
    [self.stepCompletionController setButtonsDisabled:YES];
    [self.stepContentController finishStepWithCompletion:^(NSError *error) {
        if (!error)
            [self.stepsManager continueToNextStep];
        else
            [self.stepCompletionController setButtonsDisabled:NO];
    }];
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

- (void)salesCompletionViewController:(TXHSalesCompletionViewController *)controller didDidSelectMiddleLeftButton:(TXHBorderedButton *)button
{
    TXHSalesStep *step = [self.stepsManager currentStep];
    
    void (^block)(UIButton *button) = step.middleLeftButtonActionBlock;
    if (block)
        block((UIButton *)button);
    else
    {
    }
}

- (void)salesCompletionViewController:(TXHSalesCompletionViewController *)controller didDidSelectMiddleButton:(TXHBorderedButton *)button
{
    TXHSalesStep *step = [self.stepsManager currentStep];
    
    __weak typeof(self) wself = self;

    void (^block)(UIButton *button) = step.middleButtonActionBlock;
    if (block)
        block((UIButton *)button);
    else
    {
        [wself continueToNextStep];
    }
}

- (void)salesCompletionViewController:(TXHSalesCompletionViewController *)controller didDidSelectMiddleRightButton:(TXHBorderedButton *)button
{
    TXHSalesStep *step = [self.stepsManager currentStep];
    
    void (^block)(UIButton *button) = step.middleRightButtonActionBlock;
    if (block)
        block((UIButton *)button);
    else
    {
    }
}

- (void)salesCompletionViewController:(TXHSalesCompletionViewController *)controller didDidSelectRightButton:(TXHBorderedButton *)button
{
    TXHSalesStep *step = [self.stepsManager currentStep];
    
    void (^block)(UIButton *buttton) = step.rightButtonActionBlock;
    
    if (block)
        block((UIButton *)button);
    else
    {
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
