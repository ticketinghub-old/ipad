//
//  TXHOrderManager.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 26/02/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHOrderManager.h"
#import "TXHTicketingHubManager.h"
#import <iOS-api/TXHOrder.h>
#import <iOS-api/TXHTicket.h>
#import <iOS-api/TXHCustomer.h>


@interface TXHOrderManager ()

@property (readwrite, strong, nonatomic) TXHOrder *order;

@end

@implementation TXHOrderManager

+ (instancetype)sharedManager
{
    static TXHOrderManager *_sharedManager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[TXHOrderManager alloc] init];
    });
    
    return _sharedManager;
}

#pragma mark accessors

- (void)setOrder:(TXHOrder *)order
{
    _order = order;
}

#pragma mark public methods

- (TXHTicket *)ticketFromOrderWithID:(NSString *)ticketID
{
    for (TXHTicket *ticket in self.order.tickets)
    {
        if ([ticket.ticketId isEqualToString:ticketID]) {
            return ticket;
        }
    }
    return nil;
}

- (void)reserveTicketsWithTierQuantities:(NSDictionary *)tierQuantities availability:(TXHAvailability *)availability completion:(void(^)(TXHOrder *order, NSError *error))completion
{
    __weak typeof(self) wself = self;
    
    [TXHTICKETINHGUBCLIENT reserveTicketsWithTierQuantities:tierQuantities
                                               availability:availability
                                                 completion:^(TXHOrder *order, NSError *error) {
                                                     
                                                     if (order)
                                                     {
                                                         wself.order = order;
                                                     }
                                                     
                                                     if (completion)
                                                         completion(order,error);
                                                 }];

}

- (void)fieldsForCurrentOrderWithCompletion:(void(^)(NSDictionary *fields, NSError *error))completion
{
    __weak typeof(self) wself = self;
    __block NSError *bError;
    __block NSMutableDictionary *fieldsDictionary = [NSMutableDictionary dictionary];
    __block NSInteger loadedItems = 0;
    NSInteger itemsToLoad = [self.order.tickets count];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (TXHTicket *ticket in wself.order.tickets)
        {
            [TXHTICKETINHGUBCLIENT fieldsForTicket:ticket completion:^(NSArray *fields, NSError *error) {
                fieldsDictionary[ticket.ticketId] = fields;
                loadedItems++;
                
                if (error) // any error should be enough
                    bError = error;
                
                if (loadedItems == itemsToLoad)
                    dispatch_semaphore_signal(semaphore);
            }];
        }
    
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        if (completion)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(fieldsDictionary, bError);
            });
        }
    });
}

- (void)updateOrderWithCustomersInfo:(NSDictionary *)customersInfo completion:(void (^)(TXHOrder *order, NSError *error))completion
{
    __weak typeof(self) wself = self;
    
    [TXHTICKETINHGUBCLIENT updateOrder:self.order
                     withCustomersInfo:customersInfo
                            completion:^(TXHOrder *order, NSError *error) {
                                if (order)
                                {
                                    wself.order = order;
                                }
                                
                                if (completion)
                                    completion(order,error);
                            }];
}


#pragma mark private methods


@end
