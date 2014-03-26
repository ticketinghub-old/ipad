//
//  TXHPrinter.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 26/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^TXHPrinterCompletionBlock)( NSError * );
typedef void (^TXHPrinterContinueBlock)(void (^continuePrintingBlock)());

@protocol TXHPrintersEngineProtocol;

@interface TXHPrinter : NSObject

@property (nonatomic, readonly, copy) NSString *displayName;

- (instancetype)initWithPrintersEngine:(id<TXHPrintersEngineProtocol>)engine
                               andName:(NSString *)printerName;

/*  
    printingContinueBlock
    if printer doesnt support automatic cutter,
    this block will be called between each page to give chance to rip it off,
    if block is nil all pages will be printed one after another without any interruptions 
 */
- (void)setPrintingContinueBlock:(TXHPrinterContinueBlock)printContinueBlock;

- (void)printPDFDocument:(id)document completion:(TXHPrinterCompletionBlock)completion;

@end
