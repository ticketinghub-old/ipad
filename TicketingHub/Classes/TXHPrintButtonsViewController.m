//
//  TXHPrintButtonsViewController.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 18/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHPrintButtonsViewController.h"
#import "TXHGradientView.h"
#import "TXHBorderedButton.h"

#import "NSDateFormatter+DisplayFormat.h"
#import "UIFont+TicketingHub.h"

@interface TXHPrintButtonsViewController ()

@property (weak, nonatomic) IBOutlet TXHBorderedButton *printTicketsButton;
@property (weak, nonatomic) IBOutlet TXHBorderedButton *printReciptButton;
@property (weak, nonatomic) IBOutlet TXHBorderedButton *markAllAttendingButton;
@property (weak, nonatomic) IBOutlet TXHBorderedButton *cancelOrderButton;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@end

@implementation TXHPrintButtonsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupGradient];
    
    [self updateView];
}

- (void)setupGradient
{
    UIColor *colorOne = [UIColor colorWithWhite:1.0 alpha:0.0];
    UIColor *colorTwo = [UIColor whiteColor];
    
    NSArray *colors =  [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    
    [(TXHGradientView *)self.view setColors:colors];
    [(TXHGradientView *)self.view setLocations:@[@0.0,@0.4]];
}

- (void)updateView
{
    if (!self.order)
    {
        [self setButtonsHidden:YES];
        self.messageLabel.hidden = YES;
    }
    else if (self.order.cancelledAt)
    {
        [self setButtonsHidden:YES];
        [self showWithCancellationDate:self.order.cancelledAt];
    }
    else
    {
        [self setButtonsHidden:NO];
        self.messageLabel.hidden = YES;
    }
}

- (void)setButtonsHidden:(BOOL)hidden
{
    self.cancelOrderButton.hidden      = hidden;
    self.markAllAttendingButton.hidden = hidden;
    self.printReciptButton.hidden      = hidden;
    self.printTicketsButton.hidden     = hidden;
}

- (void)setOrder:(TXHOrder *)order
{
    _order = order;
    
    [self updateView];
}

- (void)showWithCancellationDate:(NSDate *)expirationDate
{
    NSString *dateString    = [NSDateFormatter txh_fullDateStringFromDate:expirationDate];
    NSString *messageString = [NSString stringWithFormat:NSLocalizedString(@"TICKET_DETAILS_ERROR_MESSAGE_FORMAT", nil), dateString];
    
    [self setError:messageString boldPart:dateString];
}

- (void)setError:(NSString *)errorMessage boldPart:(NSString *)boldString
{
    NSMutableAttributedString *errorMessageAttributed = [[NSMutableAttributedString alloc] initWithString:errorMessage];
    
    if ([boldString length])
    {
        NSRange boldRange = [errorMessage rangeOfString:boldString];
        
        [errorMessageAttributed addAttribute:NSFontAttributeName
                                       value:[UIFont txhBoldFontWithSize:self.messageLabel.font.pointSize]
                                       range:boldRange];
    }
    self.messageLabel.hidden = NO;
    self.messageLabel.attributedText = errorMessageAttributed;
}

- (IBAction)printTicketsAction:(id)sender
{
    [self.delegate txhPrintButtonsViewControllerPrintTicketsAction:sender];
}

- (IBAction)printReciptAction:(id)sender
{
    [self.delegate txhPrintButtonsViewControllerPrintReciptAction:sender];
}

- (IBAction)cancelButtonAction:(id)sender
{
    [self.delegate txhPrintButtonsViewControllerCancelButtonAction:sender];
}

- (IBAction)markAttendingButtonAction:(id)sender
{
    [self.delegate txhPrintButtonsViewControllerMarkAttendingButtonAction:sender];
}

@end
