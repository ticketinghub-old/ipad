//
//  TXHSalesUpgradeCell.m
//  TicketingHub
//
//  Created by Mark on 12/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesUpgradeCell.h"
#import "TXHProductsManager.h"
#import <iOS-api/TXHUpgrade.h>
#import <iOS-api/TXHTier.h>


#import "TXHSalesUpgradeSelectAllCell.h"
#import "TXHSalesUpgradeTicketCell.h"


@interface TXHSalesUpgradeCell () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic, readwrite) TXHUpgrade *upgrade;
@property (strong, nonatomic, readwrite) NSArray *tickets;

@property (weak, nonatomic) IBOutlet UILabel *upgradeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *upgradeDescriptionLabel;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSMutableSet *selectedTickets;

@end

@implementation TXHSalesUpgradeCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.collectionView.allowsMultipleSelection = YES;
}

- (void)setUpgrade:(TXHUpgrade *)upgrade withTickets:(NSArray *)tickets selectedTickets:(NSArray *)selectedTickets
{
    self.upgrade = upgrade;
    self.tickets = tickets;
    self.selectedTickets = [NSMutableSet setWithArray:selectedTickets];
    
    [self.collectionView reloadData];
}

- (void)setUpgrade:(TXHUpgrade *)upgrade
{
    _upgrade = upgrade;
 
    self.upgradeNameLabel.text        = upgrade.name;
    self.upgradeDescriptionLabel.text = upgrade.upgradeDescription;
}

- (BOOL)areAllTicketsSelected
{
    return [self.selectedTickets isEqualToSet:[NSSet setWithArray:self.tickets]];
}

#pragma mark - tickets selection

- (void)selectTicket:(TXHTicket *)ticket
{
    [self.selectedTickets addObject:ticket];

    [self.collectionView reloadData];
    [self selectedTicketsChanged];
}

- (void)deselectTicket:(TXHTicket *)ticket
{
    [self.selectedTickets removeObject:ticket];

    [self.collectionView reloadData];
    [self selectedTicketsChanged];
}

- (void)selectTickets:(NSArray *)tickets
{
    [self.selectedTickets addObjectsFromArray:tickets];
    
    [self.collectionView reloadData];
    [self selectedTicketsChanged];
}

- (void)deselectTickets:(NSArray *)tickets
{
    [self.selectedTickets minusSet:[NSSet setWithArray:tickets]];

    [self.collectionView reloadData];
    [self selectedTicketsChanged];
}

- (void)selectedTicketsChanged
{
    if ([self.delegate respondsToSelector:@selector(txhSalesUpgradeCell:changedTicketsSelection:forUpgrade:)])
        [self.delegate txhSalesUpgradeCell:self changedTicketsSelection:[self.selectedTickets allObjects] forUpgrade:self.upgrade];
}

- (NSMutableSet *)selectedTickets
{
    if (!_selectedTickets)
        _selectedTickets = [NSMutableSet set];

    return _selectedTickets;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1 + [self.tickets count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == 0)
    {
        TXHSalesUpgradeSelectAllCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SelectAllCell" forIndexPath:indexPath];
        
        if ((cell.selected = [self areAllTicketsSelected]))
            [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:0];
        
        return cell;
    }
    else
    {
        TXHTicket *ticket = [self ticketAtIndexPath:indexPath];
        TXHSalesUpgradeTicketCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TicketCell" forIndexPath:indexPath];
        
        if ((cell.selected = [self.selectedTickets containsObject:ticket]))
            [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:0];

        [self configureTicketCell:cell withTicket:ticket];
        
        return cell;
    }
    
    return nil;
}

- (TXHTicket *)ticketAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = (indexPath.item - 1);
    
    if (![self.tickets count])
        return nil;
    
    if (index < [self.tickets count])
        return self.tickets[index];
    
    return nil;
}


- (void)configureTicketCell:(TXHSalesUpgradeTicketCell *)cell withTicket:(TXHTicket *)ticket
{
    [cell setTitle:ticket.tier.name];
    [cell setSubtitle:[self.productManager priceStringForPrice:ticket.price]];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == 0)
    {
        [self selectTickets:self.tickets];
    }
    else
    {
        TXHTicket *ticket = [self ticketAtIndexPath:indexPath];
        [self selectTicket:ticket];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == 0)
    {
        [self deselectTickets:self.tickets];
    }
    else
    {
        TXHTicket *ticket = [self ticketAtIndexPath:indexPath];
        [self deselectTicket:ticket];
    }
}

@end
