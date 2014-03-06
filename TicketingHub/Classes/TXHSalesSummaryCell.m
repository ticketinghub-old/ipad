//
//  TXHSalesSummaryCell.m
//  TicketingHub
//
//  Created by Mark on 13/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesSummaryCell.h"
#import "TXHProductsManager.h"

@interface TXHSalesSummaryCell () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *ticketHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *ticketNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ticketPriceLabel;

@property (weak, nonatomic) IBOutlet UITableView *upgradesTableView;
@property (strong, nonatomic) NSArray *orderedUpgrades;

@end

@implementation TXHSalesSummaryCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.ticketHeaderLabel.text = @"Ticket";
}

- (void)setTicket:(TXHTicket *)ticket
{
    _ticket = ticket;
    
    [self updateTicketInfo];
}

- (void)updateTicketInfo
{
    self.ticketNameLabel.text = self.ticket.tier.name;
    self.ticketPriceLabel.text = [TXHPRODUCTSMANAGER priceStringForPrice:self.ticket.price];
    
    self.orderedUpgrades = [self.ticket.upgrades allObjects];
    
    [self.upgradesTableView reloadData];
}

- (TXHUpgrade *)upgradeAtIndes:(NSInteger)index
{
    return self.orderedUpgrades[index];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.orderedUpgrades count] > 0 ? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.orderedUpgrades count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewCell *header = [tableView dequeueReusableCellWithIdentifier:@"SalesSummaryLineHeader"];
    header.textLabel.text = @"Upgrades";
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SalesSummaryLine" forIndexPath:indexPath];
 
    TXHUpgrade *upgrade = [self upgradeAtIndes:indexPath.row];
    
    cell.textLabel.text = upgrade.name;
    cell.detailTextLabel.text = [TXHPRODUCTSMANAGER priceStringForPrice:upgrade.price];
    return cell;
}

@end
