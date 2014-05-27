//
//  UIFont+TicketingHub.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 22/05/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "UIFont+TicketingHub.h"

@implementation UIFont (TicketingHub)

+ (UIFont *)txhThinFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"HelveticaNeue-Light" size:size];
}

+ (UIFont *)txhBoldFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"HelveticaNeue-Medium" size:size];
}

@end
