//
//  TXHSalesPaymentViewController.m
//  TicketingHub
//
//  Created by Mark on 14/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesPaymentViewController.h"

#import "TXHSalesCompletionViewController.h"
#import "TXHSalesPaymentPaymentDetailsViewController.h"
#import "TXHSalesTimerViewController.h"
#import "TXHOrderManager.h"

#import <Block-KVO/MTKObserving.h>

@interface TXHSalesPaymentViewController () <UICollectionViewDelegateFlowLayout>

@property (readwrite, nonatomic, getter = isValid) BOOL valid;

@property (nonatomic, strong) NSArray *paymentGateways;
@property (nonatomic, strong) TXHGateway *handpointGateway; // TODO: to change of couse

@property (strong, nonatomic) TXHSalesPaymentPaymentDetailsViewController *paymentDetailsController;
@property (weak, nonatomic) IBOutlet UISegmentedControl *paymentTypeSegmentedControl;

@end

@implementation TXHSalesPaymentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    __weak typeof(self) wself = self;

    [self updateView];
    
    [self.orderManager getPaymentGatewaysWithCompletion:^(NSArray *gateways, NSError *error) {
        
        if (error)
        {
            //TODO: handle error
            return ;
        }
        wself.paymentGateways = gateways;
    }];
}

- (void)setPaymentGateways:(NSArray *)paymentGateways
{
    _paymentGateways = paymentGateways;

    [self checkHandpointgateway];

    [self updateView];
}

- (void)checkHandpointgateway
{
    for (TXHGateway *gateway in self.paymentGateways)
    {
        if ([gateway.type isEqualToString:@"handpoint"])
        {
            self.handpointGateway = gateway;
            return;
        }
    }
}

- (void)setHandpointGateway:(TXHGateway *)handpointGateway
{
    _handpointGateway = handpointGateway;
    [self updatePaymentMethod];
}

- (void)updateView
{
    [self updatePaymentTypeSegmentedControl];
}

- (void)updatePaymentTypeSegmentedControl
{
//    self.paymentTypeSegmentedControl.numberOfSegments = 1 + [self.acceptableGateways count];
}

- (void)setPaymentDetailsController:(TXHSalesPaymentPaymentDetailsViewController *)paymentDetailsController
{
    _paymentDetailsController = paymentDetailsController;

    paymentDetailsController.productManager = self.productManager;
    paymentDetailsController.orderManager   = self.orderManager;
    
    [self updatePaymentMethod];
    
    [self map:@keypath(self.paymentDetailsController.valid) to:@keypath(self.valid) null:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"TXHSalesPaymentPaymentDetailsViewController"])
    {
        self.paymentDetailsController = segue.destinationViewController;
    }
}


#pragma mark - Payment method changed

- (IBAction)didChangePaymentMethod:(UISegmentedControl *)sender
{
    [self updatePaymentMethod];
}

- (void)updatePaymentMethod
{
    self.paymentDetailsController.gateway     = self.handpointGateway;
    self.paymentDetailsController.paymentType = (TXHPaymentMethodType)self.paymentTypeSegmentedControl.selectedSegmentIndex;
}

#pragma mark - TXHSalesContentsViewControllerProtocol

- (void)finishStepWithCompletion:(void (^)(NSError *error))blockName
{
//   [self.orderManager updateOrderWithPaymentMethod:@"cash"
//                                      completion:^(TXHOrder *order, NSError *error) {
//                                          if (!error)
    [self.orderManager confirmOrderWithCompletion:^(TXHOrder *order2, NSError *error2) {
      if (blockName)
          blockName(error2);
    }];
//                                          else if (blockName)
//                                                  blockName(error);
    
//                                      }];
    
}


@end
