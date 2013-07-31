//
//  TXHSalesTicketCompletionViewController.m
//  TicketingHub
//
//  Created by Mark on 31/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesTicketCompletionViewController.h"

@interface TXHSalesTicketCompletionViewController ()

@property (weak, nonatomic) IBOutlet UIButton *continueButton;

@end

@implementation TXHSalesTicketCompletionViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateTicketCount:(NSInteger)total {
    self.continueButton.enabled = (total > 0);
}

- (IBAction)continueAction:(id)sender {
#pragma unused (sender)
    if ([self.delegate respondsToSelector:@selector(continueFromStep:)]) {
        [self.delegate performSelector:@selector(continueFromStep:) withObject:@(1)];
    }
}

@end
