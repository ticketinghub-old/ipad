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
@property (weak, nonatomic) IBOutlet UILabel *voucherLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet TXHBorderedButton *orderButton;
@property (weak, nonatomic) IBOutlet TXHBorderedButton *printTicketButton;
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
    
    [self updateView];
}

- (void)customizeView
{
    [self setupBackground];
 
    self.contentView.layer.cornerRadius = 15;
}

- (void)setupBackground
{
    UIColor *blurTintColor = [[UIColor txhDarkBlueColor] colorWithAlphaComponent:0.9];
    
    UIImage *bgImage = [[UIImage screenshot] applyBlurWithRadius:5
                                                       tintColor:blurTintColor
                                           saturationDeltaFactor:1.8
                                                       maskImage:nil];
    
    UIColor *bgImgColor = [UIColor colorWithPatternImage:bgImage];
    self.view.backgroundColor = bgImgColor;
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
    
    self.attendedButton.borderColor            = [UIColor txhBlueColor];
    self.attendedButton.highlightedBorderColor = [UIColor txhDarkBlueColor];
    self.attendedButton.normalFillColor        = [UIColor txhBlueColor];
    self.attendedButton.highlightedFillColor   = [UIColor txhDarkBlueColor];
    self.attendedButton.normalTextColor        = [UIColor whiteColor];
    self.attendedButton.highlightedTextColor   = [UIColor whiteColor];
}

- (void)configureAttendedButtonWhenNotAttended
{
    [self.attendedButton setAttributedTitle:nil forState:UIControlStateNormal];
    [self.attendedButton setAttributedTitle:nil forState:UIControlStateHighlighted];
    [self.attendedButton setTitle:NSLocalizedString(@"TICKET_DETAILS_MARK_AS_ATTENDED_BUTTON_TITLE", nil) forState:UIControlStateNormal];

    self.attendedButton.borderColor            = [UIColor txhDarkBlueColor];
    self.attendedButton.highlightedBorderColor = [UIColor txhBlueColor];
    self.attendedButton.normalFillColor        = [UIColor txhDarkBlueColor];
    self.attendedButton.highlightedFillColor   = [UIColor txhBlueColor];
    self.attendedButton.normalTextColor        = [UIColor whiteColor];
    self.attendedButton.highlightedTextColor   = [UIColor whiteColor];
}

- (IBAction)orderButtonAction:(id)sender
{
    [self.delegate txhTicketDetailsViewController:self wantsToPresentOrderForTicket:self.ticket];
}

- (IBAction)printTicketButton:(id)sender
{

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

    if (!_ticket.order)
    {
        __weak typeof(self) wself = self;
        
        [self.productManager getOrderForTicket:self.ticket
                                    completion:^(TXHOrder *order, NSError *error) {
                                        [wself updateView];
                                    }];
    }
}

- (void)updateView
{
    NSMutableArray *upgrades = [NSMutableArray array];
    for (TXHUpgrade *upgrade in self.ticket.upgrades)
        [upgrades addObject:upgrade.name];
    
    TXHCustomer *customer = self.ticket.customer;
    
    __weak typeof(self) wself = self; // not really necessery
    dispatch_async(dispatch_get_main_queue(), ^{
       
        BOOL hasOrder = wself.ticket.order != nil;
        
        wself.contentView.hidden       = !hasOrder;
        wself.errorView.hidden         = !hasOrder;
        wself.printTicketButton.hidden = !hasOrder;
        wself.attendedButton.hidden    = !hasOrder;
        
        if (!hasOrder)
            return;
            
        NSString *titleFormat = NSLocalizedString(@"TICKET_DETAILS_TITLE_FORMAT", nil);
        TXHTicket *ticket = [wself ticket];
        
        wself.titleLabel.text      = [NSString stringWithFormat:titleFormat,wself.ticket.reference];
        wself.subtitleLabel.text   = customer.fullName;
        wself.validFromLabel.text  = ticket.order.confirmedAt ? [wself dateStringForDate:ticket.order.confirmedAt] : @"-";
        wself.validUntilLabel.text = ticket.expiresAt ? [wself dateStringForDate:ticket.expiresAt] : @"-";
        wself.voucherLabel.text    = [ticket.voucher length] ? ticket.voucher : @"-";
        wself.upgradesLabel.text   = [upgrades count] ? [upgrades componentsJoinedByString:@"\n"] : @"-";
        wself.priceLabel.text      = ticket.price ? [wself.productManager priceStringForPrice:ticket.price] : @"-";
        
        [wself updateButtons];
        [wself updateErrorView];

    });
}

- (void)updateButtons
{
    [self updateAttendedButton];
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
    if (self.ticket.order.cancelledAt)
    {
        [self.errorView showWithError:TXHTicketDetailsCancelledError date:self.ticket.order.cancelledAt];
    }
    else if (self.ticket.validFrom && [self.ticket.validFrom isInTheFuture])
    {
        [self.errorView showWithError:TXHTicketDetailsEarlyError date:self.ticket.validFrom];
    }
    else if (self.ticket.expiresAt && [self.ticket.expiresAt isInThePast])
    {
        [self.errorView showWithError:TXHTicketDetailsExpiredError date:self.ticket.expiresAt];
    }
    else
    {
        [self.errorView hide];
    }
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
