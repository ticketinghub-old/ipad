//
//  TXHStarIOPrinter.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 26/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHStarIOPrinter.h"

@interface TXHStarIOPrinter ()

@property (nonatomic, readwrite, assign) TXHStarPortablePrinterModel printerModel;
@property (nonatomic, readwrite, assign) TXHStarPortablePrinterType  printerType;

@end

@implementation TXHStarIOPrinter

- (instancetype)initWithPrintersEngine:(id<TXHPrintersEngineProtocol>)engine andPortInfo:(PortInfo *)portInfo
{
    if (!(self = [self initWithPrintersEngine:engine andName:portInfo.modelName]))
        return nil;
   
    self.portInfo = portInfo;
    
    return self;
}

- (NSUInteger)paperWidth
{
    switch (self.printerModel)
    {
        case TXHStarPortablePrinterUnknown:
            break;
        case TXHStarPortablePrinterTSP650II:
        case TXHStarPortablePrinterSM300i:
            return 76; // mm, aka 3-inches
    }
    
    return [super paperWidth];
}

- (NSUInteger)dpi
{
    switch (self.printerModel)
    {
        case TXHStarPortablePrinterUnknown:
            break;
        case TXHStarPortablePrinterTSP650II:
        case TXHStarPortablePrinterSM300i:
            return 203;
    }

    return [super paperWidth];
}

- (TXHStarPortablePrinterModel)printerModel
{
    if (_printerModel == TXHStarPortablePrinterUnknown)
    {
        if ([self.displayName isEqualToString:@"SM-T300"])              _printerModel = TXHStarPortablePrinterSM300i;
        else if ([self.displayName isEqualToString:@"Star Micronics"])  _printerModel = TXHStarPortablePrinterTSP650II;

    }
    
    return _printerModel;
}

- (TXHStarPortablePrinterType)printerType
{
    switch (self.printerModel)
    {
        case TXHStarPortablePrinterTSP650II:
            return TXHStarPortablePrinterTypePOS;
        case TXHStarPortablePrinterSM300i:
            return TXHStarPortablePrinterTypePortable;
        case TXHStarPortablePrinterUnknown:
            break;
    }
    
    return TXHStarPortablePrinterTypeUnknown;
}

- (BOOL)hasCutter
{
    switch (self.printerModel)
    {
        case TXHStarPortablePrinterTSP650II:    return YES;
        case TXHStarPortablePrinterSM300i:      return NO;
        case TXHStarPortablePrinterUnknown:
            break;
    }

    return [super hasCutter];
}

- (BOOL)canOpenDrawer
{
    switch (self.printerModel)
    {
        case TXHStarPortablePrinterTSP650II:    return YES;
        case TXHStarPortablePrinterSM300i:      return NO;
        case TXHStarPortablePrinterUnknown:
            break;
    }
    
    return NO;
}

@end
