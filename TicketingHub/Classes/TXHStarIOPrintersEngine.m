//
//  TXHStarIOPrintersEngine.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 26/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHStarIOPrintersEngine.h"
#import "TXHStarIOPrinter.h"

@implementation TXHStarIOPrintersEngine

#pragma mark - TXHPrintersEngineProtocol

- (void)fetchAvailablePrinters:(void(^)(NSArray *printers, NSError *error))completion
{
    NSArray *printers = [SMPort searchPrinter:@"BT:"];
    
    NSMutableArray *starPrinters = @[].mutableCopy;
    
    for (PortInfo *portInfo in printers)
    {
        TXHStarIOPrinter *printer = [[TXHStarIOPrinter alloc] initWithPrintersEngine:self andName:portInfo.modelName];
        printer.portInfo = portInfo;
        [starPrinters addObject:printer];
    }
    
    completion([starPrinters copy], nil);
}

- (void)printPDFDocument:(id)document
             withPrinter:(TXHPrinter *)printer
           continueBlock:(TXHPrinterContinueBlock)continueBlock
         completionBlock:(TXHPrinterCompletionBlock)completionBlock
{

}

@end
