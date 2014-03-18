//
//  TXHSalesSummaryViewController.m
//  TicketingHub
//
//  Created by Mark on 13/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesSummaryViewController.h"

#import "TXHSalesCompletionViewController.h"
#import "TXHSalesSummaryItemCell.h"
#import "TXHSalesSummaryHeader.h"
#import "TXHSalesSummaryFooter.h"
#import "TXHSalesTimerViewController.h"

#import "TXHProductsManager.h"
#import "TXHOrderManager.h"

@interface TXHSalesSummaryViewController () <UICollectionViewDelegateFlowLayout, TXHSalesSummaryHeaderDelegate>

@property (readwrite, nonatomic, getter = isValid) BOOL valid;

// A mutable collection of sections indicating their expanded status.
@property (strong, nonatomic) NSMutableArray *expandedSections;
@property (strong, nonatomic) NSArray        *tickets;

@end

@implementation TXHSalesSummaryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.valid = YES;
    
    [self loadTickets];
}

#pragma mark - accessors

- (void)setTickets:(NSArray *)tickets
{
    _tickets = tickets;
    
    [self setupExpandedSectionsInfo];
    
    [self.collectionView reloadData];
}

- (void)setupExpandedSectionsInfo
{
    self.expandedSections = [NSMutableArray array];
    
    for (int i = 0; i < [self.tickets count]; i++)
    {
        NSNumber *value = (i == 0) ? @YES : @NO;
        [self.expandedSections addObject:value];
    }
}

#pragma mark - private methods

- (void)loadTickets
{
    self.tickets = [[[TXHORDERMANAGER order] tickets] allObjects];
}

- (TXHTicket *)ticketAtIndex:(NSInteger )index
{
    return self.tickets[index];
}

- (NSString *)titleForTicket:(TXHTicket *)ticket
{
    NSString *tierTitle    = ticket.tier.name;
    NSString *customerName = ticket.customer.fullName;
    
    if (customerName)
    {
        return [NSString stringWithFormat:@"%@ (%@)",customerName,tierTitle];
    }
    
    return tierTitle;
}

- (BOOL)isSectionExpanded:(NSInteger)sectionIndex
{
    return [self.expandedSections[sectionIndex] boolValue];
}

- (void)setSection:(NSInteger)sectionIndex expanded:(BOOL)expanded
{
    self.expandedSections[sectionIndex] = @(expanded);
}

#pragma mark - Collection View Datasource & Delegate methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.expandedSections.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    TXHTicket *ticket = [self ticketAtIndex:section];
    
    return [ticket.upgrades count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    TXHSalesSummaryItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SummaryItemCell" forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader)
    {
        TXHSalesSummaryHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                           withReuseIdentifier:@"SalesSummaryHeader"
                                                                                  forIndexPath:indexPath];
        [self configureHeader:header atIndexPath:indexPath];
        
        return header;
        
    }
    else if (kind == UICollectionElementKindSectionFooter)
    {
        TXHSalesSummaryFooter *footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                           withReuseIdentifier:@"SalesSummaryFooter"
                                                                                  forIndexPath:indexPath];
        
        if ([collectionView numberOfSections] - 1 == indexPath.section)
        {
            TXHOrder *order = [TXHORDERMANAGER order];
            
            [footer setTaxPriceText:[TXHPRODUCTSMANAGER priceStringForPrice:[order tax]]];
            [footer setTotalPriceText:[TXHPRODUCTSMANAGER priceStringForPrice:[order total]]];
        }
        return footer;
    }
    
    return nil;
}

// TODO: fucked a bit, make it better!
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if ([collectionView numberOfSections] - 1 == section)
    {
        return CGSizeMake(collectionView.width, 60);
    }
    
    return CGSizeMake(collectionView.width, 1);
}

- (void)makeCellVisible:(id)sender
{
    UICollectionViewCell *cell = sender;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
}

- (void)configureCell:(TXHSalesSummaryItemCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    TXHTicket *ticket = [self ticketAtIndex:indexPath.section];
    TXHUpgrade *upgrade = [ticket.upgrades allObjects][indexPath.item];
    
    [cell setTitle:upgrade.name];
    [cell setPrice:[TXHPRODUCTSMANAGER priceStringForPrice:[upgrade price]]];
}

- (void)configureHeader:(TXHSalesSummaryHeader *)header atIndexPath:(NSIndexPath *)indexPath
{
    TXHTicket *ticket = [self ticketAtIndex:indexPath.section];

    header.delegate         = self;
    header.ticketTitle      = [self titleForTicket:ticket];
    header.ticketTotalPrice = [TXHPRODUCTSMANAGER priceStringForPrice:[ticket totalPrice]];
    header.expanded         = [self isSectionExpanded:indexPath.section];
    header.section          = indexPath.section;
    header.canExpand        = ([ticket.upgrades count] > 0);
}

#pragma mark - TXHSalesSummaryHeaderDelegate

- (void)txhSalesSummaryHeaderIsExpandedDidChange:(TXHSalesSummaryHeader *)header
{
    [self setSection:header.section expanded:header.isExpanded];
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:header.section]];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL expanded = [self isSectionExpanded:indexPath.section];
    
    CGSize size = CGSizeMake(collectionView.width, expanded ? 20.0 : 0.0f);
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    TXHTicket *ticket = [self ticketAtIndex:section];

    if ([ticket.upgrades count] && [self isSectionExpanded:section])
        return UIEdgeInsetsMake(0, 0, 10, 0);
    
    return UIEdgeInsetsZero;
}

#pragma mark - TXHSalesContentsViewControllerProtocol

- (void)finishStepWithCompletion:(void (^)(NSError *error))blockName
{
    blockName(nil);
}

@end
