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
#import "TXHProductsManager.h"
@interface TXHSalesTicketTiersViewController () <UITextFieldDelegate>

@property (strong, nonatomic) NSArray *tiers;
@property (strong, nonatomic) NSDate *selectedDate;
@property (strong, nonatomic) NSMutableDictionary *quantities;

@end

@implementation TXHSalesTicketTiersViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
 
    self.quantities = [NSMutableDictionary dictionary];
    
    if ([TXHPRODUCTSMANAGER selectedProduct])
    {
        [self loadTickers];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productChanged:) name:TXHProductChangedNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TXHProductChangedNotification object:nil];
}

- (void)productChanged:(NSNotification *)note
{
    [self loadTickers];
    
}

- (void)loadTickers
{
    __weak typeof(self) wself = self;
    
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormat dateFromString:@"2014-02-20"];

    
    [TXHTICKETINHGUBCLIENT availabilitiesForProduct:[TXHPRODUCTSMANAGER selectedProduct]
                                           fromDate:date
                                             toDate:nil
                                         completion:^(NSArray *availabilities, NSError *error) {
                                             TXHAvailability *availability = [availabilities lastObject];
                                             NSArray *tiers = [availability.tiers allObjects];
                                             wself.tiers = tiers;
                                             [wself.tableView reloadData];
                                         }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tiers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TXHSalesTicketTierCell";
    TXHSalesTicketTierCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(TXHSalesTicketTierCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

    TXHTier *tier = self.tiers[indexPath.row];
    cell.tier = tier;
    cell.quantityChangedHandler = ^(NSDictionary *quantity) {
        [self updateQuantitiesWithDictionary:quantity];
    };
}

- (void)updateQuantitiesWithDictionary:(NSDictionary *)dic
{
    for (NSString *key in dic)
    {
        [self.quantities setObject:dic[key] forKey:key];
    }
}

#pragma mark - validation

- (BOOL)hasQuantitiesSelected
{
    for (NSNumber *quantity in [self.quantities allValues])
        if ([quantity integerValue] > 0)
            return YES;
    
    return NO;
}

@end
