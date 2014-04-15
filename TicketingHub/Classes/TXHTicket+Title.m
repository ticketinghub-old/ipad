//
//  TXHTicket+Title.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 15/04/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHTicket+Title.h"

@implementation TXHTicket (Title)

-(NSString *)title
{
    NSString *title = self.customer.fullName;
    if (![title length])
    {
        if ([self.reference length])
            title = [NSString stringWithFormat:NSLocalizedString(@"TICKET_REFERENCE_TITLE_FORMAT", nil), self.reference];
        else
            title = NSLocalizedString(@"TICKET_TITLE_DEFAULT", nil);
    }
    
    return title;
}

@end
