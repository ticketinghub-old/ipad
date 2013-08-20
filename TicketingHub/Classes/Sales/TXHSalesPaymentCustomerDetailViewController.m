//
//  TXHSalesPaymentCustomerDetailViewController.m
//  TicketingHub
//
//  Created by Mark on 14/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesPaymentCustomerDetailViewController.h"

#import "TXHTextEntryTableViewCell.h"

@interface TXHSalesPaymentCustomerDetailViewController ()

@end

@implementation TXHSalesPaymentCustomerDetailViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    static NSString *CellIdentifier = @"TXHSalesPaymentCustomerDetailsTextCell";
    TXHTextEntryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    switch (indexPath.row) {
        case 0:
            cell.textField.placeholder = @"First Name";
            break;
        case 1:
            cell.textField.placeholder = @"Last Name";
            break;
        case 2:
            cell.textField.placeholder = @"Email";
            cell.textField.text = @"olly@me.com";
            break;
        case 3:
            cell.textField.placeholder = @"Telephone number";
            cell.textField.text = @"+44abcdefgh992123";
            cell.errorMessage = @"invalid number";
            break;
        case 4:
            cell.textField.placeholder = @"Country";
            break;
        default:
            break;
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [tableView dequeueReusableCellWithIdentifier:@"TXHSalesPaymentCustomerDetailsHeaderCell"];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
#pragma unused (tableView, indexPath)
    return NO;
}
- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath {
#pragma unused (tableView, indexPath)
    return NO;
}

@end
