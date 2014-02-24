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
@interface TXHSalesTicketTiersViewController () <UITextFieldDelegate, TXHSalesTicketTierCellDelegate>

@property (assign, nonatomic, getter = isValid) BOOL valid;

@property (strong, nonatomic) TXHAvailability *availability;
@property (strong, nonatomic) NSArray *tiers;
@property (strong, nonatomic) NSDate *selectedDate;
@property (strong, nonatomic) NSMutableDictionary *quantities;

@end

@implementation TXHSalesTicketTiersViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
 
    self.quantities = [NSMutableDictionary dictionary];
    
    if ([TXHPRODUCTSMANAGER selectedProduct] && [TXHPRODUCTSMANAGER selectedAvailability])
    {
        self.availability = [TXHPRODUCTSMANAGER selectedAvailability];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(availabilityChanged:) name:TXHAvailabilityChangedNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TXHAvailabilityChangedNotification object:nil];
}

- (void)availabilityChanged:(NSNotification *)note
{
    self.availability = note.userInfo[TXHSelectedAvailability];
}

- (void)setAvailability:(TXHAvailability *)availability
{
    _availability = availability;
    
    self.tiers = [availability.tiers allObjects];
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

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
    cell.delegate = self;
    
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
    self.valid = [self hasQuantitiesSelected];
}

#pragma mark - validation

- (BOOL)hasQuantitiesSelected
{
    BOOL atLeastOneTicketSelected;
    
    for (NSNumber *quantity in [self.quantities allValues])
        if ([quantity integerValue] > 0)
            atLeastOneTicketSelected = YES;
    
    return atLeastOneTicketSelected;
}

#pragma mark - TXHSalesTicketTierCellDelegate

- (NSInteger)maximumQuantityForTier:(TXHTier*)tier
{
    if (!self.availability.limitValue)
        return tier.limitValue;
    
    NSInteger totalQuantityWithoutaTier = 0;
    
    // sum up quantity without the one from arg
    for (NSString *tierId in self.quantities)
        if (![tierId isEqualToString:tier.tierId])
            totalQuantityWithoutaTier += [self.quantities[tierId] integerValue];
    
    NSInteger availabilityLImit = self.availability.limitValue - totalQuantityWithoutaTier;
    
    return MIN(availabilityLImit, tier.limitValue);
}

@end
