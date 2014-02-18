//
//  TXHSalesWizardDetailsViewController.m
//  TicketingHub
//
//  Created by Mark on 29/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesWizardDetailsViewController.h"

#import "TXHSalesCompletionViewController.h"
#import "TXHSalesTimerViewController.h"

@interface TXHSalesWizardDetailsViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timerViewVerticalConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *completionViewVerticalConstraint;

@property (strong, nonatomic) TXHSalesTimerViewController *timeController;
@property (strong, nonatomic) id  stepContentController;
@property (strong, nonatomic) TXHSalesCompletionViewController *stepCompletionController;

@end

@implementation TXHSalesWizardDetailsViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
#pragma unused (sender)
    if ([segue.identifier isEqualToString:@"TXHSalesTimerViewController"]) {
        self.timeController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"TXHSalesContentsViewController"]) {
        self.stepContentController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"TXHSalesCompletionViewController"]) {
        self.stepCompletionController = segue.destinationViewController;
    }
}

@end
