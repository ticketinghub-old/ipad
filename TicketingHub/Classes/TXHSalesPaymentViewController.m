//
//  TXHSalesPaymentViewController.m
//  TicketingHub
//
//  Created by Mark on 14/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesPaymentViewController.h"

#import "TXHPaymentOptionsManager.h"
#import "TXHPaymentOption.h"

#import "TXHSalesPaymentContentViewControllerProtocol.h"

#import "TXHProductsManager.h"
#import "TXHOrderManager.h"

#import "TXHEmbeddingSegue.h"
#import <PPiFlatSegmentedControl/PPiFlatSegmentedControl.h>     // This is shit! but im in a rush...
#import "TXHActivityLabelView.h"
#import <Block-KVO/MTKObserving.h>
#import "UIColor+TicketingHub.h"
#import "UIFont+TicketingHub.h"


@interface TXHSalesPaymentViewController () <UICollectionViewDelegateFlowLayout>

@property (readwrite, nonatomic, getter = isValid) BOOL valid;

@property (weak, nonatomic) TXHActivityLabelView *activityView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet PPiFlatSegmentedControl *paymentTypeSegmentedControl;

@property (strong, nonatomic) UIViewController<TXHSalesPaymentContentViewControllerProtocol> *paymentDetailsController;
@property (strong, nonatomic) TXHPaymentOptionsManager *paymentOptionsManager;
@property (strong, nonatomic) TXHPaymentOption         *selectedPaymentOption;


@end

@implementation TXHSalesPaymentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupOptionsManger];
    [self reloadOptions];
}

- (void)setupOptionsManger
{
    TXHPaymentOptionsManager *optionsManager = [[TXHPaymentOptionsManager alloc] initWithOrderManager:self.orderManager];
    self.paymentOptionsManager = optionsManager;
}

- (void)reloadOptions
{
    __weak typeof(self) wself = self;
    
    [self.activityView showWithMessage:@"" indicatorHidden:NO];
    [self.paymentOptionsManager loadPaymentOptionsWithCompletion:^(NSArray *paymentOptions, NSError *error) {

        [wself.activityView hide];

        wself.selectedPaymentOption = [paymentOptions firstObject];
        
        [wself reloadView];
        
        if (error)
        {
            // TODO: handle error
            return;
        }
    }];
}

- (void)reloadView
{
    [self reloadSegmentedControl];
    [self reloadSelectedController];
}

- (void)reloadSegmentedControl
{
    NSArray *paymentNames = [self payentOptionDisplayNames];
    
    __weak typeof(self) wself = self;
    
    selectionBlock selectionBlock = ^(NSUInteger segmentIndex) {
        wself.selectedPaymentOption = [wself.paymentOptionsManager paymentOptionsAtIndex:segmentIndex];
    };
    
    PPiFlatSegmentedControl *segmentedControl = [[PPiFlatSegmentedControl alloc] initWithFrame:self.paymentTypeSegmentedControl.frame
                                                                                         items:paymentNames
                                                                                  iconPosition:IconPositionLeft
                                                                             andSelectionBlock:selectionBlock
                                                                                iconSeparation:0.0];

    segmentedControl.layer.cornerRadius = 15.0f;
    segmentedControl.borderWidth        = 2.0f;
    segmentedControl.color              = [UIColor whiteColor];
    segmentedControl.borderColor        = [UIColor txhBlueColor];
    segmentedControl.selectedColor      = [UIColor txhBlueColor];

    segmentedControl.textAttributes         = @{NSFontAttributeName:[UIFont txhThinFontWithSize:25.0f],
                                                NSForegroundColorAttributeName:[UIColor txhBlueColor]};
    segmentedControl.selectedTextAttributes = @{NSFontAttributeName:[UIFont txhThinFontWithSize:25.0f],
                                                NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    [self.view addSubview:segmentedControl];
    
    [self.paymentTypeSegmentedControl removeFromSuperview];
    self.paymentTypeSegmentedControl = segmentedControl;

    self.paymentTypeSegmentedControl.hidden = [paymentNames count] == 0;
}

- (void)setSelectedPaymentOption:(TXHPaymentOption *)selectedPaymentOption
{
    _selectedPaymentOption = selectedPaymentOption;
    
    [self reloadSelectedController];
}

- (NSArray *)payentOptionDisplayNames
{
    NSArray *paymentOptions = self.paymentOptionsManager.paymentOptions;
    NSArray *paymentNames = [paymentOptions valueForKeyPath:@"displayName"];

    NSMutableArray *displayNameDictionaries = [NSMutableArray array];
    
    for (NSString *name in paymentNames)
    {
        NSDictionary *dic = @{@"text" : name};
        [displayNameDictionaries addObject:dic];
    }
    
    return displayNameDictionaries;
}

- (void)reloadSelectedController
{
    TXHPaymentOption *option = [self selectedPaymentOption];
    NSString *identifier     = option.segueIdentifier;

    [self performSegueWithIdentifier:identifier sender:self];
}

//- (TXHPaymentOption *)selectedPaymentOption
//{
//    NSUInteger selectedIndex = self.paymentTypeSegmentedControl.selectedSegmentIndex;
//    TXHPaymentOption *selectedOption = [self.paymentOptionsManager paymentOptionsAtIndex:selectedIndex];
//
//    return selectedOption;
//}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue isMemberOfClass:[TXHEmbeddingSegue class]])
    {
        TXHEmbeddingSegue *transitionSegue = (TXHEmbeddingSegue *)segue;
        transitionSegue.containerView      = self.containerView;
        transitionSegue.previousController = self.paymentDetailsController;
    }
    
    if ([segue.identifier isEqualToString:@"TXHSalesPaymentCardDetailsViewController"] ||
        [segue.identifier isEqualToString:@"TXHSalesPaymentCashDetailsViewController"] ||
        [segue.identifier isEqualToString:@"TXHSalesPaymentCreditDetailsViewController"])
    {
        self.paymentDetailsController = segue.destinationViewController;
    }
}

- (void)setPaymentDetailsController:(UIViewController<TXHSalesPaymentContentViewControllerProtocol> *)paymentDetailsController
{
    _paymentDetailsController = paymentDetailsController;
    
    TXHPaymentOption *option = [self selectedPaymentOption];
    
    paymentDetailsController.productManager = self.productManager;
    paymentDetailsController.orderManager   = self.orderManager;
    paymentDetailsController.gateway        = option.gateway;
    
    [self map:@keypath(self.paymentDetailsController.valid) to:@keypath(self.valid) null:nil];
}

- (TXHActivityLabelView *)activityView
{
    if (!_activityView)
        _activityView = [TXHActivityLabelView getInstanceInView:self.view];
    
    return _activityView;
}

#pragma mark - Payment method changed

- (IBAction)didChangePaymentMethod:(UISegmentedControl *)sender
{
    [self reloadSelectedController];
}

#pragma mark - TXHSalesContentsViewControllerProtocol

- (void)finishStepWithCompletion:(void (^)(NSError *))completionBlock
{
    [self.paymentDetailsController finishWithCompletion:^(NSError *error) {
        if (!error)
        {
            [self.orderManager confirmOrderWithCompletion:^(TXHOrder *order, NSError *confirmationError) {

                if (completionBlock)
                    completionBlock(confirmationError);
            }];
        }
        else if (completionBlock)
            completionBlock(error);
    }];
}

- (void)dealloc
{
    [self removeAllObservations];
}


@end
