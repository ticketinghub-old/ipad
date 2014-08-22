//
//  TXHSalesTicketTiersViewController.m
//  TicketingHub
//
//  Created by Mark on 25/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesTicketTiersViewController.h"

#import "TXHSalesTicketTierCell.h"
#import "UIColor+TicketingHub.h"

#import "TXHOrderManager.h"
#import "TXHProductsManager.h"
#import "TXHTicketingHubManager.h"
#import "TXHActivityLabelView.h"
#import <UIAlertView-Blocks/UIAlertView+Blocks.h>



@interface TXHSalesTicketTiersViewController () <UICollectionViewDelegate, UICollectionViewDataSource ,UITextFieldDelegate, TXHSalesTicketTierCellDelegate>

@property (assign, nonatomic) BOOL checkingCoupon;

@property (readwrite, assign, nonatomic, getter = isValid) BOOL valid;
@property (readwrite, assign, nonatomic) BOOL shouldBeSkiped;

@property (strong, nonatomic) NSArray             *tiers; // to keep tiers ordered
@property (strong, nonatomic) NSMutableDictionary *quantities;

@property (weak, nonatomic) IBOutlet UIView *collectionViewContainer;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalValueLabel;

@property (strong, nonatomic) TXHActivityLabelView *activityView;

@end

@implementation TXHSalesTicketTiersViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    [self loadTiers];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self updateView];
    [self updateGradientMask];
}


- (void)setTiers:(NSArray *)tiers
{
    _tiers = tiers;
    
    [self.collectionView reloadData];
}

- (NSMutableDictionary *)quantities
{
    if (!_quantities)
        _quantities = [NSMutableDictionary dictionary];
    return _quantities;
}

- (TXHTier *)tierAtIndexPath:(NSIndexPath *)indexPath
{
    return self.tiers[indexPath.item];
}

- (TXHTier *)tierWithInternalTierId:(NSString *)identifier
{
    for (TXHTier *tier in self.tiers)
    {
        if ([tier.internalTierId isEqualToString:identifier])
            return tier;
    }
    return nil;
}

- (TXHActivityLabelView *)activityView
{
    if (!_activityView)
        _activityView = [TXHActivityLabelView getInstanceInView:self.view];
    
    return _activityView;
}

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.tiers count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TXHSalesTicketTierCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SalesTicketTierCell" forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"CouponHeader" forIndexPath:indexPath];
    
    return view;
}

- (void)configureCell:(TXHSalesTicketTierCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

    TXHTier *tier = [self tierAtIndexPath:indexPath];

    cell.delegate         = self;
    cell.title            = tier.name;
    cell.subtitle         = tier.tierDescription;
    cell.tierIdentifier   = tier.internalTierId;
    cell.selectedQuantity = [self quantityForTicketIdentifier:tier.internalTierId];
    
    __weak typeof(self) wself = self;
    __weak TXHSalesTicketTierCell * bcell = cell;
    cell.quantityChangedHandler = ^(NSDictionary *quantity) {
        [wself updateQuantitiesWithDictionary:quantity];
        
        NSInteger newQuantity = [wself quantityForTicketIdentifier:tier.internalTierId];
        if (newQuantity)
            bcell.priceString = [wself.productManager priceStringForPrice:@([tier.price integerValue] * newQuantity)];
        else
            bcell.priceString = NSLocalizedString(@"SALESMAN_QUANTITIES_SELECT_TICKET_AMOUT_PRICE_LABEL", nil);
    };
}

- (void)updateQuantitiesWithDictionary:(NSDictionary *)dic
{
    for (NSString *key in dic)
        [self.quantities setObject:dic[key] forKey:key];
    
    [self updateView];
}

- (void)updateView
{
    self.valid = [self hasQuantitiesSelected];

    [self updateTotalLabel];
}

- (void)updateGradientMask
{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.collectionViewContainer.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor], (id)[[UIColor clearColor] CGColor], nil];
    gradient.locations = @[@(0.4f), @(0.6f)];
    self.collectionViewContainer.layer.mask = gradient;
}

- (void)updateTotalLabel
{
    CGFloat total = [self totalOrderValue];
    
    self.totalLabel.hidden = total == 0;
    self.totalValueLabel.hidden = total == 0;

    self.totalValueLabel.text =  [self.productManager priceStringForPrice:@(total)];
}

- (CGFloat)totalOrderValue
{
    CGFloat total = 0.0;
    
    for (NSString *tierId in self.quantities)
    {
        TXHTier *tier = [self tierWithInternalTierId:tierId];
        NSInteger quantity = [self.quantities[tierId] integerValue];
        total += quantity * [tier.price integerValue];
    }
    
    return total;
}

- (NSInteger)quantityForTicketIdentifier:(NSString *)ticketIdentifier
{
    NSNumber *quantity = self.quantities[ticketIdentifier];
    
    return [quantity integerValue];
}

- (void)loadTiers
{
    __block typeof(self) wself = self;

    [self.activityView showWithMessage:NSLocalizedString(@"SALESMAN_QUANTITIES_LOADING_TICKETS_MESSAGE", nil)
                       indicatorHidden:NO];
    
    [self.productManager getTiresCompletion:^(NSArray *tiers, NSError *error) {
        [wself.activityView hide];
        wself.tiers = tiers;
        
        if (error)
            [wself showErrorWithTitle:NSLocalizedString(@"ERROR_TITLE", nil)
                              message:error.localizedDescription
                               action:nil];
        
    }];
}

#pragma mark - validation

- (BOOL)hasQuantitiesSelected
{
    BOOL atLeastOneTicketSelected = NO;
    
    for (NSNumber *quantity in [self.quantities allValues])
        if ([quantity integerValue] > 0)
            atLeastOneTicketSelected = YES;
    
    return atLeastOneTicketSelected;
}

#pragma mark - TXHSalesTicketTierCellDelegate

- (NSInteger)maximumQuantityForCell:(TXHSalesTicketTierCell *)cell
{
    NSIndexPath *cellIndexPath = [self.collectionView indexPathForCell:cell];
    TXHTier *tier = [self tierAtIndexPath:cellIndexPath];
    
    return tier.limitValue;
}

#pragma mark - TXHSalesContentsViewControllerProtocol

- (void)finishStepWithCompletion:(void (^)(NSError *error))blockName
{
    self.orderManager.tiersQuantities = self.quantities;
    
    if (blockName)
        blockName(nil);
}

#pragma mark - error helper

- (void)showErrorWithTitle:(NSString *)title message:(NSString *)message action:(void(^)(void))action
{
    [self.activityView hide];
    
    RIButtonItem *cancelItem = [RIButtonItem itemWithLabel:NSLocalizedString(@"ERROR_DISMISS_BUTTON_TITLE", nil)
                                                    action:^{
                                                        if (action)
                                                            action();
                                                    }];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                               cancelButtonItem:cancelItem
                                               otherButtonItems: nil];
    [alertView show];
}


@end
