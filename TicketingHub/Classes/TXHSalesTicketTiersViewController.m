//
//  TXHSalesTicketTiersViewController.m
//  TicketingHub
//
//  Created by Mark on 25/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesTicketTiersViewController.h"

#import "TXHSalesTicketTierCell.h"
#import "TXHTicketingHubManager.h"
#import <iOS-api/iOS-api.h>

@interface TXHSalesTicketTiersViewController () <UITextFieldDelegate>

@property (strong, nonatomic) NSArray *availabilities;
@property (strong, nonatomic) NSDate *selectedDate;

@end

@implementation TXHSalesTicketTiersViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
 
    if (![self.availabilities count])
    {
        [self loadTickers];
    }
}


- (void)loadTickers
{
//    [TXHTICKETINHGUBCLIENT availabilitiesForProduct:self.product
//                                           fromDate:[NSDate date]
//                                             toDate:nil
//                                         completion:^(NSArray *availabilities, NSError *error) {
//                                             NSLog(@"%@",availabilities);
//                                         }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
//    TXHTicketTier *tier = self.venue.ticketDetail.tiers[indexPath.row];
    cell.tier = nil;
    // - nil'ed this
    cell.quantityChangedHandler = ^(NSDictionary *quantity) {
        // Add this quantity to our dictionary
    };
}

@end
