//
//  TXHStarIOPrinter.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 26/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHPrinter.h"
#import <StarIO/SMPort.h>

typedef NS_ENUM(NSUInteger, TXHStarPortablePrinterModel)
{
    TXHStarPortablePrinterUnknown,
    TXHStarPortablePrinterSM300i,
    TXHStarPortablePrinterTSP650II
};

typedef NS_ENUM(NSUInteger, TXHStarPortablePrinterType)
{
    TXHStarPortablePrinterTypeUnknown,
    TXHStarPortablePrinterTypePortable,
    TXHStarPortablePrinterTypePOS,
};

@interface TXHStarIOPrinter : TXHPrinter

@property (nonatomic, strong) PortInfo *portInfo;

@property (nonatomic, readonly, assign) TXHStarPortablePrinterModel printerModel;
@property (nonatomic, readonly, assign) TXHStarPortablePrinterType  printerType;


- (instancetype)initWithPrintersEngine:(id<TXHPrintersEngineProtocol>)engine andPortInfo:(PortInfo *)portInfo;

@end
