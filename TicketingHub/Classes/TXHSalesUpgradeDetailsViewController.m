//
//  TXHSalesUpgradeDetailsViewController.m
//  TicketingHub
//
//  Created by Mark on 12/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesUpgradeDetailsViewController.h"

#import "TXHSalesUpgradeCell.h"

#import "TXHOrderManager.h"
#import "TXHProductsManager.h"

#import "TXHActivityLabelView.h"
#import "UIColor+TicketingHub.h"
#import <UIAlertView-Blocks/UIAlertView+Blocks.h>


static NSString * const kStoredUserInputsKey = @"kStoredUpgradesUserInputsKey";

@interface TXHSalesUpgradeDetailsViewController () <UITableViewDelegate, UITableViewDataSource, TXHSalesUpgradeCellDelegate>

@property (readwrite, assign, nonatomic, getter = isValid) BOOL valid;
@property (readwrite, assign, nonatomic) BOOL shouldBeSkiped;

@property (strong, nonatomic) NSDictionary        *ticketUpgradesDictionary;
@property (strong, nonatomic) NSArray             *tickets;
@property (strong, nonatomic) NSArray             *upgrades;

@property (strong, nonatomic) NSMutableDictionary *selectedUpgrades;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) TXHActivityLabelView *activityView;

@end

@implementation TXHSalesUpgradeDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - accessors

- (void)setTicketUpgradesDictionary:(NSDictionary *)upgrades
{
    _ticketUpgradesDictionary = upgrades;
    
    [self.tableView reloadData];
}

- (void)setUpgrades:(NSArray *)upgrades
{
    _upgrades = upgrades;
    
    if (![upgrades count]) // TODO: maybe skip to next step automatically
        [self.activityView showWithMessage:NSLocalizedString(@"SALESMAN_UPGRADES_NO_UPGRADES_MESSAGE", nil)
                           indicatorHidden:YES];
    
    [self.tableView reloadData];
}

- (void)setOrderManager:(TXHOrderManager *)orderManager
{
    _orderManager = orderManager;
    
    [self loadUpgrades];
}

- (NSArray *)tickets
{
    if (!_tickets)
        _tickets = [self.orderManager.order.tickets allObjects];
    
    return _tickets;
}

- (TXHActivityLabelView *)activityView
{
    if (!_activityView)
        _activityView = [TXHActivityLabelView getInstanceInView:self.view];
    
    return _activityView;
}

- (void)loadUpgrades
{
    __weak typeof(self) wself = self;
    
    [self.activityView showWithMessage:NSLocalizedString(@"SALESMAN_UPGRADES_LOADING_UPGRADES", nil)
                       indicatorHidden:NO];
    
    [self.orderManager upgradesForCurrentOrderWithCompletion:^(NSDictionary *ticketUpgradesDictionary, NSError *error) {
        
        [wself.activityView hide];
        
        if (error)
        {
            [self showErrorWithTitle:NSLocalizedString(@"ERROR_TITLE", nil)
                             message:error.localizedDescription
                              action:^{
                                  [wself.orderManager resetOrder];
                              }];
        }
        else
        {
            NSMutableSet *allUpgrades = [NSMutableSet set];
            
            // get all upgrades into one set
            for (NSArray *upgrades in [ticketUpgradesDictionary allValues])
                [allUpgrades addObjectsFromArray:upgrades];
            
            wself.upgrades = [allUpgrades allObjects];
            wself.ticketUpgradesDictionary = ticketUpgradesDictionary;
            wself.shouldBeSkiped = [allUpgrades count] == 0;
            wself.valid = YES;
        }
    }];
}

- (NSArray *)ticketsForUpgrade:(TXHUpgrade *)upgrade
{
    NSMutableArray *tickets = [NSMutableArray array];
    
    for (NSString *ticketID in self.ticketUpgradesDictionary)
    {
        NSArray *upgrades = self.ticketUpgradesDictionary[ticketID];
        if ([upgrades containsObject:upgrade])
        {
            TXHTicket *ticket = [self.orderManager ticketFromOrderWithID:ticketID];
            [tickets addObject:ticket];
        }
    }
    return tickets;
}

- (NSMutableDictionary *)selectedUpgrades
{
    if (!_selectedUpgrades)
    {
        NSMutableDictionary *storedUserInput = [self.orderManager storedValueForKey:kStoredUserInputsKey];
        
        if (storedUserInput)
            _selectedUpgrades = storedUserInput;
        else
            _selectedUpgrades = [NSMutableDictionary dictionary];
    }
    
    return _selectedUpgrades;
}

