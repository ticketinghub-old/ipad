//
//  TXHPrintersManager.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 26/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHPrintersManager.h"

@interface TXHPrintersManager ()

@property (nonatomic, strong) NSMutableSet *engines;

@end

@implementation TXHPrintersManager

- (instancetype)init
{
    if (!(self = [super init]))
        return nil;
    
    _engines = @[].mutableCopy;
    
    return self;
}

+ (instancetype)mainManager
{
    static TXHPrintersManager *_manager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [TXHPrintersManager new];
    });
    
    return _manager;
}

- (void)fetchAvailablePrinters:(void(^)(NSSet *printers, NSError *error))completion
{
    NSParameterAssert(completion);
    
    if (![self.engines count]) {
        completion(nil,[NSError errorWithDomain:@"No engines set" code:1 userInfo:nil]);
    }
    
    __block NSError *bError;
    __block NSMutableSet *availablePrinter = [NSMutableSet set];
    __block NSInteger loadedEngines = 0;

    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSInteger enginesToLoad = [self.engines count];
    
    //TODO: would be better with operation queues
    for (id<TXHPrintersEngineProtocol> engine in self.engines)
    {
        [engine fetchAvailablePrinters:^(NSArray *printers, NSError *error) {

            loadedEngines++;
            if (!error)
            {
                [availablePrinter addObjectsFromArray:printers];
            }
            else
            {
                bError = error;
            }
            
            if (loadedEngines == enginesToLoad)
                dispatch_semaphore_signal(semaphore);

        }];
    }
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    completion([availablePrinter copy],bError);
}

- (void)addPrinterEngine:(id<TXHPrintersEngineProtocol>)engine
{
    [self.engines addObject:engine];
}

@end
