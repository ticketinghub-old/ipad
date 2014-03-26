//
//  TXHPrinter.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 26/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHPrinter.h"
#import "TXHPrintersEngineProtocol.h"

@interface TXHPrinter ()

@property (nonatomic, copy) NSString *displayName;
@property (nonatomic, copy) TXHPrinterContinueBlock printingContinue;
@property (nonatomic, strong) id<TXHPrintersEngineProtocol> printerEngine;

@end

@implementation TXHPrinter

- (instancetype)initWithPrintersEngine:(id<TXHPrintersEngineProtocol>)engine
                               andName:(NSString *)printerName;
{
    if (!(self = [super init]))
        return nil;
    
    _printerEngine = engine;
    _displayName   = printerName;

    return self;
}

- (void)setPrintingContinueBlock:(TXHPrinterContinueBlock)printContinueBlock
{
    self.printingContinue = printContinueBlock;
}

- (void)printPDFDocument:(id)document completion:(TXHPrinterCompletionBlock)completion
{
    [self.printerEngine printPDFDocument:document
                             withPrinter:self
                                continueBlock:self.printingContinue
                         completionBlock:completion];
}

@end
