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
#import "UISegmentedControl+NSArray.h"
#import "TXHActivityLabelView.h"
#import <Block-KVO/MTKObserving.h>


@interface TXHSalesPaymentViewController () <UICollectionViewDelegateFlowLayout>

@property (readwrite, nonatomic, getter = isValid) BOOL valid;

@property (weak, nonatomic) TXHActivityLabelView *activityView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *paymentTypeSegmentedControl;

@property (strong, nonatomic) UIViewController<TXHSalesPaymentContentViewControllerProtocol> *paymentDetailsController;
@property (strong, nonatomic) TXHPaymentOptionsManager *paymentOptionsManager;


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
    [self.paymentOptionsManager loadOptionsWithCompletion:^(NSArray *paymentOptions, NSError *error) {

        [wself.activityView hide];
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
    
    [self.paymentTypeSegmentedControl setItemsFromArray:paymentNames];
    [self.paymentTypeSegmentedControl setSelectedSegmentIndex:0];
    
    self.paymentTypeSegmentedControl.hidden = [paymentNames count] == 0;
}

- (NSArray *)payentOptionDisplayNames
{
    NSArray *paymentOptions = self.paymentOptionsManager.paymentOptions;
    NSArray *paymentNames = [paymentOptions valueForKeyPath:@"displayName"];

    return paymentNames;
}

- (void)reloadSelectedController
{
    TXHPaymentOption *option = [self selectedPaymentOption];
    NSString *identifier     = option.segueIdentifier;

    [self performSegueWithIdentifier:identifier sender:self];
}

- (TXHPaymentOption *)selectedPaymentOption
{
    NSUInteger selectedIndex = self.paymentTypeSegmentedControl.selectedSegmentIndex;
    TXHPaymentOption *selectedOption = [self.paymentOptionsManager paymentOptionsAtIndex:selectedIndex];

    return selectedOption;
}

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

- (void)finishStepWithCompletion:(void (^)(NSError *error))blockName
{
    [self.orderManager confirmOrderWithCompletion:^(TXHOrder *order, NSError *error) {
        if (blockName)
            blockName(error);
    }];
}


@end
