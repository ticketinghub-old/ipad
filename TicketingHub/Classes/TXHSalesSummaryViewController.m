//
//  TXHSalesSummaryViewController.m
//  TicketingHub
//
//  Created by Mark on 13/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesSummaryViewController.h"

#import "TXHSalesCompletionViewController.h"
#import "TXHSalesSummaryCell.h"
#import "TXHSalesSummaryExtraProductsCell.h"
#import "TXHSalesSummaryHeader.h"
#import "TXHSalesTimerViewController.h"

#import "TXHProductsManager.h"
#import "TXHOrderManager.h"
#import <iOS-api/TXHOrder.h>
#import <iOS-api/TXHTier.h>
#import <iOS-api/TXHTicket.h>
#import <iOS-api/TXHCustomer.h>

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
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    TXHSalesSummaryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TXHSalesSummaryCell" forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader)
    {
        TXHSalesSummaryHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                           withReuseIdentifier:@"TXHSalesSummaryHeader"
                                                                                  forIndexPath:indexPath];
        [self configureHeader:header atIndexPath:indexPath];
        
        return header;
        
    }
    else if (kind == UICollectionElementKindSectionFooter)
    {
        UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                              withReuseIdentifier:@"TXHSalesUpgradeFooter"
                                                                                     forIndexPath:indexPath];
        return footer;
    }
    
    return nil;
}

- (void)makeCellVisible:(id)sender {
    UICollectionViewCell *cell = sender;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
}

- (void)configureCell:(TXHSalesSummaryCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    TXHTicket *ticket = [self ticketAtIndex:indexPath.section];
    cell.ticket = ticket;
}

- (void)configureHeader:(TXHSalesSummaryHeader *)header atIndexPath:(NSIndexPath *)indexPath
{
    TXHTicket *ticket = [self ticketAtIndex:indexPath.section];

    header.delegate         = self;
    header.ticketTitle      = [self titleForTicket:ticket];
    header.ticketTotalPrice = [TXHPRODUCTSMANAGER priceStringForPrice:[ticket totalPrice]];
    header.expanded         = [self isSectionExpanded:indexPath.section];
    header.section          = indexPath.section;
}

#pragma mark - TXHSalesSummaryHeaderDelegate

- (void)txhSalesSummaryHeaderIsExpandedDidChange:(TXHSalesSummaryHeader *)header
{
    [self setSection:header.section expanded:header.isExpanded];
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:header.section]];
}

#pragma mark - Action methods

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL expanded = [self isSectionExpanded:indexPath.section];
    
    CGSize size = CGSizeMake(550.0f, expanded ? 112.0f : 0.0f);
    return size;
}

- (void)finishStepWithCompletion:(void (^)(NSError *error))blockName
{
    blockName(nil);
}

@end
