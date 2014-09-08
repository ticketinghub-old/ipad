    //
//  TXHOrderManager.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 26/02/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHOrderManager.h"
#import "TXHTicketingHubManager.h"

NSString * const TXHOrderDidExpireNotification = @"TXHOrderDidExpireNotification";
NSString * const TXHOrderDidChangeNotification = @"TXHOrderDidChangeNotification";

@interface TXHOrderManager ()

@property (strong, nonatomic) TXHOrder *order;

@property (strong, nonatomic) NSDate   *expirationDate;
@property (strong, nonatomic) NSTimer  *expirationTimer;

@property (strong, nonatomic) NSMutableDictionary *storedData;

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
    if (!_order && order)
    {
        self.expirationDate = [[NSDate date] dateByAddingTimeInterval:10*60];
    }
    else if (!order)
    {
        self.tiersQuantities = nil;
        self.expirationDate = nil;
        [self clearStoredData];
    }
    
    _order = order;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TXHOrderDidChangeNotification object:self];
}

- (void)setExpirationDate:(NSDate *)expirationDate
{
    _expirationDate = expirationDate;
    
    [self sheduleExpirationTimer];
}

- (void)invalidateExpirationTimer
{
    if (self.expirationTimer)
    {
        [self.expirationTimer invalidate];
        self.expirationTimer = nil;
    }
}

- (NSMutableDictionary *)storedData
{
    if (!_storedData) {
        _storedData = [NSMutableDictionary dictionary];
    }
    return _storedData;
}

- (void)clearStoredData
{
    [self.storedData removeAllObjects];
}

- (void)stopExpirationTimer
{
    self.expirationDate = nil;
}

- (void)sheduleExpirationTimer
{
    [self invalidateExpirationTimer];
    
    if (self.expirationDate)
    {
        self.expirationTimer = [[NSTimer alloc] initWithFireDate:self.expirationDate
                                                        interval:0
                                                          target:self
                                                        selector:@selector(orderDidExpire:)
                                                        userInfo:nil
                                                         repeats:NO];
        
        [[NSRunLoop currentRunLoop] addTimer:self.expirationTimer forMode:NSRunLoopCommonModes];
    }
}

- (void)orderDidExpire:(NSTimer *)timer
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TXHOrderDidExpireNotification object:self];
}

#pragma mark public methods

- (void)storeValue:(id)value forKey:(NSString *)key
{
    [self.storedData setObject:value forKey:key];
}

- (id)storedValueForKey:(NSString *)key
{
    return self.storedData[key];
}

- (void)resetOrder
{
    self.coupon = nil;
    self.order  = nil;
}

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

- (NSDictionary *)customerErrorsForTicketId:(NSString *)ticketId
{
    for (TXHTicket *ticket in self.order.tickets)
    {
        if ([ticket.ticketId isEqualToString:ticketId]) {
            return ticket.customer.errors;
        }
    }
    return nil;
}

- (void)reserveTicketsWithAvailability:(TXHAvailability *)availability latitude:(CGFloat)latitude longitude:(CGFloat)longitude completion:(TXHOrderCompletion)completion
{
    __weak typeof(self) wself = self;
    
    [self.txhManager.client reserveTicketsWithTierQuantities:self.tiersQuantities
                                                availability:availability
                                                      coupon:self.coupon
                                                    latitude:latitude
                                                   longitude:longitude
                                                     isGroup:YES
                                                shouldNotify:NO
                                                  completion:^(TXHOrder *order, NSError *error) {
                                                      
                                                      if (order)
                                                      {
                                                          wself.order = order;
                                                      }
                                                      
                                                      if (completion)
                                                          completion(order,error);
                                                  }];    
}

- (void)userInfoFieldsForCurrentOrderTicketsWithCompletion:(void(^)(NSDictionary *fields, NSError *error))completion
{
    if (!completion) return;
    
    __weak typeof(self) wself = self;
    __block NSError *bError;
    __block NSMutableDictionary *fieldsDictionary = [NSMutableDictionary dictionary];
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (TXHTicket *ticket in wself.order.tickets)
        {
            dispatch_group_enter(group);
            
            [self.txhManager.client fieldsForTicket:ticket completion:^(NSArray *fields, NSError *error) {
                
                if (fields)
                    fieldsDictionary[ticket.ticketId] = fields;
                
                if (error) // any error should be enough
                    bError = error;
                
                dispatch_group_leave(group);
            }];
        }
        
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(fieldsDictionary, bError);
        });
    });
}

