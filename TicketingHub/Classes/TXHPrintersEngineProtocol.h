//
//  TXHPrintersEngineProtocol.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 26/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TXHPrinter.h"

@protocol TXHPrintersEngineProtocol <NSObject>

- (void)fetchAvailablePrinters:(void(^)(NSArray *printers, NSError *error))completion;

- (void)printPDFDocument:(id)document
             withPrinter:(TXHPrinter *)printer
           continueBlock:(TXHPrinterContinueBlock)continueBlock
         completionBlock:(TXHPrinterCompletionBlock)completionBlock;
@end
