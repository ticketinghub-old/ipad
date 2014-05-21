//
//  TXHTicket+Filter.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 11/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHTicket+Filter.h"

@implementation TXHTicket (Filter)

+ (NSArray *)filterTickets:(NSArray *)tickets withQuery:(NSString *)string
{
    NSString *predicateFormat =
    @"(customer.fullName CONTAINS[cd] '%1$@') OR "
    @"(customer.firstName CONTAINS[cd] '%1$@') OR "
    @"(customer.lastName CONTAINS[cd] '%1$@') OR "
    @"(customer.email CONTAINS[cd] '%1$@') OR "
    @"(customer.country CONTAINS[cd] '%1$@') OR "
    @"(customer.telephone CONTAINS[cd] '%1$@') OR "
    @"(tier.name CONTAINS[cd] '%1$@') OR"
    @"(tier.tierDescription CONTAINS[cd] '%1$@') OR "
    @"(code = '%1$@')";
    
    NSString *format = [NSString stringWithFormat:predicateFormat, string];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:format];
    
    return [tickets filteredArrayUsingPredicate:predicate];
}

@end
