//
//  TXHTicketDetailsViewController.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 07/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHTicketDetailsViewController.h"
#import "UIImage+ImageEffects.h"
#import "UIColor+TicketingHub.h"
#import "NSDate+Additions.h"
#import "NSDateFormatter+DisplayFormat.h"
#import "TXHBorderedButton.h"
#import <QuartzCore/QuartzCore.h>
#import <iOS-api/NSDate+ISO.h>
#import <iOS-api/NSDateFormatter+TicketingHubFormat.h>
#import "TXHProductsManager.h"

@interface TXHTicketDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIView *errorView;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *validFromLabel;
@property (weak, nonatomic) IBOutlet UILabel *validUntilLabel;
@property (weak, nonatomic) IBOutlet UILabel *upgradesLabel;
@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;

@property (weak, nonatomic) IBOutlet TXHBorderedButton *orderButton;
@property (weak, nonatomic) IBOutlet TXHBorderedButton *attendedButton;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;


@end

@implementation TXHTicketDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self customizeView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupBackground];
    [self updateButtons];
    [self updateErrorView];
}

- (void)customizeView
{
    self.contentView.layer.cornerRadius = 5;
    self.errorView.layer.cornerRadius   = 5;
}

- (void)setupBackground
{
    UIColor *blurTintColor = [[UIColor txhDarkBlueColor] colorWithAlphaComponent:0.6];
    
    UIImage *bgImage = [[UIImage screenshot] applyBlurWithRadius:3
                                                       tintColor:blurTintColor
                                           saturationDeltaFactor:1.8
                                                       maskImage:nil];
    
    UIColor *bgImgColor = [UIColor colorWithPatternImage:bgImage];
    self.view.backgroundColor = bgImgColor;
}

- (void)updateButtons
{
    [self updateOrderButton];
    [self updateAttendedButton];
}

- (void)updateOrderButton
{
    UIImage *arrow = [UIImage imageNamed:@"right-arrow"];
    arrow = [arrow imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.orderButton setImage:arrow forState:UIControlStateNormal];
}

- (void)updateAttendedButton
{
    if (self.ticket.attendedAt)
    {
        [self configureAttendedButtonWhenAttended];
    }
    else
    {
        [self configureAttendedButtonWhenNotAttended];
    }
}

- (void)updateErrorView
{
    NSDate *expirationDate = self.ticket.expiresAt;
    BOOL ticketExpired = [expirationDate isInThePast];

    NSString *errorConstant = [self errorMessageConstant];
    NSString *errorDurationMesage = nil;
    
    if (ticketExpired)
    {
        NSInteger daysFromNow = [expirationDate daysFromNow];
        if (daysFromNow > 0)
        {
            errorDurationMesage = [self errorForDays:daysFromNow];
        }
        else
        {
            NSInteger hoursFromNow = [expirationDate hoursFromNow];
            if (hoursFromNow > 0)
            {
                errorDurationMesage = [self errorForHours:hoursFromNow];
            }
            else
            {
                NSInteger minutesFromNow = [expirationDate minutesFromNow];
                errorDurationMesage = [self errorForMinutes:minutesFromNow];
            }
        
        }
        [self setErrorMessageBold:errorDurationMesage normalString:errorConstant];
    }
    self.errorView.hidden = !ticketExpired;
}

- (void)setErrorMessageBold:(NSString *)boldString normalString:(NSString *)normalString
{
    NSString *error = [NSString stringWithFormat:@"%@ %@",boldString, normalString];
    NSRange boldRange = [error rangeOfString:boldString];
    
    NSMutableAttributedString *errorMessage = [[NSMutableAttributedString alloc] initWithString:error];
    [errorMessage addAttribute:NSFontAttributeName
                            value:[UIFont boldSystemFontOfSize:15]
                            range:boldRange];
    
    self.errorLabel.attributedText = errorMessage;
}

- (NSString *)errorForMinutes:(NSInteger)minutes
{
    return [NSString stringWithFormat:@"This Ticket expired %ld minutes ago.",(long)minutes];
}

- (NSString *)errorForHours:(NSInteger)hours
{
    return [NSString stringWithFormat:@"This Ticket expired %ld hours ago.",(long)hours];
}

- (NSString *)errorForDays:(NSInteger)days
{
    return [NSString stringWithFormat:@"This Ticket expired %ld days ago.", (long)days];
}

- (NSString *)errorMessageConstant
{
    return @"You still have option to grant access.";
}

