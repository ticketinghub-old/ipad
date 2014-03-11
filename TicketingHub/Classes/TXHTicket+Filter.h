//
//  TXHTicket+Filter.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 11/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHTicket.h"

@interface TXHTicket (Filter)

+ (NSArray *)filterTickets:(NSArray *)tickets withQuery:(NSString *)string;

@end
