//
//  TXHPrintersManager.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 26/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHPrintersManager.h"
#import "NSError+TXHPrinters.h"

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
    if (!completion) return;
    
    __weak typeof(self) wself = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        if (![wself.engines count])
            completion(nil,[NSError printerErrorWithCode:1]);
        
        __block NSError *bError;
        __block NSMutableSet *availablePrinters = [NSMutableSet set];
        
        dispatch_group_t group = dispatch_group_create();
        
        for (id<TXHPrintersEngineProtocol> engine in self.engines)
        {
            dispatch_group_enter(group);
            
            [engine fetchAvailablePrinters:^(NSArray *printers, NSError *error) {
                if (!error)
                    [availablePrinters addObjectsFromArray:printers];
                else
                    bError = error;
                
                dispatch_group_leave(group);
            }];
        }
        
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion([availablePrinters copy],bError);
        });
        
    });
}

- (void)addPrinterEngine:(id<TXHPrintersEngineProtocol>)engine
{
    [self.engines addObject:engine];
}

@end
