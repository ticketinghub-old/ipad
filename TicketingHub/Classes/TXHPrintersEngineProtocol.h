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

- (void)printPDFDocumentWithURL:(NSURL *)document
                    withPrinter:(TXHPrinter *)printer
                completionBlock:(TXHPrinterCompletionBlock)completionBlock;

- (void)printImageWithURL:(NSURL *)url
              withPrinter:(TXHPrinter *)printer
          completionBlock:(TXHPrinterCompletionBlock)completion;

- (void)openDrawerFromPrinter:(TXHPrinter *)printer
                   completion:(TXHPrinterCompletionBlock)completion;

@end
