//
//  TXHSalesContentsViewController.m
//  TicketingHub
//
//  Created by Mark on 05/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesContentsViewController.h"

#import "TXHEmbeddingSegue.h"
#import "TXHSalesWizardViewController.h"
#import "TXHTransitionSegue.h"


@interface TXHSalesContentsViewController ()

@property (readwrite, nonatomic, getter = isValid) BOOL valid;

@end

@implementation TXHSalesContentsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	[self performSegueWithIdentifier:@"Embed Step1" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
#pragma unused (sender)
    if ([segue.identifier isEqualToString:@"Embed Step1"])
    {
        TXHEmbeddingSegue *embeddingSegue = (TXHEmbeddingSegue *)segue;
        embeddingSegue.containerView = self.view;
    }
    
    if ([segue isMemberOfClass:[TXHTransitionSegue class]]) {
        TXHTransitionSegue *transitionSegue = (TXHTransitionSegue *)segue;
        transitionSegue.containerView = self.view;
    }
}

- (void)showStepWithSegueID:(NSString *)segueID
{
	[self performSegueWithIdentifier:segueID sender:self];
    
}

@end
