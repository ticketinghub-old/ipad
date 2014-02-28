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

@interface TXHSalesTicketTiersViewController () <UITextFieldDelegate, TXHSalesTicketTierCellDelegate>

@property (assign, nonatomic) BOOL checkingCoupon;

@property (weak, nonatomic) IBOutlet UITextField *couponTextField;

@property (assign, nonatomic, getter = isValid) BOOL valid;

@property (strong, nonatomic) NSArray *tiers; // to keep tiers ordered
@property (strong, nonatomic) TXHAvailability *availability;
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
    
    self.couponTextField.text = availability.coupon;
    
    [self.tableView reloadData];
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

#pragma mark - private methods

- (void)showLoadingIndicator
{
    
}

- (void)hideLoadingIndicator
{
    
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

- (void)updateWithCoupon:(NSString *)couponString
{
    __block typeof(self) wself = self;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormat dateFromString:[[TXHPRODUCTSMANAGER selectedAvailability] dateString]];
    
    self.checkingCoupon = YES;
    
    [TXHTICKETINHGUBCLIENT availabilitiesForProduct:[TXHPRODUCTSMANAGER selectedProduct]
                                           fromDate:date
                                             toDate:nil
                                             coupon:couponString
                                         completion:^(NSArray *availabilities, NSError *error) {
                                             
                                             TXHAvailability *availability = [TXHPRODUCTSMANAGER selectedAvailability];

                                             for (TXHAvailability *newAvilability in availabilities)
                                             {
                                                 if ([newAvilability.dateString isEqualToString:[availability dateString]] &&
                                                     [newAvilability.timeString isEqualToString:[availability timeString]])
                                                 {
                                                     newAvilability.coupon = couponString;
                                                     [TXHPRODUCTSMANAGER setSelectedAvailability:newAvilability];
                                                     break;
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

- (NSInteger)maximumQuantityForTier:(TXHTier*)tier
{
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
    [TXHORDERMANAGER reserveTicketsWithTierQuantities:self.quantities
                                         availability:self.availability
                                           completion:^(TXHOrder *order, NSError *error) {
                                           
                                               if (error)
                                               {
                                                   // TODO: handle error
                                               }
                                               
                                               blockName(error);
                                          
                                           }];
    
}

#pragma mark - UITextFieldDelegat

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{

    if ([textField.text length])
    {
        [self updateWithCoupon:textField.text];
    }
    
    return YES;
}

@end
