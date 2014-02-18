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

@end

@implementation TXHSalesContentsViewController

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

	[self performSegueWithIdentifier:@"Embed Step1" sender:self];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
