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

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
#pragma unused (section)
    UIView* customView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, tableView.bounds.size.width, 100.0f)];
//    customView.backgroundColor = [UIColor clearColor];
    
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 0.0f, tableView.bounds.size.width - 20.0f, 100.0f)];
    headerLabel.textColor = [UIColor colorWithRed:19.0f / 255.0f
                                            green:58.0f / 255.0f
                                             blue:81.0f / 255.0f
                                            alpha:1.0f];
    headerLabel.font = [UIFont systemFontOfSize:35];
    headerLabel.text = NSLocalizedString(@"Select your tickets", @"Select your tickets");
    
    [customView addSubview:headerLabel];
    
    // Add a dviding 'line' along the bottom of this view
    UIView *dividingline = [[UIView alloc] initWithFrame:CGRectMake(14.0f, 99.0f, tableView.bounds.size.width - 14.0f, 1.0f)];
    dividingline.backgroundColor = tableView.separatorColor;
    [customView addSubview:dividingline];
    
    return customView;
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

@end
