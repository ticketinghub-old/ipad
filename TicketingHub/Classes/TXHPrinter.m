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

- (void)printPDFDocumentWithURL:(NSURL *)documentURL completion:(TXHPrinterCompletionBlock)completion
{
    [self.printerEngine printPDFDocumentWithURL:documentURL
                                    withPrinter:self
                                completionBlock:completion];
}

- (void)printImageWithURL:(NSURL *)url completion:(TXHPrinterCompletionBlock)completion
{
    [self.printerEngine printImageWithURL:url
                       withPrinter:self
                   completionBlock:completion];
}

- (void)openDrawerWithCompletion:(TXHPrinterCompletionBlock)completion
{
    [self.printerEngine openDrawerFromPrinter:self
                                   completion:completion];
}

- (NSUInteger)paperWidth
{
    return 0;
}

- (NSUInteger)dpi
{
    return 200;
}

- (BOOL)hasCutter
{
    return NO;
}

- (BOOL)canOpenDrawer
{
    return NO;
}

@end
