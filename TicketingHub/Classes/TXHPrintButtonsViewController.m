//
//  TXHPrintButtonsViewController.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 18/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHPrintButtonsViewController.h"

#import "TXHBorderedButton.h"

@interface TXHPrintButtonsViewController ()

@end

@implementation TXHPrintButtonsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupPrintButtons];
}

- (void)setupPrintButtons
{
    UIImage *arrow = [UIImage imageNamed:@"printer-icon"];
    arrow = [arrow imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    [self.printReciptButton  setImage:arrow forState:UIControlStateNormal];
    [self.printTicketsButton setImage:arrow forState:UIControlStateNormal];
}

- (IBAction)printTicketsAction:(id)sender
{
    [self.delegate txhPrintButtonsViewControllerPrintTicketsAction:sender];
}

- (IBAction)printReciptAction:(id)sender
{
    [self.delegate txhPrintButtonsViewControllerPrintReciptAction:sender];
}

- (IBAction)customButtonAction:(id)sender
{
    [self.delegate txhPrintButtonsViewControllerCustomButtonAction:sender];
}

@end
