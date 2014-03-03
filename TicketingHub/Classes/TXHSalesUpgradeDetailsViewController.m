//
//  TXHSalesUpgradeDetailsViewController.m
//  TicketingHub
//
//  Created by Mark on 12/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesUpgradeDetailsViewController.h"

#import "TXHSalesCompletionViewController.h"
#import "TXHSalesTimerViewController.h"
#import "TXHSalesUpgradeCell.h"
#import "TXHSalesUpgradeHeader.h"

#import "TXHOrderManager.h"
#import "TXHProductsManager.h"
#import <iOS-api/TXHUpgrade.h>
#import <iOS-api/TXHTicket.h>
#import <iOS-api/TXHCustomer.h>

@interface TXHSalesUpgradeDetailsViewController () <UICollectionViewDelegateFlowLayout, TXHSalesUpgradeHeaderDelegate>

@property (readwrite, nonatomic, getter = isValid) BOOL valid;

@property (strong, nonatomic) NSDictionary   *upgrades;
@property (strong, nonatomic) NSMutableArray *expandedSections;
@property (strong, nonatomic) NSMutableSet   *selectedUpgrades;

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@end

@implementation TXHSalesUpgradeDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.valid = YES;
    
    [self loadUpgrades];
}

#pragma mark - accessors

- (void)setUpgrades:(NSDictionary *)upgrades
{
    _upgrades = upgrades;
    
    self.selectedUpgrades = [NSMutableSet set];
    
    [self setupExpandedSectionsInfo];
    
    [self.collectionView reloadData];
}

- (UIActivityIndicatorView *)activityIndicator
{
    if (!_activityIndicator)
    {
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:self.view.bounds];
        indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        indicatorView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        indicatorView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        indicatorView.hidesWhenStopped = YES;
        [self.view addSubview:indicatorView];
        _activityIndicator = indicatorView;
    }
    return _activityIndicator;
}

#pragma mark - private methods

- (void)showLoadingIndicator
{
    [self.activityIndicator startAnimating];
}

- (void)hideLoadingIndicator
{
    [self.activityIndicator stopAnimating];
}

- (void)loadUpgrades
{
    __weak typeof(self) wself = self;
    
    [TXHORDERMANAGER upgradesForCurrentOrderWithCompletion:^(NSDictionary *upgrades, NSError *error) {
        wself.upgrades = upgrades;
    }];
}


- (void)setupExpandedSectionsInfo
{
    self.expandedSections = [NSMutableArray array];
    
    for (int i = 0; i < [self.upgrades count]; i++)
    {
        NSNumber *value = (i == 0) ? @YES : @NO;
        [self.expandedSections addObject:value];
    }
}

- (TXHUpgrade *)upgreadeAtIndexPath:(NSIndexPath *)indexpath
{
    return [self.upgrades allValues][indexpath.section][indexpath.item];
}

- (TXHTicket *)ticketForIndexPath:(NSIndexPath *)indexPath
{
    NSString *ticketID = [self.upgrades allKeys][indexPath.section];
    return [TXHORDERMANAGER ticketFromOrderWithID:ticketID];
}

- (BOOL)isUpgradeSelected:(TXHUpgrade *)upgrade
{
    return [self.selectedUpgrades containsObject:upgrade];
}

- (void)toggleUpgradeSelection:(TXHUpgrade *)upgrade
{
    if ([self.selectedUpgrades containsObject:upgrade])
        [self.selectedUpgrades removeObject:upgrade];
    else
        [self.selectedUpgrades addObject:upgrade];
}

- (BOOL)isSectionExpanded:(NSInteger)sectionIndex
{
    return [self.expandedSections[sectionIndex] boolValue];
}

- (void)setSection:(NSInteger)sectionIndex expanded:(BOOL)expanded
{
    self.expandedSections[sectionIndex] = @(expanded);
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

- (NSDictionary *)buildUpgradesInfo
{
    NSMutableDictionary *upgradesInfo = [NSMutableDictionary dictionary];
    
    for (NSString *ticketId in self.upgrades)
    {
        NSMutableArray *selectedUpgrades = [NSMutableArray array];
        for (TXHUpgrade *upgrade in self.upgrades[ticketId])
        {
            if ([self isUpgradeSelected:upgrade]) {
                [selectedUpgrades addObject:upgrade.upgradeId];
            }
        }
        if ([selectedUpgrades count])
            upgradesInfo[ticketId] = selectedUpgrades;
    }
    
    return upgradesInfo;
}

#pragma mark - Collection View Datasource & Delegate methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.expandedSections.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[[self.upgrades allValues] objectAtIndex:section] count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TXHSalesUpgradeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TXHSalesUpgradeCell" forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];

    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader)
    {
        TXHSalesUpgradeHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                           withReuseIdentifier:@"TXHSalesUpgradeHeader"
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

- (void)configureCell:(TXHSalesUpgradeCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    TXHUpgrade *upgrade = [self upgreadeAtIndexPath:indexPath];

    cell.upgradeName        = upgrade.name;
    cell.upgradeDescription = upgrade.upgradeDescription;
    cell.upgradePrice       = [TXHPRODUCTSMANAGER priceStringForPrice:upgrade.price];
    cell.chosen             = [self isUpgradeSelected:upgrade];
}

- (void)configureHeader:(TXHSalesUpgradeHeader *)header atIndexPath:(NSIndexPath *)indexPath
{
    TXHTicket *ticket = [self ticketForIndexPath:indexPath];
    
    header.delegate    = self;
    header.ticketTitle = [self titleForTicket:ticket];
    header.expanded    = [self isSectionExpanded:indexPath.section];
    header.section     = indexPath.section;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TXHUpgrade *upgrade = [self upgreadeAtIndexPath:indexPath];
    
    [self toggleUpgradeSelection:upgrade];
    
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL expanded = [self isSectionExpanded:indexPath.section];
    
    CGSize size = CGSizeMake(220.0f, expanded ? 100.0f : 0.0f);
    return size;
}


#pragma mark - TXHSalesUpgradeHeaderDelegate

- (void)txhSalesUpgradeHeaderIsExpandedDidChange:(TXHSalesUpgradeHeader *)header
{
    [self setSection:header.section expanded:header.isExpanded];
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:header.section]];
}

#pragma mark - TXHSalesContentsViewControllerProtocol

- (void)finishStepWithCompletion:(void (^)(NSError *error))blockName
{
    NSDictionary *upgradesInfo = [self buildUpgradesInfo];
    
    if (![upgradesInfo count])
    {
        blockName(nil);
        return;
    } 
    
    [self showLoadingIndicator];
    
    [TXHORDERMANAGER updateOrderWithUpgradesInfo:upgradesInfo
                                       completion:^(TXHOrder *order, NSError *error) {
                                           
                                           [self hideLoadingIndicator];
                                           
                                           if (error) {
                                               [self.collectionView reloadData];
                                           }
                                           blockName(error);
                                       }];
    
}

@end
