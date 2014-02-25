//
//  TXHProductsManager.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 19/02/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHProductsManager.h"

#import "TXHTicketingHubManager.h"
#import "NSDate+Additions.h"

// Declaration of strings declared in ProductListControllerNotifications.h
NSString * const TXHProductChangedNotification      = @"TXHProductChangedNotification";
NSString * const TXHSelectedProduct                 = @"TXHSelectedProduct";
NSString * const TXHAvailabilityChangedNotification = @"TXHAvailabilityChangedNotification";
NSString * const TXHSelectedAvailability            = @"TXHSelectedProduct";


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


+ (NSFetchedResultsController *)productsFetchedResultsController
{
    NSFetchedResultsController *fetchedResultsController;
    
    if (!fetchedResultsController) {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[TXHProduct entityName]];
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:TXHProductAttributes.name ascending:YES];
        [fetchRequest setSortDescriptors:@[sortDescriptor]];
        
        fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                       managedObjectContext:TXHTICKETINHGUBCLIENT.managedObjectContext
                                                                         sectionNameKeyPath:nil
                                                                                  cacheName:nil];
    }
    
    return fetchedResultsController;
}

- (void)setSelectedProduct:(TXHProduct *)selectedProduct
{
    _selectedProduct = selectedProduct;
    
    NSDictionary *userInfo;
    
    if (selectedProduct)
        userInfo = @{TXHSelectedProduct: selectedProduct};
        
    [[NSNotificationCenter defaultCenter] postNotificationName:TXHProductChangedNotification
                                                        object:self
                                                      userInfo:userInfo];
}

- (void)setSelectedAvailability:(TXHAvailability *)selectedAvailability
{
    _selectedAvailability = selectedAvailability;
    
    NSDictionary *userInfo;
    
    if (selectedAvailability)
        userInfo = @{TXHSelectedAvailability: selectedAvailability};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TXHAvailabilityChangedNotification
                                                        object:self
                                                      userInfo:userInfo];
}


@end
