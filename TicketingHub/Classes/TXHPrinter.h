//
//  TXHPrinter.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 26/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^TXHPrinterCompletionBlock)( NSError * );
typedef void (^TXHPrinterContinueBlock)(void (^continuePrintingBlock)(BOOL continuePrinting));

@protocol TXHPrintersEngineProtocol;

@interface TXHPrinter : NSObject

@property (nonatomic, readonly, copy) NSString *displayName;

@property (nonatomic, readonly, assign) NSUInteger paperWidth; // in mm
@property (nonatomic, readonly, assign) NSUInteger dpi;
@property (nonatomic, readonly, assign, getter = hasCutter) BOOL cutter;


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
