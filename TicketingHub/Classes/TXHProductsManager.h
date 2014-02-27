//
//  TXHProductsManager.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 19/02/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iOS-api/TXHProduct.h>

#import "ProductListControllerNotifications.h"

#define TXHPRODUCTSMANAGER [TXHProductsManager sharedManager]

@interface TXHProductsManager : NSObject

@property (strong, nonatomic) TXHProduct *selectedProduct;
@property (strong, nonatomic) TXHAvailability *selectedAvailability;

+ (instancetype)sharedManager;
+ (NSFetchedResultsController *)productsFetchedResultsController;

- (NSString *)priceStringForPrice:(NSNumber *)price;

@end
