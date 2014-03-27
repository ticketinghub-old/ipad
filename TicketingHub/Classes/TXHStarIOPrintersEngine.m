
//
//  TXHStarIOPrintersEngine.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 26/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHStarIOPrintersEngine.h"
#import "TXHStarIOPrinter.h"

#import "MiniPrinterFunctions.h"
#import "PrinterFunctions.h"

@implementation TXHStarIOPrintersEngine

#pragma mark - TXHPrintersEngineProtocol

- (void)fetchAvailablePrinters:(void(^)(NSArray *printers, NSError *error))completion
{
    NSArray *printers = [SMPort searchPrinter:@"BT:"];
    
    NSMutableArray *starPrinters = @[].mutableCopy;
    
    for (PortInfo *portInfo in printers)
    {
        TXHStarIOPrinter *printer = [[TXHStarIOPrinter alloc] initWithPrintersEngine:self andPortInfo:portInfo];
        [starPrinters addObject:printer];
    }
    
    completion([starPrinters copy], nil);
}

- (void)printPDFDocument:(id)documentURL
             withPrinter:(TXHPrinter *)printer
           continueBlock:(TXHPrinterContinueBlock)continueBlock
         completionBlock:(TXHPrinterCompletionBlock)completionBlock
{
    TXHStarIOPrinter *starPrinter = (TXHStarIOPrinter *)printer;
    
    NSData * imgData = [NSData dataWithContentsOfURL:(NSURL *)documentURL];
    UIImage *img = [UIImage imageWithData:imgData];
    
    if (starPrinter.printerType == TXHStarPortablePrinterTypePortable)
    {
        [MiniPrinterFunctions PrintBitmapWithPortName:starPrinter.portInfo.portName
                                         portSettings:@"mini"
                                          imageSource:img
                                         printerWidth:576
                                    compressionEnable:YES
                                       pageModeEnable:NO];
    }
    else if (starPrinter.printerType == TXHStarPortablePrinterTypePOS)
    {
        [PrinterFunctions PrintImageWithPortname:starPrinter.portInfo.portName
                                    portSettings:@""
                                    imageToPrint:img
                                        maxWidth:576
                               compressionEnable:YES
                                  withDrawerKick:NO];
    }
}

@end