- (void)availableUpgradesForCurrentOrderWithCompletion:(void(^)(NSDictionary *upgrades, NSError *error))completion
{
    if (!completion) return;
    
    __weak typeof(self) wself = self;
    __block NSError *bError;
    __block NSMutableDictionary *upgradesDictionary = [NSMutableDictionary dictionary];
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (TXHTicket *ticket in wself.order.tickets)
        {
            dispatch_group_enter(group);
            
            [self.txhManager.client availableUpgradesForTicket:ticket completion:^(NSArray *upgrades, NSError *error) {

                if ([upgrades count])
                    upgradesDictionary[ticket.ticketId] = upgrades;
                
                if (error)
                    bError = error;
                
                dispatch_group_leave(group);
            }];
        }
        
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(upgradesDictionary, bError);
        });
    });
}

- (void)upgradesForCurrentOrderWithCompletion:(void(^)(NSDictionary *upgrades, NSError *error))completion
{
    if (!completion) return;
    
    __weak typeof(self) wself = self;
    __block NSError *bError;
    __block NSMutableDictionary *upgradesDictionary = [NSMutableDictionary dictionary];
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (TXHTicket *ticket in wself.order.tickets)
        {
            dispatch_group_enter(group);
            
            [self.txhManager.client upgradesForTicket:ticket completion:^(NSArray *upgrades, NSError *error) {
                
                if ([upgrades count])
                    upgradesDictionary[ticket.ticketId] = upgrades;
                
                if (error)
                    bError = error;
                
                dispatch_group_leave(group);
            }];
        }
        
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(upgradesDictionary, bError);
        });
    });
}


- (void)updateOrderWithCustomersInfo:(NSDictionary *)customersInfo completion:(void (^)(TXHOrder *order, NSError *error))completion
{
    __weak typeof(self) wself = self;
    
    [self.txhManager.client updateOrder:self.order
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

- (void)updateOrderWithUpgradesInfo:(NSDictionary *)upgradesInfo completion:(void (^)(TXHOrder *order, NSError *error))completion
{
    __weak typeof(self) wself = self;
    
    [self.txhManager.client updateOrder:self.order
                       withUpgradesInfo:upgradesInfo
                             completion:^(TXHOrder *order, NSError *error) {
                                 if (order)
                                 {
                                     wself.order = order;
                                 }
                                 
                                 if (completion)
                                     completion(order,error);
                             }];
}

- (void)fieldsForCurrentOrderOwnerWithCompletion:(void(^)(NSArray *fields, NSError *error))completion
{
    [self.txhManager.client fieldsForOrderOwner:self.order
                                     completion:^(NSArray *fields, NSError *error) {
                                         completion(fields, error);
                                     }];
    
}

- (void)updateOrderWithOwnerInfo:(NSDictionary *)customersInfo completion:(void (^)(TXHOrder *, NSError *))completion
{
    __weak typeof(self) wself = self;
    
    [self.txhManager.client updateOrder:self.order
                          withOwnerInfo:customersInfo
                             completion:^(TXHOrder *order, NSError *error) {
                                 if (order)
                                 {
                                     wself.order = order;
                                 }
                                 
                                 if (completion)
                                     completion(order,error);
                             }];
}


- (void)updateOrderWithPayment:(TXHPayment *)payment completion:(TXHOrderCompletion)completion;{
    __weak typeof(self) wself = self;
    
    [self.txhManager.client updateOrder:self.order
                            withPayment:payment
                             completion:^(TXHOrder *order, NSError *error) {
                                 if (order)
                                 {
                                     wself.order = order;
                                 }
                                 
                                 if (completion)
                                     completion(order,error);
                             }];
}

- (void)confirmOrderWithCompletion:(void (^)(TXHOrder *, NSError *))completion
{
    __weak typeof(self) wself = self;
    
    [self.txhManager.client confirmOrder:self.order
                              completion:^(TXHOrder *order, NSError *error) {
                                  if (order)
                                  {
                                      wself.order = order;
                                  }
                                  
                                  if (completion)
                                      completion(order,error);
                              }];
}

- (void)downloadReciptWithWidth:(NSUInteger)width dpi:(NSUInteger)dpi format:(TXHDocumentFormat)format completion:(void(^)(NSURL *url, NSError *error))completion
{
    [self.txhManager.client getReciptForOrder:self.order
                                       format:format
                                        width:width
                                          dpi:dpi
                                   completion:completion];
}

- (void)getTicketTemplatesWithCompletion:(TXHArrayCompletion)completion
{
    [self.txhManager.client getTicketTemplatesCompletion:completion];
}

- (void)downloadTicketsWithTemplate:(TXHTicketTemplate *)template format:(TXHDocumentFormat)format completion:(void(^)(NSURL *url, NSError *error))completion
{
    [self.txhManager.client getTicketToPrintForOrder:self.order
                                         withTemplet:template
                                              format:format
                                          completion:completion];
}

- (void)getPaymentGatewaysWithCompletion:(void(^)(NSArray *gateways,NSError *error))completion
{
    [self.txhManager.client getPaymentGatewaysWithCompletion:completion];
}

#pragma mark private methods


@end
