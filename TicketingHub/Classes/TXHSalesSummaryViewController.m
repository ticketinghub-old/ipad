//
//  TXHSalesSummaryViewController.m
//  TicketingHub
//
//  Created by Mark on 13/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesSummaryViewController.h"

#import "TXHSalesSummaryItemCell.h"
#import "TXHSalesSummaryHeader.h"

#import "TXHProductsManager.h"
#import "TXHOrderManager.h"

#import "TXHOrder+Helpers.h"

@interface TXHSalesSummaryViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (readwrite, nonatomic, getter = isValid) BOOL valid;

@property (strong, nonatomic) NSArray *tickets;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UILabel *subtotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtotalValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *taxLabel;
@property (weak, nonatomic) IBOutlet UILabel *taxValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalValueLabel;

@end

@implementation TXHSalesSummaryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.valid = YES;
    
    [self updateView];
}

- (void)updateView
{
    TXHOrder *order = self.orderManager.order;

    self.totalValueLabel.text    = [self.productManager priceStringForPrice:[order total]];
    self.subtotalValueLabel.text = [self.productManager priceStringForPrice:[order subtotal]];
    self.taxValueLabel.text      = [self.productManager priceStringForPrice:[order tax]];
    self.taxLabel.text           = self.orderManager.order.taxName;
}

#pragma mark - accessors

- (void)setTickets:(NSArray *)tickets
{
    _tickets = tickets;
    
    [self.collectionView reloadData];
}

- (void)setOrderManager:(TXHOrderManager *)orderManager
{
    _orderManager = orderManager;
    
    [self loadTickets];
    
    [self updateView];
}

#pragma mark - private methods

- (void)loadTickets
{
    self.tickets = [[[self.orderManager order] tickets] allObjects];
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
        return [NSString stringWithFormat:@"%@ (%@)",customerName,tierTitle];
    
    return tierTitle;
}

#pragma mark - Collection View Datasource & Delegate methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.tickets count];
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
        UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                              withReuseIdentifier:@"SalesSummaryFooter"
                                                                                     forIndexPath:indexPath];
        footer.hidden = !(indexPath.section < [self.tickets count] - 1); // hide last footer
        return footer;
    }

    return nil;
}

- (void)configureCell:(TXHSalesSummaryItemCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    TXHTicket *ticket = [self ticketAtIndex:indexPath.section];
    TXHUpgrade *upgrade = [ticket.upgrades allObjects][indexPath.item];
    
    [cell setTitle:upgrade.name];
    [cell setPrice:[self.productManager priceStringForPrice:[upgrade price]]];
}

- (void)configureHeader:(TXHSalesSummaryHeader *)header atIndexPath:(NSIndexPath *)indexPath
{
    TXHTicket *ticket = [self ticketAtIndex:indexPath.section];

    header.ticketTitle      = [self titleForTicket:ticket];
    header.ticketTotalPrice = [self.productManager priceStringForPrice:ticket.price];
    header.section          = indexPath.section;
}

#pragma mark - TXHSalesContentsViewControllerProtocol

- (void)finishStepWithCompletion:(void (^)(NSError *error))blockName
{
    if (blockName)
        blockName(nil);
}

@end
