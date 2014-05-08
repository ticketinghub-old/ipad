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

#import "TXHProductsManager.h"
#import "TXHOrderManager.h"

#import "TXHEmbeddingSegue.h"
#import "UISegmentedControl+NSArray.h"
#import "TXHActivityLabelView.h"
#import <Block-KVO/MTKObserving.h>

@protocol TXHSalesPaymentSpecificViewControllerProtocol

@property (readonly, nonatomic, getter = isValid) BOOL valid;
@property (strong, nonatomic) TXHProductsManager *productManager;
@property (strong, nonatomic) TXHOrderManager    *orderManager;
@property (strong, nonatomic) TXHPaymentOption   *paymentOption;

@end


@interface TXHSalesPaymentViewController () <UICollectionViewDelegateFlowLayout>

@property (readwrite, nonatomic, getter = isValid) BOOL valid;

@property (weak, nonatomic) TXHActivityLabelView *activityView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *paymentTypeSegmentedControl;

@property (strong, nonatomic) UIViewController<TXHSalesPaymentSpecificViewControllerProtocol> *paymentDetailsController;
@property (strong, nonatomic) TXHPaymentOptionsManager *paymentOptionsManager;
@property (strong, nonatomic) NSArray *paymentOptions;


@end

@implementation TXHSalesPaymentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupOptionsManger];
    [self reloadOptions];
}

- (TXHActivityLabelView *)activityView
{
    if (!_activityView)
    {
        _activityView = [TXHActivityLabelView getInstanceInView:self.view];
    }
    return _activityView;
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
        
        if (error)
        {
            // TODO: handle error
            return;
        }
        
        wself.paymentOptions = paymentOptions;
    }];
}

- (void)setPaymentOptions:(NSArray *)paymentOptions
{
    _paymentOptions = paymentOptions;
    
    [self reloadView];
}

- (void)reloadView
{
    [self reloadSegmentedControl];
    [self reloadSelectedController];
}

- (void)reloadSegmentedControl
{
    NSArray *paymentNames = [self.paymentOptions valueForKeyPath:@"displayName"];
    
    [self.paymentTypeSegmentedControl setItemsFromArray:paymentNames];
    [self.paymentTypeSegmentedControl setSelectedSegmentIndex:0];
    
    self.paymentTypeSegmentedControl.hidden = [paymentNames count] == 0;
}

- (void)reloadSelectedController
{
    NSUInteger selectedIndex = self.paymentTypeSegmentedControl.selectedSegmentIndex;
    TXHPaymentOption *option = [self.paymentOptions objectAtIndex:selectedIndex];
    NSString *identifier     = option.segueIdentifier;

    [self performSegueWithIdentifier:identifier sender:self];
}

- (void)setPaymentDetailsController:(UIViewController<TXHSalesPaymentSpecificViewControllerProtocol> *)paymentDetailsController
{
    _paymentDetailsController = paymentDetailsController;

    paymentDetailsController.productManager = self.productManager;
    paymentDetailsController.orderManager   = self.orderManager;
    
    [self map:@keypath(self.paymentDetailsController.valid) to:@keypath(self.valid) null:nil];
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
