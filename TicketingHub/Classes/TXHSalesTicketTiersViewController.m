//
//  TXHSalesTicketTiersViewController.m
//  TicketingHub
//
//  Created by Mark on 25/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesTicketTiersViewController.h"

#import "TXHSalesTicketTierCell.h"
#import "TXHProductsManager.h"
#import "TXHOrderManager.h"

#import "TXHProductsManager.h"
#import "TXHTicketingHubManager.h"
#import "UIColor+TicketingHub.h"

@interface TXHSalesTicketTiersViewController () <UITextFieldDelegate, TXHSalesTicketTierCellDelegate>

@property (assign, nonatomic) BOOL checkingCoupon;

@property (assign, nonatomic, getter = isValid) BOOL valid;

@property (strong, nonatomic) NSArray             *tiers; // to keep tiers ordered
@property (strong, nonatomic) TXHAvailability     *availability;
@property (strong, nonatomic) NSMutableDictionary *quantities;

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

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
    
    [self.collectionView reloadData];
}

- (void)setCheckingCoupon:(BOOL)checkingCoupon
{
    _checkingCoupon = checkingCoupon;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (checkingCoupon)
        {
            [self showLoadingIndicator];
        }
        else
        {
            [self hideLoadingIndicator];
        }
    });
}

- (TXHTier *)tierAtIndexPath:(NSIndexPath *)indexPath
{
    return self.tiers[indexPath.row];
}

- (UIActivityIndicatorView *)activityIndicator
{
    if (!_activityIndicator)
    {
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:self.view.bounds];
        indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        indicatorView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        indicatorView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
        indicatorView.hidesWhenStopped = YES;
        indicatorView.color = [UIColor txhDarkBlueColor];
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

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.tiers count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TXHSalesTicketTierCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TicketCell" forIndexPath:indexPath];
    
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
    cell.priceString      = [TXHPRODUCTSMANAGER priceStringForPrice:tier.price];
    cell.tierIdentifier   = tier.internalTierId;
    cell.selectedQuantity = [self quantityForTicketIdentifier:tier.internalTierId];
    
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
    NSDate *date = [dateFormat dateFromString:[[TXHPRODUCTSMANAGER selectedAvailability] dateString]];
    
    self.checkingCoupon = YES;
    
    [TXHPRODUCTSMANAGER fetchSelectedProductAvailabilitiesFromDate:date
                                                            toDate:nil
                                                        withCoupon:couponString
                                                        completion:^(NSArray *availabilities, NSError *error) {
                                                            
                                                            TXHAvailability *availability = [TXHPRODUCTSMANAGER selectedAvailability];
                                                            
                                                            for (TXHAvailability *newAvilability in availabilities)
                                                            {
                                                                if ([newAvilability.dateString isEqualToString:[availability dateString]] &&
                                                                    [newAvilability.timeString isEqualToString:[availability timeString]])
                                                                {
                                                                    // checking if any of tiers has discount set to determin if coupon worked
                                                                    BOOL hasDiscount;
                                                                    for (TXHTier  *tier in availability.tiers)
                                                                        if ([tier.discount integerValue] > 0)
                                                                            hasDiscount = YES;
                                                                    
                                                                    if (hasDiscount)
                                                                    {
                                                                        newAvilability.coupon = couponString;
                                                                        [TXHPRODUCTSMANAGER setSelectedAvailability:newAvilability];
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
    BOOL atLeastOneTicketSelected;
    
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
    [self showLoadingIndicator];
    
    [TXHORDERMANAGER reserveTicketsWithTierQuantities:self.quantities
                                         availability:self.availability
                                           completion:^(TXHOrder *order, NSError *error) {
                                           
                                               [self hideLoadingIndicator];
                                               
                                               if (error)
                                               {
                                                   // shouldnt be code error as it was validated before
                                                   DLog(@"%@", [error localizedDescription]);
                                               }
                                               
                                               blockName(error);
                                          
                                           }];
    
}

- (void)setOffsetBottomBy:(CGFloat)offset
{
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, offset, 0);
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

@end