- (void)configureAttendedButtonWhenAttended
{
    NSString *dateString = [self.ticket.attendedAt isoTimeString];
    NSString *title      = [NSString stringWithFormat:@"Attended at %@",dateString];
    NSRange timeRange    = [title rangeOfString:dateString];
    
    NSMutableAttributedString *attributedTitle =
    [[NSMutableAttributedString alloc] initWithString:title];
    
    [attributedTitle addAttribute:NSFontAttributeName
                            value:[UIFont boldSystemFontOfSize:15]
                            range:timeRange];
    
    [attributedTitle addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [title length])];
    [self.attendedButton setAttributedTitle:attributedTitle forState:UIControlStateNormal];
    
    NSMutableAttributedString *highlightedAttributedTitle = [attributedTitle mutableCopy];
    [highlightedAttributedTitle addAttribute:NSForegroundColorAttributeName value:[UIColor txhGreenColor] range:NSMakeRange(0, [title length])];
    [self.attendedButton setAttributedTitle:highlightedAttributedTitle forState:UIControlStateHighlighted];
    
    [self.attendedButton setTitle:nil
                         forState:UIControlStateNormal];
    
    self.attendedButton.borderColor          = [UIColor txhGreenColor];
    self.attendedButton.normalFillColor      = [UIColor txhGreenColor];
    self.attendedButton.highlightedFillColor = self.attendedButton.superview.backgroundColor;
    self.attendedButton.normalTextColor      = [UIColor whiteColor];
    self.attendedButton.highlightedTextColor = [UIColor txhGreenColor];
    
    
    UIImage *icon = [UIImage imageNamed:@"small-checkmark"];
    icon = [icon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.attendedButton setImage:icon forState:UIControlStateNormal];
}

- (void)configureAttendedButtonWhenNotAttended
{
    [self.attendedButton setAttributedTitle:nil forState:UIControlStateNormal];
    [self.attendedButton setAttributedTitle:nil forState:UIControlStateHighlighted];
    [self.attendedButton setTitle:@"Mark as attended" forState:UIControlStateNormal];
    self.attendedButton.borderColor          = [UIColor txhButtonBlueColor];
    self.attendedButton.normalFillColor      = [UIColor txhButtonBlueColor];
    self.attendedButton.highlightedFillColor = self.attendedButton.superview.backgroundColor;
    self.attendedButton.normalTextColor      = [UIColor whiteColor];
    self.attendedButton.highlightedTextColor = [UIColor txhButtonBlueColor];
    
    UIImage *icon = [UIImage imageNamed:@"empty-circle"];
    icon = [icon imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.attendedButton setImage:icon forState:UIControlStateNormal];
}

- (IBAction)orderButtonAction:(id)sender
{
    [self.delegate txhTicketDetailsViewController:self wantsToPresentOrderForTicket:self.ticket];
}

- (IBAction)attendedButtonAction:(id)sender
{
    [self blockAttenededButton];
    
    __weak typeof(self) wself = self;
    [TXHPRODUCTSMANAGER setTicket:self.ticket
                         attended:(self.ticket.attendedAt == nil)
                       completion:^(TXHTicket *ticket, NSError *error) {
                           if (!error)
                               [wself.delegate txhTicketDetailsViewController:wself
                                                              didChangeTicket:wself.ticket];
                           
                           [wself unblockAttenededButton];
                           [wself updateButtons];
                       }];
}

- (IBAction)closeButtonAction:(id)sender
{
    [self dismissSelf];
}

- (void)dismissSelf
{
    [self.delegate txhTicketDetailsViewControllerShouldDismiss:self];
}

- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [NSDateFormatter new];
    }
    
    return _dateFormatter;
}

- (NSString *)dateStringForDate:(NSDate *)date
{
    return [NSDateFormatter txh_fullDateStringFromDate:date];
}

- (void)setTicket:(TXHTicket *)ticket
{
    _ticket = ticket;
    
    [self updateView];
}

- (void)updateView
{
    NSMutableArray *upgrades = [NSMutableArray array];
    for (TXHUpgrade *upgrade in self.ticket.upgrades)
        [upgrades addObject:upgrade.name];
    
    TXHCustomer *customer = self.ticket.customer;
    
    __weak typeof(self) wself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        wself.titleLabel.text      = [NSString stringWithFormat:@"%@ Ticket",wself.ticket.tier.name];
        wself.subtitleLabel.text   = [wself.ticket.reference length] > 0 ? wself.ticket.reference : @"";
        wself.validFromLabel.text  = [wself dateStringForDate:wself.ticket.validFrom];
        wself.validUntilLabel.text = [wself dateStringForDate:wself.ticket.expiresAt];
        wself.upgradesLabel.text   = [upgrades count] ? [upgrades componentsJoinedByString:@", "] : @"-";
        wself.fullNameLabel.text   = [customer.fullName length] ? customer.fullName : @"-";
        wself.phoneLabel.text      = [customer.telephone length] ? customer.telephone : @"-";
        wself.countryLabel.text    = [customer.country length] ? customer.country : @"-";

        [wself updateButtons];
    });
}

- (void)blockAttenededButton
{
    self.attendedButton.enabled = NO;
}

- (void)unblockAttenededButton
{
    self.attendedButton.enabled = YES;
}

@end
