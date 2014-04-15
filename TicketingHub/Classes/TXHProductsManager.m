//
//  TXHProductsManager.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 19/02/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHProductsManager.h"

#import "NSDate+Additions.h"
#import <iOS-api/TXHNumberFormatterCache.h>

// Declaration of strings declared in TXHProductsManagerNotifications.h
NSString * const TXHProductsChangedNotification     = @"TXHProductsChangedNotification";
NSString * const TXHSelectedProductKey              = @"TXHSelectedProductKey";
NSString * const TXHAvailabilityChangedNotification = @"TXHAvailabilityChangedNotification";
NSString * const TXHSelectedAvailabilityKey         = @"TXHSelectedProductKey";


@interface TXHProductsManager ()

@property (assign, nonatomic, getter = isAvailabilitiesInfoLoaded) BOOL availabilitiesInfoLoaded;

@end

@implementation TXHProductsManager

+ (instancetype)sharedManager
{
    static TXHProductsManager * _sharedManager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[TXHProductsManager alloc] init];
    });
    
    return _sharedManager;
}


+ (NSFetchedResultsController *)productsFetchedResultsControllerWithManagedContext:(NSManagedObjectContext *)context
{
    NSFetchedResultsController *fetchedResultsController;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[TXHProduct entityName]];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:TXHProductAttributes.name ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                   managedObjectContext:context
                                                                     sectionNameKeyPath:nil
                                                                              cacheName:nil];
    
    return fetchedResultsController;
}

- (NSString *)priceStringForPrice:(NSNumber *)price
{
    if (price == nil)
        return nil;
    
    if ([price isEqualToNumber:@0])
        return @"Free";
    
    TXHSupplier *suplier = self.selectedProduct.supplier;
    NSNumberFormatter *formatter = [TXHNUMBERFORMATTERCACHE formatterForSuplier:suplier];
    
    return [formatter stringFromNumber:@([price floatValue] / 100.0)];
}

#pragma mark - accessors

- (void)setSelectedProduct:(TXHProduct *)selectedProduct
{
    _selectedProduct = selectedProduct;
    
    NSDictionary *userInfo;
    
    if (selectedProduct)
        userInfo = @{TXHSelectedProductKey: selectedProduct};
    
    [self.txhManager.client setAuthorizationTokenForSupplier:selectedProduct.supplier];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TXHProductsChangedNotification
                                                        object:self
                                                      userInfo:userInfo];
}

- (void)setSelectedAvailability:(TXHAvailability *)selectedAvailability
{
    _selectedAvailability = selectedAvailability;
    
    NSDictionary *userInfo;
    
    if (selectedAvailability)
        userInfo = @{TXHSelectedAvailabilityKey: selectedAvailability};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TXHAvailabilityChangedNotification
                                                        object:self
                                                      userInfo:userInfo];
}

- (void)fetchSelectedProductAvailabilitiesFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate withCoupon:(NSString *)coupon completion:(void(^)(NSArray *availabilities, NSError *error))completion
{
    [self.txhManager.client availabilitiesForProduct:self.selectedProduct fromDate:fromDate toDate:toDate coupon:coupon completion:completion];
}


- (void)ticketRecordsForAvailability:(TXHAvailability *)availability andQuery:(NSString *)query completion:(void(^)(NSArray *ricketRecords, NSError *error))completion;
{
    [self.txhManager.client ticketRecordsForProduct:self.selectedProduct
                                      availability:availability
                                         withQuery:query
                                        completion:completion];
}

- (void)setTicket:(TXHTicket *)ticket attended:(BOOL)attended completion:(void(^)(TXHTicket *ticket, NSError *error))completion
{
    [self.txhManager.client setTicket:ticket
                            attended:attended
                         withProduct:self.selectedProduct
                          completion:completion];
}

- (void)searchForTicketWithSeqID:(NSNumber *)seqID completion:(void(^)(TXHTicket *ticket, NSError *error))completion
{
    [self.txhManager.client searchForTicketWithSeqId:seqID
                                        withProduct:self.selectedProduct
                                         completion:completion];
}

- (void)getOrderForTicket:(TXHTicket *)ticket completion:(void(^)(TXHOrder *order, NSError *error))completion
{
    [self.txhManager.client getOrderForTicekt:ticket
                                 withProduct:self.selectedProduct
                                  completion:completion];
}

@end

