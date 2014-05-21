//
//  TXHPrinter.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 26/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^TXHPrinterCompletionBlock)(NSError *error, BOOL cancelled);
typedef void (^TXHPrinterContinueBlock)(void (^continuePrintingBlock)(BOOL continuePrinting, BOOL printAll));

@protocol TXHPrintersEngineProtocol;

@interface TXHPrinter : NSObject

@property (nonatomic, readonly, copy) NSString *displayName;

@property (nonatomic, readonly, assign) NSUInteger paperWidth; // in mm
@property (nonatomic, readonly, assign) NSUInteger dpi;

@property (nonatomic, readonly, assign, getter = hasCutter) BOOL cutter;
@property (nonatomic, readonly, assign) BOOL canOpenDrawer;

@property (nonatomic, readonly, copy) TXHPrinterContinueBlock printingContinue;


- (instancetype)initWithPrintersEngine:(id<TXHPrintersEngineProtocol>)engine
                               andName:(NSString *)printerName;

/*  
    printingContinueBlock
    if printer doesnt support automatic cutter,
    this block will be called between each page to give chance to i.e rip it off,
    if block is nil all pages will be printed one after another without any interruptions 
 
    gets called in the main thread
 */
- (void)setPrintingContinueBlock:(TXHPrinterContinueBlock)printContinueBlock;

/*
    printing 
 
    gets called in the main thread
*/
- (void)printPDFDocumentWithURL:(NSURL *)documentURL completion:(TXHPrinterCompletionBlock)completion;


/*
    sends open drawer command to the printer
*/
- (void)openDrawerWithCompletion:(TXHPrinterCompletionBlock)completion;

@end
