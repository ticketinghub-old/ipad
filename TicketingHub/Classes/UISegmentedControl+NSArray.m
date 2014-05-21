//
//  UISegmentedControl+NSArray.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 08/05/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "UISegmentedControl+NSArray.h"

@implementation UISegmentedControl (NSArray)

- (void)setItemsFromArray:(NSArray *)items
{
    [self removeAllSegments];
    
    NSUInteger index = 0;
    
    for (NSString *item in items)
    {
        [self insertSegmentWithTitle:item
                             atIndex:index++
                            animated:NO];
    }
}

@end
