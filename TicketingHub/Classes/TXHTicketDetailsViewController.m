//
//  TXHTicketDetailsViewController.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 07/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHTicketDetailsViewController.h"

#import "TXHProductsManager.h"

#import "TXHBorderedButton.h"
#import "TXHTicketDetailsErrorView.h"

#import "NSDate+Additions.h"
#import "NSDateFormatter+DisplayFormat.h"
#import "UIImage+ImageEffects.h"
#import "UIColor+TicketingHub.h"

#import <QuartzCore/QuartzCore.h>
#import <iOS-api/NSDate+ISO.h>

@interface TXHTicketDetailsViewController ()

@property (weak, nonatomic) IBOutlet TXHTicketDetailsErrorView *errorView;
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
        [self configureAttendedButtonWhenAttended];
    else
        [self configureAttendedButtonWhenNotAttended];
}

- (void)updateErrorView
{
    NSDate *expirationDate = self.ticket.expiresAt;
    [self.errorView showWithExpirationDate:expirationDate];
}

- (void)configureAttendedButtonWhenAttended
{
    NSString *titleFormat = NSLocalizedString(@"TICKET_DETAILS_ATTENDED_TITLE_FORMAT", nil);
    NSString *dateString = [self.ticket.attendedAt isoTimeString];
    NSString *title      = [NSString stringWithFormat:titleFormat,dateString];
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
    [self.attendedButton setTitle:NSLocalizedString(@"TICKET_DETAILS_MARK_AS_ATTENDED_BUTTON_TITLE", nil) forState:UIControlStateNormal];
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
    [self.productManager setTicket:self.ticket
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
        
        NSString *titleFormat = NSLocalizedString(@"TICKET_DETAILS_TITLE_FORMAT", nil);
        wself.titleLabel.text      = [NSString stringWithFormat:titleFormat,wself.ticket.tier.name];
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
