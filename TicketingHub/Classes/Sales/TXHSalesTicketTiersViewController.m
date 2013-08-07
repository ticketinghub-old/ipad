//
//  TXHSalesTicketTiersViewController.m
//  TicketingHub
//
//  Created by Mark on 25/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesTicketTiersViewController.h"

#import "TXHSalesContentProtocol.h"
#import "TXHSalesTicketTierCell.h"
#import "TXHServerAccessManager.h"
#import "TXHTicketDetail.h"
#import "TXHTicketTier.h"
#import "TXHVenue.h"

@interface TXHSalesTicketTiersViewController () <UITextFieldDelegate, TXHSalesContentProtocol>

@property (strong, nonatomic) TXHVenue *venue;

// Keep a running total of the quantity of tickets keyed by tier
@property (strong, nonatomic) NSMutableDictionary *tierQuantities;

// A reference to the timer view controller
@property (strong, nonatomic) TXHSalesTimerViewController *timerViewController;

// A reference to the completion view controller
@property (strong, nonatomic) TXHSalesCompletionViewController *completionViewController;

@end

@implementation TXHSalesTicketTiersViewController

@synthesize timerViewController = _timerViewController;
@synthesize completionViewController = _completionViewController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.venue = [TXHServerAccessManager sharedInstance].currentVenue;
    
    [self configureTimerViewController];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableDictionary *)tierQuantities {
    if (_tierQuantities == nil) {
        _tierQuantities = [NSMutableDictionary dictionary];
    }
    return _tierQuantities;
}

- (TXHSalesTimerViewController *)timerViewController {
    return _timerViewController;
}

- (void)setTimerViewController:(TXHSalesTimerViewController *)timerViewController {
    _timerViewController = timerViewController;
    [self configureTimerViewController];
}

- (TXHSalesCompletionViewController *)completionViewController {
    return _completionViewController;
}

- (void)setCompletionViewController:(TXHSalesCompletionViewController *)completionViewController {
    _completionViewController = completionViewController;
    [self configureCompletionViewController];
}

- (void)configureTimerViewController {
    // Set up the timer view to reflect our details
    if (self.timerViewController) {
        [self.timerViewController stopCountdownTimer];
        [self.timerViewController resetPresentationAnimated:NO];
        self.timerViewController.stepTitle = NSLocalizedString(@"Select your tickets", @"Select your tickets");
    }
}

- (void)configureCompletionViewController {
    // Set up the completion view controller to reflect ticket tier details
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#pragma unused (tableView)
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#pragma unused (tableView ,section)
    // Return the number of rows in the section.
    return self.venue.ticketDetail.tiers.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TXHSalesTicketTierCell *cell = (TXHSalesTicketTierCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"did select cell%@ at row %d", cell.tier.tierName, indexPath.row);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TXHSalesTicketTierCell";
    TXHSalesTicketTierCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(TXHSalesTicketTierCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    TXHTicketTier *tier = self.venue.ticketDetail.tiers[indexPath.row];
    cell.tier = tier;
    cell.quantityChangedHandler = ^(NSDictionary *quantity) {
        // Add this quantity to our dictionary
        [self.tierQuantities addEntriesFromDictionary:quantity];
        
        // To continue past this stage the quantity of tickets selected must be more than zero
        NSUInteger total = 0;
        for (NSNumber *tierQuantity in [self.tierQuantities allValues]) {
            total += tierQuantity.integerValue;
        }
        self.completionViewController.canCompleteStep = (total > 0);
    };
}

@end
