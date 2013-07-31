//
//  TXHSalesWizardDetailsViewController.m
//  TicketingHub
//
//  Created by Mark on 29/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesWizardDetailsViewController.h"

#import "TXHEmbeddingSegue.h"
#import "TXHSalesTicketViewController.h"
#import "TXHTransitionSegue.h"

@interface TXHSalesWizardDetailsViewController ()

@end

@implementation TXHSalesWizardDetailsViewController

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
    [self performSegueWithIdentifier:@"Embed InformationPane" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
#pragma unused (sender)
    if ([segue.identifier isEqualToString:@"Embed InformationPane"])
    {
        TXHEmbeddingSegue *embeddingSegue = (TXHEmbeddingSegue *)segue;
        
        embeddingSegue.containerView = self.view;
        
        return;
    }
    
    if ([segue isMemberOfClass:[TXHTransitionSegue class]]) {
        TXHTransitionSegue *transitionSegue = (TXHTransitionSegue *)segue;
        
        transitionSegue.containerView = self.view;
        
        if ([segue.identifier isEqualToString:@"Transition To Step1"]) {
            TXHSalesTicketViewController *salesTicketController = transitionSegue.destinationViewController;
            salesTicketController.delegate = self.delegate;
        }
//        else
//        {
//            transitionSegue.animationOptions = UIViewAnimationOptionTransitionCurlUp;
//        }
    }
}

@end
