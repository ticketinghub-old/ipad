//
//  TXHPrintersManager.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 26/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TXHPrinter.h"
#import "TXHPrintersEngineProtocol.h"

#define TXHPRINTERSMANAGER [TXHPrintersManager mainManager]

@interface TXHPrintersManager : NSObject

+ (instancetype)mainManager;

- (void)fetchAvailablePrinters:(void(^)(NSSet *printers, NSError *error))completion;
- (void)addPrinterEngine:(id<TXHPrintersEngineProtocol>)engine;

@end
