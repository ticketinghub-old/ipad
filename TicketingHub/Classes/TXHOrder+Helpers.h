//
//  TXHOrder+Helpers.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 24/04/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHOrder.h"

@interface TXHOrder (Helpers)

@property (readonly, nonatomic) NSString *displayTitle;

+ (NSArray *)ordersTitles:(NSArray *)orders;

@end
