//
//  TXHPrintButtonsViewController.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 18/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHOrderFooterViewController.h"
#import "TXHGradientView.h"
#import "TXHBorderedButton.h"

#import "NSDateFormatter+DisplayFormat.h"
#import "UIFont+TicketingHub.h"

@interface TXHOrderFooterViewController ()

@property (weak, nonatomic) IBOutlet TXHBorderedButton *markAllAttendingButton;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@end

@implementation TXHOrderFooterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupGradient];
    
    [self updateView];
    
    [self registerForContextDidChangeNOtification];
}

- (void)dealloc
{
    [self unregisterFromContextDidChangeNOtification];
}

- (void)registerForContextDidChangeNOtification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateView) name:NSManagedObjectContextDidSaveNotification object:nil];
}

- (void)unregisterFromContextDidChangeNOtification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSManagedObjectContextDidSaveNotification object:nil];
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
        NSUInteger ticketsCount = [self.order.tickets count];
        NSUInteger attendedCount = [self.order attendedTickets];
        [self setButtonsHidden:(ticketsCount == attendedCount)];
        self.messageLabel.hidden = YES;
    }
}

- (void)setButtonsHidden:(BOOL)hidden
{
    self.markAllAttendingButton.hidden = hidden;
}

- (void)setOrder:(TXHOrder *)order
{
    _order = order;
    
    [self updateView];
}

- (void)showWithCancellationDate:(NSDate *)expirationDate
{
    NSString *dateString    = [NSDateFormatter txh_fullDateStringFromDate:expirationDate];
    NSString *messageString = [NSString stringWithFormat:NSLocalizedString(@"ORDER_CANCELLACION_MESSAGE_FORMAT", nil), dateString];
    
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

- (IBAction)markAttendingButtonAction:(id)sender
{
    [self.delegate txhPrintButtonsViewControllerMarkAttendingButtonAction:sender];
}

@end
