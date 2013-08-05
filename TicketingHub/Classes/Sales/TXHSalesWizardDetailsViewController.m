//
//  TXHSalesWizardDetailsViewController.m
//  TicketingHub
//
//  Created by Mark on 29/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesWizardDetailsViewController.h"

#import "TXHEmbeddingSegue.h"
#import "TXHSalesInformationViewController.h"
#import "TXHSalesTicketViewController.h"
#import "TXHSalesTimerViewController.h"
#import "TXHTransitionSegue.h"

@interface TXHSalesWizardDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timerViewVerticalConstraint;

@property (strong, nonatomic) TXHSalesTimerViewController *timeController;

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
    if ([segue.identifier isEqualToString:@"TXHSalesTimerViewController"]) {
        self.timeController = segue.destinationViewController;
        self.timeController.duration = 20.0f;
    }
    
    if ([segue.identifier isEqualToString:@"Embed InformationPane"])
    {
        TXHEmbeddingSegue *embeddingSegue = (TXHEmbeddingSegue *)segue;
        
        embeddingSegue.containerView = self.detailView;
        
        return;
    }
    
    if ([segue isMemberOfClass:[TXHTransitionSegue class]]) {
        TXHTransitionSegue *transitionSegue = (TXHTransitionSegue *)segue;
        
        transitionSegue.containerView = self.detailView;
        
        if ([segue.identifier isEqualToString:@"Transition To Step1"]) {
            TXHSalesWizardDetailsBaseViewController *controller = transitionSegue.destinationViewController;
            controller.delegate = self.delegate;
            controller.timerView = self.timeController;
        }
        if ([segue.identifier isEqualToString:@"Transition To Step2"]) {
            TXHSalesWizardDetailsBaseViewController *controller = transitionSegue.destinationViewController;
            controller.delegate = self.delegate;
            controller.timerView = self.timeController;
        }
    }
}

- (void)updateTimerContainerHeight:(id)sender {
    // The timer container needs to respond to changes in height based on whether a payment selection control is visible or not
    TXHSalesTimerViewController *controller = sender;
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.timerViewVerticalConstraint.constant = controller.newVerticalHeight;
        [self.view layoutIfNeeded];
    } completion:controller.animationHandler];
}

@end
