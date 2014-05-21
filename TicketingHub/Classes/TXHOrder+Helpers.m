//
//  TXHOrder+Helpers.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 24/04/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHOrder+Helpers.h"

@implementation TXHOrder (Helpers)

+ (NSArray *)ordersTitles:(NSArray *)orders
{
    NSMutableArray *titles = [NSMutableArray array];

    for (TXHOrder *order in orders)
        [titles addObject:order.displayTitle];

    return titles;
}

- (NSString *)displayTitle
{
    NSString *title;
    
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