- (TXHUpgrade *)upgreadeAtIndexPath:(NSIndexPath *)indexpath
{
    return self.upgrades[indexpath.row]; // TODO: add sequrity check
}

- (TXHTicket *)ticketWithTicketID:(NSString *)ticketID
{
    for (TXHTicket * ticket in self.tickets)
        if ([ticket.ticketId isEqualToString:ticketID])
            return ticket;
        
    return nil;
}

- (TXHUpgrade *)upgradeWithUpgradeID:(NSString *)upgradeID
{
    for (TXHUpgrade *upgrade in self.upgrades)
        if ([upgrade.upgradeId isEqualToString:upgradeID])
            return upgrade;
    
    return nil;
}

- (void)setSelectedTickets:(NSArray *)tickets forUpgrade:(TXHUpgrade *)upgrade
{
    self.selectedUpgrades[upgrade.upgradeId] = tickets;
}

- (NSArray *)selectedTicketsForUpgrade:(TXHUpgrade *)upgrade
{
    return self.selectedUpgrades[upgrade.upgradeId];
}

// TODO: bit fucked with those constant conversions after design changes...
- (NSDictionary *)buildUpgradesInfo
{
    NSMutableDictionary *upgradesInfo = [NSMutableDictionary dictionary];
    
    for (TXHTicket *ticket in self.tickets)
    {
        NSMutableArray *selectedUpgrades = [NSMutableArray array];
        
        for (NSString *upgradeID in self.selectedUpgrades)
        {
            NSArray *tickets = self.selectedUpgrades[upgradeID];
            if ([tickets containsObject:ticket])
                [selectedUpgrades addObject:upgradeID];
        }
        
        if ([selectedUpgrades count])
        {
            NSString *ticketID = ticket.ticketId;
            upgradesInfo[ticketID] = selectedUpgrades;
        }
    }
    return upgradesInfo;
}

#pragma mark - error helper

- (void)showErrorWithTitle:(NSString *)title message:(NSString *)message action:(void(^)(void))action
{
    [self.activityView hide];
    
    RIButtonItem *cancelItem = [RIButtonItem itemWithLabel:NSLocalizedString(@"ERROR_DISMISS_BUTTON_TITLE", nil)
                                                    action:^{
                                                        if (action)
                                                            action();
                                                    }];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                               cancelButtonItem:cancelItem
                                               otherButtonItems: nil];
    [alertView show];
}


#pragma mark - UITableView Datasource & Delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.upgrades count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TXHSalesUpgradeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UpgradeCell" forIndexPath:indexPath];
    cell.productManager = self.productManager;
    cell.delegate       = self;
    
    TXHUpgrade *upgrade      = [self upgreadeAtIndexPath:indexPath];
    NSArray *tickets         = [self ticketsForUpgrade:upgrade];
    NSArray *selectedTickets = [self selectedTicketsForUpgrade:upgrade];

    [cell setUpgrade:upgrade withTickets:tickets selectedTickets:selectedTickets];
    
    return cell;
}


#pragma mark - TXHSalesUpgradeCellDelegate

- (void)txhSalesUpgradeCell:(TXHSalesUpgradeCell *)cell changedTicketsSelection:(NSArray *)selectedTickets forUpgrade:(TXHUpgrade *)upgrade
{
    [self setSelectedTickets:selectedTickets forUpgrade:upgrade];
    [self buildUpgradesInfo];
}

#pragma mark - TXHSalesContentsViewControllerProtocol

- (void)finishStepWithCompletion:(void (^)(NSError *error))blockName
{
    NSDictionary *upgradesInfo = [self buildUpgradesInfo];
    
    if (![upgradesInfo count])
    {
        blockName(nil);
        return;
    } 
    
    [self.activityView showWithMessage:NSLocalizedString(@"SALESMAN_UPGRADES_UPDATING_UPGRADES", nil)
                       indicatorHidden:NO];
    
    __weak typeof(self) wself = self;
    
    [self.orderManager updateOrderWithUpgradesInfo:upgradesInfo
                                        completion:^(TXHOrder *order, NSError *error) {
                                            
                                            [wself.activityView hide];
                                            
                                            if (error) {
                                                [self showErrorWithTitle:NSLocalizedString(@"ERROR_TITLE", nil)
                                                                 message:error.localizedDescription
                                                                  action:^{
                                                                      if (blockName)
                                                                          blockName(error);
                                                                  }];
                                                
                                                [wself.tableView reloadData];
                                            }
                                            else if (blockName)
                                                blockName(error);
                                            
                                            [wself.orderManager storeValue:wself.selectedUpgrades forKey:kStoredUserInputsKey];
                                        }];
}

@end
