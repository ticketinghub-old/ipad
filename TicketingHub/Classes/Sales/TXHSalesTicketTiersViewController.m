//
//  TXHSalesTicketTiersViewController.m
//  TicketingHub
//
//  Created by Mark on 25/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesTicketTiersViewController.h"

#import "TXHSalesTicketTierCell.h"
#import "TXHServerAccessManager.h"
#import "TXHTicketDetail.h"
#import "TXHTicketTier.h"
#import "TXHVenue.h"

@interface TXHSalesTicketTiersViewController ()

@property (strong, nonatomic) TXHVenue *venue;

@end

@implementation TXHSalesTicketTiersViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        if ([self.delegate respondsToSelector:@selector(quantityChanged:)]) {
            [self.delegate performSelector:@selector(quantityChanged:) withObject:quantity];
        }
    };
}

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    
    UITableViewCell *cell = nil;
    UIView *parentView = textField.superview;
    while (parentView != nil) {
        if ([parentView isKindOfClass:[UITableViewCell class]]) {
            cell = (UITableViewCell *)parentView;
            break;
        }
        parentView = parentView.superview;
    }
    if (cell != nil) {
        [self.tableView scrollToRowAtIndexPath:[self.tableView indexPathForCell:cell]
                              atScrollPosition:UITableViewScrollPositionMiddle
                                      animated:YES];
    }
}

@end
