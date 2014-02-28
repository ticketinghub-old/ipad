//
//  TXHSalesPaymentPaymentDetailsViewController.m
//  TicketingHub
//
//  Created by Mark on 14/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesPaymentPaymentDetailsViewController.h"

#import "TXHEmbeddingSegue.h"
#import "TXHSalesPaymentCardDetailsViewController.h"
#import "TXHSalesPaymentCashDetailsViewController.h"
#import "TXHSalesPaymentCreditDetailsViewController.h"
#import "TXHTransitionSegue.h"

@interface TXHSalesPaymentPaymentDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIView *paymentContentView;

@property (strong, nonatomic) TXHSalesPaymentCardDetailsViewController *cardController;
@property (strong, nonatomic) TXHSalesPaymentCashDetailsViewController *cashController;
@property (strong, nonatomic) TXHSalesPaymentCreditDetailsViewController *creditController;

@end

@implementation TXHSalesPaymentPaymentDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self performSegueWithIdentifier:@"Embed TXHSalesPaymentCardDetailsViewController" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
#pragma unused (sender)
    if ([segue.identifier isEqualToString:@"Embed TXHSalesPaymentCardDetailsViewController"]) {
        // Grab a handle to the credit card controller
        self.cardController = segue.destinationViewController;
        TXHEmbeddingSegue *embeddingSegue = (TXHEmbeddingSegue *)segue;
        embeddingSegue.containerView = self.paymentContentView;
        return;
    }
    
    // Transitioning between payment method view controllers
    if ([segue isMemberOfClass:[TXHTransitionSegue class]]) {
        TXHTransitionSegue *transitionSegue = (TXHTransitionSegue *)segue;
        transitionSegue.containerView = self.paymentContentView;
    }
    
    if ([segue.identifier isEqualToString:@"TXHSalesPaymentCashDetailsViewController"]) {
        self.cashController = segue.destinationViewController;
        return;
    }
    
    if ([segue.identifier isEqualToString:@"TXHSalesPaymentCreditDetailsViewController"]) {
        self.creditController = segue.destinationViewController;
        return;
    }
    
    // Card controller should already be set by the embedding segue
    if ([segue.identifier isEqualToString:@"TXHSalesPaymentCardDetailsViewController"]) {
        self.cardController = segue.destinationViewController;
        return;
    }
}

- (void)setPaymentMethodType:(TXHPaymentMethodType)paymentType
{
    NSString *paymentMethodKey;
    switch (paymentType)
    {
        default:
        case TXHPaymentMethodTypeCard:
            paymentMethodKey = @"Card";
            break;
        case TXHPaymentMethodTypeCash:
            paymentMethodKey = @"Cash";
            break;
        case TXHPaymentMethodTypeCreditCard:
            paymentMethodKey = @"Credit";
            break;
    }
    
    [self performSegueWithIdentifier:[NSString stringWithFormat:@"TXHSalesPayment%@DetailsViewController", paymentMethodKey] sender:self];
}

@end