//
//  TXHSalesTicketTiersViewController.m
//  TicketingHub
//
//  Created by Mark on 25/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesTicketTiersViewController.h"

#import "TXHSalesTicketTierCell.h"
#import <iOS-api/TXHProduct.h>

@interface TXHSalesTicketTiersViewController () <UITextFieldDelegate>

@property (strong, nonatomic) TXHProduct *product;

// Keep a running total of the quantity of tickets keyed by tier
@property (strong, nonatomic) NSMutableDictionary *tierQuantities;


@end

@implementation TXHSalesTicketTiersViewController

- (NSUInteger)ticketCount {
    // To continue past this stage the quantity of tickets selected must be more than zero
    NSUInteger total = 0;
    for (NSNumber *tierQuantity in [self.tierQuantities allValues]) {
        total += tierQuantity.integerValue;
    }
    return total;
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
#warning - AN turned this off!
//    return self.venue.ticketDetail.tiers.count;
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TXHSalesTicketTierCell *cell = (TXHSalesTicketTierCell *)[tableView cellForRowAtIndexPath:indexPath];
//    NSLog(@"did select cell%@ at row %d", cell.tier.name, indexPath.row);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TXHSalesTicketTierCell";
    TXHSalesTicketTierCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(TXHSalesTicketTierCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
#warning - AN turned this off!
//    TXHTicketTier *tier = self.venue.ticketDetail.tiers[indexPath.row];
    cell.tier = nil;
    // - nil'ed this
    cell.quantityChangedHandler = ^(NSDictionary *quantity) {
        // Add this quantity to our dictionary
        [self.tierQuantities addEntriesFromDictionary:quantity];
//        self.completionViewController.canCompleteStep = ([self ticketCount] > 0);
    };
}

@end
