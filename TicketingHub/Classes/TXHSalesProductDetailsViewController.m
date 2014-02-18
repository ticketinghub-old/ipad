//
//  TXHSalesProductDetailsViewController.m
//  TicketingHub
//
//  Created by Mark on 12/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesProductDetailsViewController.h"

#import "TXHSalesCompletionViewController.h"
#import "TXHSalesProductCell.h"
#import "TXHSalesTimerViewController.h"

@interface TXHSalesProductDetailsViewController ()

// A mutable collection of sections indicating their expanded status.
@property (strong, nonatomic) NSMutableDictionary *sections;

@end

@implementation TXHSalesProductDetailsViewController

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TXHSalesProductCell";
    TXHSalesProductCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    switch (indexPath.row) {
        case 0:
            cell.productName = @"Guide Book";
            cell.price = @(3);
            cell.quantity = @(0);
            cell.limit = @(8);
            cell.productDescription = @"A wonderful guide to your visit";
            break;
        case 1:
            cell.productName = @"Refreshments";
            cell.price = @(2);
            cell.quantity = @(5);
            cell.limit = @(9);
            cell.productDescription = @"A satisfying snack, just for you.";
            break;
        case 2:
            cell.productName = @"Day Travelcard";
            cell.price = @(8);
            cell.quantity = @(1);
            cell.limit = @(2);
            cell.productDescription = @"Now we're going places";
            break;
        case 3:
            cell.productName = @"Local Map";
            cell.price = @(3.50);
            cell.quantity = @(0);
            cell.limit = @(0);
            cell.productDescription = @"So you know where you are all the time";
            break;
        default:
            cell.productName = [NSString stringWithFormat:@"Unspecified #%d", indexPath.row - 3];
            cell.price = @(indexPath.row);
            cell.quantity = @(indexPath.row);
            cell.limit = @(8);
            cell.productDescription = @"A surprise";
            break;
    }
    
    return cell;
}

- (void)changeUpdateQuantity:(id)sender {
    TXHSalesProductCell *cell = sender;
    NSLog(@"updated %@ to %d", cell.productName, cell.quantity.integerValue);
}

@end
