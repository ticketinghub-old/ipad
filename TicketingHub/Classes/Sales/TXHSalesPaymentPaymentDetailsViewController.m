//
//  TXHSalesPaymentPaymentDetailsViewController.m
//  TicketingHub
//
//  Created by Mark on 14/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesPaymentPaymentDetailsViewController.h"

#import "TXHEmbeddingSegue.h"
#import "TXHTransitionSegue.h"

@interface TXHSalesPaymentPaymentDetailsViewController ()

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
    [self performSegueWithIdentifier:@"Embed TXHSalesPaymentCardDetailsViewController" sender:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
#pragma unused (sender)
    if ([segue.identifier isEqualToString:@"Embed TXHSalesPaymentCardDetailsViewController"])
    {
        TXHEmbeddingSegue *embeddingSegue = (TXHEmbeddingSegue *)segue;
        embeddingSegue.containerView = self.view;
    }
    
    if ([segue isMemberOfClass:[TXHTransitionSegue class]]) {
        TXHTransitionSegue *transitionSegue = (TXHTransitionSegue *)segue;
        transitionSegue.containerView = self.view;
    }
}
@end
