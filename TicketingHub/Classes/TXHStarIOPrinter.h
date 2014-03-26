//
//  TXHStarIOPrinter.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 26/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHPrinter.h"
#import <StarIO/SMPort.h>

@interface TXHStarIOPrinter : TXHPrinter

@property (nonatomic, strong) PortInfo *portInfo;

@end
