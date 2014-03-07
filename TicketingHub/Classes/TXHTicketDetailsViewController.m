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
#import "TXHBorderedButton.h"

@interface TXHTicketDetailsViewController ()

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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupBackground];
    [self setupDismissRecognizer];
    
    [self updateButtons];
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

- (void)setupDismissRecognizer
{
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognized:)];
    [self.view addGestureRecognizer:recognizer];
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
        [self.attendedButton setTitle:@"Attended at" forState:UIControlStateNormal];
        self.attendedButton.fillColor = [UIColor txhGreenColor];
        
        UIImage *icon = [UIImage imageNamed:@"small-checkmark"];
        icon = [icon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [self.attendedButton setImage:icon forState:UIControlStateNormal];
    }
    else
    {
        [self.attendedButton setTitle:@"Mark as attended" forState:UIControlStateNormal];
        self.attendedButton.fillColor = self.orderButton.fillColor;
        
        UIImage *icon = [UIImage imageNamed:@"empty-circle"];
        icon = [icon imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [self.attendedButton setImage:icon forState:UIControlStateNormal];
    }
}


- (void)tapRecognized:(UITapGestureRecognizer *)recognizer
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
    NSString *dateString;
    @synchronized (self)
    {
        self.dateFormatter.dateFormat = [NSString stringWithFormat:@"d'%@' MMM HH:MM", [date daySuffix]];
        dateString = [self.dateFormatter stringFromDate:date];
    }
    
    return dateString;
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
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.titleLabel.text      = [NSString stringWithFormat:@"%@ Ticket",self.ticket.tier.name];
//        self.subtitleLabel.text = //TODO
        self.validFromLabel.text  = [self dateStringForDate:self.ticket.validFrom];
        self.validUntilLabel.text = [self dateStringForDate:self.ticket.expiresAt];
        self.upgradesLabel.text   = [upgrades count] ? [upgrades componentsJoinedByString:@", "] : @"-";
        self.fullNameLabel.text   = [customer.fullName length] ? customer.fullName : @"-";
        self.phoneLabel.text      = [customer.telephone length] ? customer.telephone : @"-";
        self.countryLabel.text    = [customer.country length] ? customer.country : @"-";

        [self updateButtons];
    });
}

@end
