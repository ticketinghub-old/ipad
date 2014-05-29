//
//  TXHProductsManager.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 19/02/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TXHProductsManagerNotifications.h"

#import "TXHTicketingHubManager.h"

#define TXHPRODUCTSMANAGER [TXHProductsManager sharedManager]

@interface TXHProductsManager : NSObject

@property (strong, nonatomic) TXHProduct *selectedProduct;
@property (strong, nonatomic) TXHAvailability *selectedAvailability;

@property (strong, nonatomic) TXHTicketingHubManager *txhManager;

+ (instancetype)sharedManager;
+ (NSFetchedResultsController *)productsFetchedResultsControllerWithManagedContext:(NSManagedObjectContext *)context;

- (NSString *)priceStringForPrice:(NSNumber *)price;

- (void)fetchSelectedProductAvailabilitiesFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate withCoupon:(NSString *)coupon completion:(void(^)(NSArray *availabilities, NSError *error))completion;

- (void)ticketRecordsValidFromDate:(NSDate *)date includingAttended:(BOOL)attended query:(NSString *)query paginationInfo:(TXHPartialResponsInfo *)info completion:(void(^)(TXHPartialResponsInfo *info, NSArray *ricketRecords, NSError *error))completion;
- (void)ticketRecordsForAvailability:(TXHAvailability *)availability andQuery:(NSString *)query completion:(void(^)(NSArray *ricketRecords, NSError *error))completion;

- (void)setTicket:(TXHTicket *)ticket attended:(BOOL)attended completion:(void(^)(TXHTicket *ticket, NSError *error))completion;

- (void)searchForTicketWithSeqID:(NSNumber *)seqID completion:(void(^)(TXHTicket *ticket, NSError *error))completion;

- (void)getOrderForTicket:(TXHTicket *)ticket completion:(void(^)(TXHOrder *order, NSError *error))completion;

- (void)getUpdatedOrder:(TXHOrder *)order completion:(void(^)(TXHOrder *order, NSError *error))completion;

- (void)cancelOrder:(TXHOrder *)order completion:(void(^)(TXHOrder *order, NSError *error))completion;

- (void)getOrderForCardMSRData:(NSString *)msrData paginationInfo:(TXHPartialResponsInfo *)info completion:(void (^)(TXHPartialResponsInfo *info, NSArray *orders, NSError *error))completion;
- (void)getOrderForQuery:(NSString *)query paginationInfo:(TXHPartialResponsInfo *)info completion:(void (^)(TXHPartialResponsInfo *info, NSArray *orders, NSError *error))completion;

- (void)availableDatesFrom:(NSDate *)startDate endDate:(NSDate *)endDate completion:(void (^)(NSArray *availableDates, NSError *error))completion;

- (void)getTiresCompletion:(void(^)(NSArray *tiers, NSError *error))completion;

- (void)availabilitiesForISODate:(NSString *)isoDate tickets:(NSArray *)tickets completion:(void(^)(NSArray *availabilities, NSError *error))completion;

@end
