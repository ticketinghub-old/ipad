//
//  TXHTicket+Title.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 15/04/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHTicket.h"

@interface TXHTicket (Title)

// full name or Ticket refernece
@property (readonly, nonatomic) NSString *title;

@end
