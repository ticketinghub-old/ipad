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

@property (assign, nonatomic, getter = isValid) BOOL valid;

@property (strong, nonatomic) NSArray             *tiers; // to keep tiers ordered
@property (strong, nonatomic) TXHAvailability     *availability;
@property (strong, nonatomic) NSMutableDictionary *quantities;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalValueLabel;

@property (strong, nonatomic) TXHActivityLabelView *activityView;

@end

@implementation TXHSalesTicketTiersViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
 
    self.quantities = [NSMutableDictionary dictionary];
    
    [self registerForAvailabilityChangeNotification];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self updateView];
}

- (void)dealloc
{
    [self unregisterFromAvailabilityChangeNotification];
}


- (void)registerForAvailabilityChangeNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(availabilityChanged:) name:TXHAvailabilityChangedNotification object:nil];
}

- (void)unregisterFromAvailabilityChangeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TXHAvailabilityChangedNotification object:nil];
}

- (void)availabilityChanged:(NSNotification *)note
{
    self.availability = note.userInfo[TXHSelectedAvailabilityKey];
}

- (void)setProductManager:(TXHProductsManager *)productManager
{
    _productManager = productManager;
    
    self.availability = [productManager selectedAvailability];
}

- (void)setAvailability:(TXHAvailability *)availability
{
    _availability = availability;
    
    self.tiers = [availability.tiers allObjects];
    
    [self.collectionView reloadData];
}

- (TXHTier *)tierAtIndexPath:(NSIndexPath *)indexPath
{
    return self.tiers[indexPath.row];
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

    cell.delegate = self;
    
    cell.title            = tier.name;
    cell.subtitle         = tier.tierDescription;
    cell.priceString      = [self.productManager priceStringForPrice:tier.price];
    cell.tierIdentifier   = tier.internalTierId;
    cell.selectedQuantity = [self quantityForTicketIdentifier:tier.internalTierId];
    
    __weak typeof(self) wself = self;
    cell.quantityChangedHandler = ^(NSDictionary *quantity) {
        [wself updateQuantitiesWithDictionary:quantity];
    };
}

- (void)updateQuantitiesWithDictionary:(NSDictionary *)dic
{
    for (NSString *key in dic)
    {
        [self.quantities setObject:dic[key] forKey:key];
    }
    
    [self updateView];
}

- (void)updateView
{
    self.valid = [self hasQuantitiesSelected];

    [self updateTotalLabel];
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

- (void)updateWithCoupon:(NSString *)couponString
{
    __block typeof(self) wself = self;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormat dateFromString:[[self.productManager selectedAvailability] dateString]];
    
    self.checkingCoupon = YES;
    
    [self.productManager fetchSelectedProductAvailabilitiesFromDate:date
                                                             toDate:nil
                                                         withCoupon:couponString
                                                         completion:^(NSArray *availabilities, NSError *error) {
                                                             
                                                             TXHAvailability *availability = [wself.productManager selectedAvailability];
                                                             
                                                             for (TXHAvailability *newAvilability in availabilities)
                                                             {
                                                                 if ([newAvilability.dateString isEqualToString:[availability dateString]] &&
                                                                     [newAvilability.timeString isEqualToString:[availability timeString]])
                                                                 {
                                                                     // checking if any of tiers has discount set to determin if coupon worked
                                                                     BOOL hasDiscount = NO;
                                                                     for (TXHTier  *tier in availability.tiers)
                                                                         if ([tier.discount integerValue] > 0)
                                                                             hasDiscount = YES;
                                                                     
                                                                     if (hasDiscount)
                                                                     {
                                                                         newAvilability.coupon = couponString;
                                                                         [wself.productManager setSelectedAvailability:newAvilability];
                                                                         break;
                                                                     }
                                                                 }
                                                             }
                                                             wself.checkingCoupon = NO;
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

#pragma mark - UITextFieldDelegat

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField.text length])
    {
        [self updateWithCoupon:textField.text];
    }
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - TXHSalesTicketTierCellDelegate

- (NSInteger)maximumQuantityForCell:(TXHSalesTicketTierCell *)cell
{
    NSIndexPath *cellIndexPath = [self.collectionView indexPathForCell:cell];
    TXHTier *tier = [self tierAtIndexPath:cellIndexPath];
    
    if (!self.availability.limitValue)
        return tier.limitValue;
    
    NSInteger totalQuantityWithoutaTier = 0;
    
    // sum up quantity without the one from arg
    for (NSString *internalTierId in self.quantities)
        if (![internalTierId isEqualToString:tier.internalTierId])
            totalQuantityWithoutaTier += [self.quantities[internalTierId] integerValue];
    
    NSInteger availabilityLImit = self.availability.limitValue - totalQuantityWithoutaTier;
    
    return MIN(availabilityLImit, tier.limitValue);
}

#pragma mark - TXHSalesContentsViewControllerProtocol

- (void)finishStepWithCompletion:(void (^)(NSError *error))blockName
{
    [self.activityView showWithMessage:NSLocalizedString(@"SALESMAN_QUANTITIES_RESERVING_TICKETS_MESSAGE", nil)
                       indicatorHidden:NO];
    
    
    __weak typeof(self) wself = self;
    [self.orderManager reserveTicketsWithTierQuantities:self.quantities
                                         availability:self.availability
                                           completion:^(TXHOrder *order, NSError *error) {
                                               [wself.activityView hide];
                                               
                                               if (error)
                                               {
                                                   [self showErrorWithTitle:NSLocalizedString(@"ERROR_TITLE", nil)
                                                                    message:error.localizedDescription
                                                                     action:^{
                                                                         if (blockName)
                                                                             blockName(error);
                                                                     }];
                                               }
                                               else if (blockName)
                                                   blockName(nil);
                                          
                                           }];
    
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
