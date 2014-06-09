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
#import "UIFont+TicketingHub.h"

#import <QuartzCore/QuartzCore.h>
#import <iOS-api/NSDate+ISO.h>

#import "TXHActivityLabelPrintersUtilityDelegate.h"
#import "TXHPrinterSelectionViewController.h"
#import "TXHPrintersManager.h"
#import "TXHPrintersUtility.h"

@interface TXHTicketDetailsViewController () <TXHPrinterSelectionViewControllerDelegate>

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

@property (strong, nonatomic) UIPopoverController *printerSelectionPopover;
@property (strong, nonatomic) TXHPrintersUtility *printingUtility;
@property (strong, nonatomic) TXHActivityLabelPrintersUtilityDelegate *printingUtilityDelegate;


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
    
    NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:title];
    
    [attributedTitle addAttribute:NSFontAttributeName
                            value:[UIFont txhBoldFontWithSize:self.attendedButton.titleLabel.font.pointSize]
                            range:timeRange];

    [self.attendedButton setAttributedTitle:attributedTitle forState:UIControlStateNormal];
    [self.attendedButton setTitle:nil forState:UIControlStateNormal];
    
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
    UIButton * button = sender;
    TXHPrinterSelectionViewController *printerSelector = [[TXHPrinterSelectionViewController alloc] initWithPrintersManager:TXHPRINTERSMANAGER];
    printerSelector.delegate = self;
    
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:printerSelector];
    popover.popoverContentSize = CGSizeMake(200, 110);
    
    CGRect fromRect = [button.superview convertRect:button.frame toView:self.view];
    
    [popover presentPopoverFromRect:fromRect
                             inView:self.view
           permittedArrowDirections:UIPopoverArrowDirectionAny
                           animated:YES];
    
    self.printerSelectionPopover = popover;
}

- (void)txhPrinterSelectionViewController:(TXHPrinterSelectionViewController *)controller
didSelectPrinter:(TXHPrinter *)printer
{
    [self.printerSelectionPopover dismissPopoverAnimated:YES];
    self.printerSelectionPopover = nil;
    
    [self.printingUtility startPrintingWithType:TXHPrintTypeTickets onPrinter:printer withTicket:self.ticket];
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
        
        NSArray * prefixedUpgrades = [self prependArrayOfStrings:upgrades prefix:@"+ "];
        
        wself.titleLabel.text      = [NSString stringWithFormat:titleFormat,wself.ticket.reference];
        wself.subtitleLabel.text   = customer.fullName;
        wself.validFromLabel.text  = ticket.validFrom ? [wself dateStringForDate:ticket.validFrom] : @"-";
        wself.validUntilLabel.text = ticket.expiresAt ? [wself dateStringForDate:ticket.expiresAt] : @"-";
        wself.voucherLabel.text    = [ticket.voucher length] ? ticket.voucher : @"-";
        wself.upgradesLabel.text   = [prefixedUpgrades count] ? [prefixedUpgrades componentsJoinedByString:@"\n"] : @"-";
        wself.priceLabel.text      = ticket.price ? [wself.productManager priceStringForPrice:ticket.price] : @"-";
        
        BOOL isCancelled = wself.ticket.order.cancelledAt != nil;

        self.printTicketButton.hidden = isCancelled;
        self.attendedButton.hidden    = isCancelled;
        
        [wself updateButtons];
        [wself updateErrorView];

    });
}

- (NSArray *)prependArrayOfStrings:(NSArray*)originalArray prefix:(NSString*)prefix
{
    NSMutableArray *newArray = [[NSMutableArray alloc] init];
    for( NSString *currString in originalArray )
    {
        NSString *newString = [NSString stringWithFormat:@"%@%@", prefix, currString];
        [newArray addObject:newString];
    }
    
    return newArray;
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


#pragma mark - TXHPrinterSelectionViewControllerDelegate

- (TXHPrintersUtility *)printingUtility
{
    if (!_printingUtility)
    {
        TXHActivityLabelPrintersUtilityDelegate *printingUtilityDelegate =
        [TXHActivityLabelPrintersUtilityDelegate new];
        
        TXHPrintersUtility *printingUtility = [[TXHPrintersUtility alloc] initWithTicketingHubCLient:self.productManager.txhManager.client];
        printingUtility.delegate = printingUtilityDelegate;
        
        _printingUtility = printingUtility;
        _printingUtilityDelegate = printingUtilityDelegate;
    }
    return _printingUtility;
}

@end
